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

import 'package:dx_http/dx_http.dart';

import '../../data/model/client_model.dart';
import '../../data/model/network_address_model.dart';
import '../utils/ip_generator.dart';

abstract class _MoveServerInterface {
  void createServer();

  void startServer();

  void stopServer();

  NetworkAddressModel get getLocalAddress;

  Stream<List<ClientModel>> nearbyClients();

  Stream<HttpRequest>? getServerStream();

  void stopNearbyClientsStream();
}

class MoveServerService extends _MoveServerInterface {
  late NetworkAddressModel _internetAddress;
  HttpServer? _server;
  final DxHttp _dxHttp = DxHttp();
  final StreamController<List<ClientModel>> _nearbyStreamController =
      StreamController.broadcast();

  @override
  void createServer() async {
    _internetAddress = await _generateServerIp();
    log('Server IP: ${_internetAddress.host}:${_internetAddress.port}');
    _server = await HttpServer.bind(
      _internetAddress.host,
      _internetAddress.port!,
    );
    _server?.autoCompress = true;
  }

  @override
  Stream<HttpRequest>? getServerStream() {
    if (_server == null) {
      log('Server is null');
    }
    return _server?.asBroadcastStream();
  }

  @override
  void startServer() {}

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
  void stopNearbyClientsStream() {
    _nearbyStreamController.close();
  }

  Future<NetworkAddressModel> _generateServerIp() async {
    return await IpGenerator.getOwnLocalIpWithPort();
  }

  void _nearbyClient() async {
    var clients = <ClientModel>[];
    var ipList = await IpGenerator.generateListOfLocalIp();
    for (var address in ipList) {
      var isAvailable = await _isReceiverAvailable(address);
      log('Is Available: $isAvailable address: ${address.address}');
      if (isAvailable) {
        log('Address: ${address.address}');
        var client = await _dxHttp.get(
          '${address.address}/data',
        );
        log('Client: $client');
        clients.add(ClientModel.fromJson(jsonDecode(jsonEncode(client.data))));
        _nearbyStreamController.sink.add(clients);
      }
    }
  }

  /// Check whether any receiver is available
  Future<bool> _isReceiverAvailable(
    NetworkAddressModel addressModel,
  ) async {
    try {
      var socket = await Socket.connect(
        addressModel.host,
        addressModel.port!,
        timeout: const Duration(seconds: 5),
      );
      log('Socket: $socket');
      socket.destroy();
      return true;
    } catch (e) {
      log('Error: $e');
      return false;
    }
  }
}
