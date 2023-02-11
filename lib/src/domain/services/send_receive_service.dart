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
import 'dart:io';

class SendReceiverService {
  late HttpServer _server;

  void createServer() async {
    var ip = await getIp();
    if (ip.isEmpty) {
      log('No IP found');
      return;
    }
    _server = await HttpServer.bind(ip.first, 8080);
    log('Server started at ${_server.address} port ${_server.port}');
    send();
  }

  void send() async {
    var dataMap = {
      'name': 'Debojyoti Singha',
      'spouse': 'Ananya Singha',
      'age': 45,
    };
    // send data
    var ip = await getIp();
    var client = HttpClient();
    var request = await client
        .postUrl(Uri.parse('http://${ip.first}:8080'));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(jsonEncode(dataMap)));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var res =
          await response.transform(utf8.decoder).join();
      log('$res sent successfully at ${DateTime.now()} from ${ip.first} to ${_server.address} port ${_server.port}');
    }
  }

  void receive() async {
    var ip = await getIp();
    if (ip.isEmpty) {
      log('No IP found');
      return;
    }
    // check if server is running
    var client = HttpClient();
    var request = await client
        .getUrl(Uri.parse('http://192.168.0.201:8080'));
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var data =
          await response.transform(utf8.decoder).join();
      log(data);
    }
  }

  Future<List<String>> getIp() async {
    var ip = <String>[];
    var interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var networkAddress in interface.addresses) {
        if (networkAddress.type ==
                InternetAddressType.IPv4 &&
            networkAddress.address.startsWith('192.168')) {
          ip.add(networkAddress.address);
        }
      }
    }
    log('IP: $ip');
    return ip;
  }
}
