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
import 'package:shared_preferences/shared_preferences.dart';

class SendReceiverService {
  late HttpServer _server;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _dxHttp = DxHttp();

  void createServer() async {
    var ip = await getIp();
    if (ip.isEmpty) {
      log('No IP found');
      return;
    }
    _server = await HttpServer.bind(ip.first, 8080);
    _server.listen((HttpRequest event) async {
      log('Request: ${event.requestedUri.path}');
      switch (event.requestedUri.path) {
        case '/data':
          // post data

          var response = await event.asyncMap((element) async {
            // convert utf8list to string
            var data = utf8.decode(element);
            return data;
          }).first;

          _writeItOnPref(jsonEncode(response));
          event.response.write('Data Saved');
          event.response.close();
          break;
        case '/getData':
          var data = await _readItFromFile();
          event.response
              .writeln('Received request ${event.method}: ${event.uri.path}');
          event.response.writeln(data);
          event.response.close();
          break;
        default:
      }
    });
    log('Server started at ${_server.address} port ${_server.port}');
  }

  void _writeItOnPref(String data) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('data', data);
  }

  Future<String> _readItFromFile() async {
    final sharedPrefs = await _prefs;
    return sharedPrefs.getString('data') ?? 'Not Found';
  }

  void send() async {
    var dataMap = {
      'name': 'Debojyoti Singha',
      'spouse': 'Ananya Singha',
      'age': 27,
      'prof': 'Developer'
    };
    // send data
    var url = 'http://${_server.address.host}:${_server.port}/data';
    var response = await _dxHttp.post(
      url,
      params: dataMap,
    );
    log('Response: ${response.statusCode}');
  }

  void receive() async {
    // check if server is running
    var localIp = 'http://192.168.0.201:8080/getData';
    try {
      var response = await _dxHttp.get(localIp);
      log('Response: ${response.data}');
    } catch (e) {
      log('Server not running');
    }
  }

  /// dio download
  void download() async {
    var url = Uri.parse('http://');
    var savePath = 'C:\\Users\\Debojyoti Singha\\Downloads\\';
    var fileName = 'test.txt';
    var dio = Dio();
    try {
      await dio.download(url.toString(), savePath + fileName,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          log('${(received / total * 100).toStringAsFixed(0)}%');
        }
      });
    } catch (e) {
      log('Download failed: $e');
    }
  }

  Future<List<String>> getIp() async {
    var ip = <String>[];
    var interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var networkAddress in interface.addresses) {
        if (networkAddress.type == InternetAddressType.IPv4 &&
            networkAddress.address.startsWith('192.168')) {
          ip.add(networkAddress.address);
        }
      }
    }
    log('IP: $ip');
    return ip;
  }
}
