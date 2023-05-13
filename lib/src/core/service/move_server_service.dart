/*
 * *
 *  * * GNU General Public License v3.0
 *  * *******************************************************************************************
 *  *  * Created By Debojyoti Singha
 *  *  * Copyright (c) 2023.
 *  *  * This program is free software: you can redistribute it and/or modify
 *  *  * it under the terms of the GNU General Public License as published by
 *  *  * the Free Software Foundation, either version 3 of the License, or
 *  *  * (at your option) any later version.
 *  *  *
 *  *  * This program is distributed in the hope that it will be useful,
 *  *  *
 *  *  * but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  *  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  *  * GNU General Public License for more details.
 *  *  *
 *  *  * You should have received a copy of the GNU General Public License
 *  *  * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *  *  * Contact Email: support@swingtechnologies.in
 *  * ******************************************************************************************
 *
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dx_http/dx_http.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/constants/app_constants.dart';
import '../../data/model/client_model.dart';
import '../../data/model/connect_model.dart';
import '../../data/model/file_model.dart';
import '../../data/model/network_address_model.dart';
import '../../domain/native/native_calls.dart';
import '../../domain/routes/endpoints.dart';
import '../../domain/utils/ip_generator.dart';

abstract class _MoveServerInterface {
  void createServer();

  void stopServer();

  NetworkAddressModel get getLocalAddress;

  Stream<List<ClientModel>> nearbyClients();

  Stream<HttpRequest>? getServerStream();

  void stopNearbyClientsStream();

  void dispose();

  Future<NetworkAddressModel> getOwnServerIpWithPort();

  Future<bool> isServerRunning(String ipAddress);

  Future<bool> sendRequestToDevice({
    required ConnectRequest connectRequest,
  });

  Future<bool> acceptConnectionRequest({
    required ConnectRequest connectRequest,
  });

  Future<List<FileModel>> sendFileToDeviceWithProgress({
    required TransferModel transferModel,
    required List<FileModel> fileList,
    required Function(int) onProgress,
  });

  Future<List<FileModel>> receiveFileFromDeviceWithProgress({
    String? savePath,
    required HttpRequest request,
    required Function(double, double, List<FileModel>) onProgress,
    required Function(DownloadStatus) onCompleted,
  });
}

enum DownloadStatus { initial, downloading, completed, failed }

class MoveServerService extends _MoveServerInterface {
  late NetworkAddressModel _internetAddress;
  HttpServer? _server;
  final DxHttp _dxHttp = DxHttp();
  final StreamController<List<ClientModel>> _nearbyStreamController =
      StreamController.broadcast();

  @override
  void createServer() async {
    runZonedGuarded(() async {
      // final securityContextResult = generateSecurityContext();
      if (_server != null) {
        return;
      }
      _internetAddress = await getOwnServerIpWithPort();
      _server = await HttpServer.bind(
        _internetAddress.host,
        _internetAddress.port ?? AppConstants.PORT,
      );
      _server?.autoCompress = true;
      _server?.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
      _server?.defaultResponseHeaders.add(
          'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
      _server?.defaultResponseHeaders
          .add('content-type', 'application/json; charset=UTF-8');

      debugPrint(
          'Server started at ${_internetAddress.host}:${_internetAddress.port} without security context.');
    }, (error, stack) {
      debugPrint('Server error: $error || $stack');
    });
  }

  @override
  Stream<HttpRequest>? getServerStream() {
    if (_server == null) {
      log('Server is null');
    }
    return _server?.asBroadcastStream();
  }

  @override
  void stopServer() {
    _server?.close();
    _nearbyStreamController.close();
  }

  @override
  NetworkAddressModel get getLocalAddress => _internetAddress;

  @override
  Stream<List<ClientModel>> nearbyClients() {
    _nearbyClient();
    return _nearbyStreamController.stream.asBroadcastStream();
  }

  @override
  Future<List<FileModel>> receiveFileFromDeviceWithProgress({
    String? savePath,
    required HttpRequest request,
    required Function(double, double, List<FileModel>) onProgress,
    required Function(DownloadStatus) onCompleted,
  }) async {
    try {
      debugPrint(
          'Receiving file from device, Request: ${request.response.contentLength}');
      onCompleted(DownloadStatus.downloading);
      List<int> dataBytes = [];
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String basePath = savePath ?? '${appDocDir.path}/move_download/';
      Directory(basePath).createSync(recursive: true);

      await request.forEach((element) {
        dataBytes.addAll(element);
      });

      String? boundary = request.headers.contentType?.parameters['boundary'];
      if (boundary == null) {
        return [];
      }
      final transformer = MimeMultipartTransformer(boundary);
      final bodyStream = Stream.fromIterable([dataBytes]);
      final parts = await transformer.bind(bodyStream).toList();
      var uploadDirectory = basePath;
      var fileList = <FileModel>[];

      for (var part in parts) {
        final contentDisposition = part.headers['content-disposition'];
        final filename = RegExp(r'filename="([^"]*)"')
            .firstMatch(contentDisposition!)
            ?.group(1);
        final content = await part.toList();

        if (filename == null) {
          continue;
        }

        fileList.add(FileModel(
          fileName: filename,
          fileSize: content[0].length,
          fileStream: File('$uploadDirectory/$filename'),
          isAlreadySend: true,
        ));

        onProgress(
          content[0].length.toDouble(),
          request.contentLength.toDouble(),
          fileList,
        );
        log('extension: ${filename.split('.').last} || size: ${content[0].length} || path: $uploadDirectory');
        var tempFile =
            await File('$uploadDirectory/$filename').writeAsBytes(content[0]);

        NativeCalls.saveFileMethod(
          fileName: filename,
          fileExtension: filename.split('.').last,
          filePath: tempFile.path,
        );
      }

      request.response.close();
      return Future.value(fileList);
    } catch (e) {
      debugPrint(e.toString());
      onCompleted(DownloadStatus.failed);
      return Future.value([]);
    } finally {
      onCompleted(DownloadStatus.completed);
    }
  }

  @override
  Future<List<FileModel>> sendFileToDeviceWithProgress({
    required TransferModel transferModel,
    required List<FileModel> fileList,
    required Function(int) onProgress,
  }) async {
    try {
      var filesToSend = <MultipartFile>[];
      for (FileModel element in (fileList)) {
        if (element.isAlreadySend == true) {
          continue;
        }
        if (element.fileStream.existsSync()) {
          filesToSend.add(await MultipartFile.fromFile(
            element.fileStream.path,
            filename: element.fileName,
          ));
        }
      }
      if (filesToSend.isEmpty) {
        return Future.value([]);
      }

      var formData = FormData.fromMap({
        'files': filesToSend,
        'transfer_data': jsonEncode(transferModel.toJson()),
      });

      var response = await Dio().post(
        '${transferModel.senderModel?.connectUrl}${Endpoints.TRANSFER_FILE}',
        data: formData,
        onSendProgress: (int sent, int total) {
          /// convert to percentage
          var percentage = (sent / total) * 100;
          onProgress(percentage.toInt());
        },
      );

      for (var element in fileList) {
        var updatedElement = element.copyWith(isAlreadySend: true);
        fileList[fileList.indexOf(element)] = updatedElement;
      }

      return Future.value(fileList);
    } catch (e) {
      debugPrint(e.toString());
      return Future.value([]);
    }
  }

  @override
  Future<bool> sendRequestToDevice({
    required ConnectRequest connectRequest,
  }) {
    try {
      return _dxHttp
          .post(
              '${connectRequest.receiverModel?.connectUrl}${Endpoints.REQUEST_CONNECTION}',
              params: connectRequest.toJson())
          .then((value) {
        return Future.value(true);
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  Future<bool> acceptConnectionRequest({
    required ConnectRequest connectRequest,
  }) {
    try {
      var response = ConnectResponse(
        senderIp: connectRequest.senderIp,
        receiverIp: connectRequest.receiverIp,
        acceptedStatus: true,
      );

      return _dxHttp
          .post(
              '${connectRequest.senderModel?.connectUrl}${Endpoints.ACCEPT_CONNECTION}',
              params: response.toJson())
          .then((value) {
        return Future.value(true);
      }).catchError((e) {
        return Future.value(false);
      });
    } catch (e) {
      return Future.value(false);
    }
  }

  @override
  void stopNearbyClientsStream() {
    _nearbyStreamController.close();
  }

  @override
  void dispose() {
    _nearbyStreamController.close();
  }

  @override
  Future<NetworkAddressModel> getOwnServerIpWithPort() async {
    return await IpGenerator.getOwnLocalIpWithPort();
  }

  void _nearbyClient() async {
    var clients = <ClientModel>[];
    var ownIp = await IpGenerator.getOwnLocalIpWithPort();
    var ipList = await IpGenerator.generateListOfLocalIp(host: ownIp.host);
    var dividedIpList = _divideIpList(ipList);

    // run in parallel to check the availability of the receiver
    for (var ip in dividedIpList) {
      await Future.wait(ip.map((e) async {
        var isAvailable = await _isReceiverAvailable(e, ownIp);
        if (isAvailable) {
          debugPrint(
              'Receiver is available: ${e.address}${Endpoints.SEARCH_NEARBY_CLIENTS}');
          var client = await _dxHttp.get(
            '${e.address}${Endpoints.SEARCH_NEARBY_CLIENTS}',
          );
          clients.add(ClientModel.fromJson(jsonDecode(client.data)));
          _nearbyStreamController.sink.add(clients);
        }
      }));
    }
    _nearbyStreamController.sink.done;
  }

  /// Divide the list into 30 parts
  List<List<NetworkAddressModel>> _divideIpList(
    List<NetworkAddressModel> ipList,
  ) {
    var dividedList = <List<NetworkAddressModel>>[];
    var temp = <NetworkAddressModel>[];
    for (var i = 0; i < ipList.length; i++) {
      temp.add(ipList[i]);
      if (i % 50 == 0) {
        dividedList.add(temp);
        temp = <NetworkAddressModel>[];
      }
    }
    return dividedList;
  }

  /// Check whether any receiver is available
  Future<bool> _isReceiverAvailable(
    NetworkAddressModel addressModel,
    NetworkAddressModel ownAddressModel,
  ) async {
    try {
      if (IpGenerator.isSameIp(addressModel.host!, ownAddressModel.host!)) {
        return false;
      } else {
        try {
          var socket = await Socket.connect(
            addressModel.host,
            addressModel.port!,
            timeout: const Duration(seconds: 1),
          );
          socket.destroy();
          return true;
        } catch (e) {
          // log('Error: $e');
          return false;
        }
      }
    } catch (e) {
      // log('Error: $e');
      return false;
    }
  }

  @override
  Future<bool> isServerRunning(String ipAddress) async {
    try {
      var socket = await Socket.connect(
        ipAddress,
        AppConstants.PORT,
        timeout: const Duration(seconds: 5),
      );
      socket.destroy();
      debugPrint('Server is running $ipAddress');
      return Future.value(true);
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(false);
    }
  }
}
