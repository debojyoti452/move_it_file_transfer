/*
 * *
 *  * * MIT License
 *  * *******************************************************************************************
 *  *  * Created By Debojyoti Singha
 *  *  * Copyright (c) 2023.
 *  *  * Permission is hereby granted, free of charge, to any person obtaining a copy
 *  *  * of this software and associated documentation files (the "Software"), to deal
 *  *  * in the Software without restriction, including without limitation the rights
 *  *  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  *  * copies of the Software, and to permit persons to whom the Software is
 *  *  * furnished to do so, subject to the following conditions:
 *  *  *
 *  *  * The above copyright notice and this permission notice shall be included in all
 *  *  * copies or substantial portions of the Software.
 *  *  *
 *  *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  *  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  *  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  *  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  *  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  *  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  *  * SOFTWARE.
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

import '../../data/model/client_model.dart';
import '../../data/model/connect_model.dart';
import '../../data/model/file_model.dart';
import '../../data/model/network_address_model.dart';
import '../routes/endpoints.dart';
import '../utils/ip_generator.dart';

abstract class _MoveServerInterface {
  void createServer();

  void stopServer();

  NetworkAddressModel get getLocalAddress;

  Stream<List<ClientModel>> nearbyClients();

  Stream<HttpRequest>? getServerStream();

  void stopNearbyClientsStream();

  void dispose();

  Future<NetworkAddressModel> getOwnServerIpWithPort();

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
    required Function(double, double, FileModel) onProgress,
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
    if (_server != null) {
      return;
    }
    _internetAddress = await getOwnServerIpWithPort();
    log('Server IP: ${_internetAddress.host}:${_internetAddress.port}');
    _server = await HttpServer.bind(
      _internetAddress.host,
      _internetAddress.port!,
    );
    _server?.autoCompress = true;
    _server?.defaultResponseHeaders.add('Access-Control-Allow-Origin', '*');
    _server?.defaultResponseHeaders
        .add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    _server?.defaultResponseHeaders
        .add('content-type', 'application/json; charset=UTF-8');
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
    required Function(double, double, FileModel) onProgress,
    required Function(DownloadStatus) onCompleted,
  }) async {
    try {
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
      debugPrint(
          'parts: ${parts.length} || fileLength: ${request.contentLength}');

      for (var part in parts) {
        debugPrint('part: ${part.headers}');
        final contentDisposition = part.headers['content-disposition'];
        final filename = RegExp(r'filename="([^"]*)"')
            .firstMatch(contentDisposition!)
            ?.group(1);
        final content = await part.toList();

        debugPrint(
            'parts: $part || content: ${content[0].length} || filename: $filename');
        if (filename == null) {
          continue;
        }

        /// calculate download progress
        var downloadProgress = content[0].length / request.contentLength;
        var downPr = (downloadProgress / request.contentLength) * 100;
        debugPrint('downloadProgress: $downPr');

        fileList.add(FileModel(
          fileName: filename,
          fileSize: content[0].length,
          fileStream: File('$uploadDirectory/$filename'),
          isAlreadySend: true,
        ));

        onProgress(
          content[0].length.toDouble(),
          request.contentLength.toDouble(),
          fileList.last,
        );

        await File('$uploadDirectory/$filename').writeAsBytes(content[0]);
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
        '${transferModel.sendModel?.connectUrl}${Endpoints.TRANSFER_FILE}',
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

      debugPrint('response: ${response.data}, updatedList: $fileList');

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
              '${connectRequest.toData?.connectUrl}${Endpoints.REQUEST_CONNECTION}',
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
        fromIp: connectRequest.fromIp,
        toIp: connectRequest.toIp,
        acceptedStatus: true,
      );

      return _dxHttp
          .post(
              '${connectRequest.fromData?.connectUrl}${Endpoints.ACCEPT_CONNECTION}',
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
    var ipList = await IpGenerator.generateListOfLocalIp();
    var ownIp = await IpGenerator.getOwnLocalIpWithPort();
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
      List<NetworkAddressModel> ipList) {
    var dividedList = <List<NetworkAddressModel>>[];
    var temp = <NetworkAddressModel>[];
    for (var i = 0; i < ipList.length; i++) {
      temp.add(ipList[i]);
      if (i % 30 == 0) {
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
      if (_isSameIp(addressModel.host!, ownAddressModel.host!)) {
        return false;
      } else {
        try {
          var socket = await Socket.connect(
            addressModel.host,
            addressModel.port!,
            timeout: const Duration(seconds: 5),
          );
          socket.destroy();
          return true;
        } catch (e) {
          log('Error: $e');
          return false;
        }
      }
    } catch (e) {
      // log('Error: $e');
      return false;
    }
  }

  // check two ip address are same or not
  bool _isSameIp(String host, String ownHost) {
    var hostList = host.split('.').join();
    var ownHostList = ownHost.split('.').join();
    if (hostList == ownHostList) {
      return true;
    }
    return false;
  }
}
