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

import 'package:dx_http/dx_http.dart';
import 'package:flutter/material.dart';
import 'package:move_app_fileshare/src/domain/services/send_receive_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SendReceiverService _sendReceiverService =
      SendReceiverService();
  final DxHttp _dxHttp = DxHttp();
  final baseUrl = 'https://reqres.in/api/';

  @override
  void initState() {
    super.initState();
    // _sendReceiverService.createServer();
  }

  void _send() async {
    // var resp = await _dxHttp.post(
    //   '${baseUrl}users',
    //   params: {
    //     'name': 'test',
    //     'price': 100,
    //     'quantity': 10,
    //   },
    // );
    //
    // print(resp.data);
    //
    // var response =
    //     await _dxHttp.get<String>('${baseUrl}users/2');
    // print(response.data);
    //https://tools.learningcontainer.com/sample-json-file.json

    var data = await _dxHttp.downloadFile(
      'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    );

    // var data = await _dxHttp.downloadFile(
    //   'https://tools.learningcontainer.com/sample-json-file.json',
    // );

    print(data.data);
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
                _sendReceiverService.createServer();
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
                _sendReceiverService.send();
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
                _sendReceiverService.receive();
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
                _send();
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
}
