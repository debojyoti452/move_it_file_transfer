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

import 'dart:convert';
import 'dart:developer';

import 'package:dx_http/dx_http.dart';
import 'package:flutter/material.dart';
import 'package:move_app_fileshare/src/data/model/client_model.dart';
import 'package:move_app_fileshare/src/domain/core/move_server_service.dart';
import 'package:move_app_fileshare/src/domain/services/send_receive_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SendReceiverService _sendReceiverService = SendReceiverService();
  final baseUrl = 'https://reqres.in/api/';
  final MoveServerService _moveServerService = MoveServerService();
  final DxHttp _dxHttp = DxHttp();

  @override
  void initState() {
    super.initState();
    // _sendReceiverService.createServer();
  }

  void runServer() {
    try {
      _moveServerService.createServer();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        _moveServerService.getServerStream()?.listen((event) async {
          switch (event.requestedUri.path) {
            case '/data':
              var clientModel = const ClientModel(
                clientId: '62146514',
                clientName: 'Ananya',
                ipAddress: '2565413',
                token: '123456',
              );
              event.response.write(jsonEncode(clientModel.toJson()));
              event.response.close();
              break;
            case '/getData':
              event.response.write('Data Saved');
              event.response.close();
              break;
            default:
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                // _sendReceiverService.createServer();
                runServer();
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Text('Create Server'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                var data = await _dxHttp
                    .get('${_moveServerService.getLocalAddress.address}/data');
                log(data.data);
                // _sendReceiverService.send();
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Text('Send'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                // _sendReceiverService.receive();
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Text('Receive'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                _moveServerService.nearbyClients().listen((event) {
                  log('Nearby Client: $event');
                });
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Text('Test DxHttp'),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _moveServerService.stopServer();
    super.dispose();
  }
}
