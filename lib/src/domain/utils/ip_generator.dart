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

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/model/network_address_model.dart';

mixin IpGenerator {
  static const int _port = 4520;

  static Future<List<NetworkAddressModel>> getIpAddress() async {
    var ipList = <NetworkAddressModel>[];
    var interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var networkAddress in interface.addresses) {
        debugPrint('Network Address: ${networkAddress.address}');
        if (networkAddress.type == InternetAddressType.IPv4 &&
            networkAddress.address.startsWith('192.168')) {
          ipList.add(NetworkAddressModel(
            address: 'http://${networkAddress.address}:$_port',
            host: networkAddress.address,
            port: _port,
            type: NetworkAddressType.ipv4,
          ));
        }
      }
    }
    return ipList;
  }

  static Future<NetworkAddressModel> getOwnLocalIpWithPort() async {
    var networkAddress = await getIpAddress();
    return networkAddress[Random().nextInt(networkAddress.length)];
  }

  /// generate list of ip address with port
  static Future<List<NetworkAddressModel>> generateListOfLocalIp() async {
    return List.generate(255, (index) {
      return NetworkAddressModel(
        address: 'http://192.168.0.$index:$_port',
        host: '192.168.0.$index',
        port: _port,
        type: NetworkAddressType.ipv4,
      );
    });
  }

  /// binary search algorithm to find the ip address
  static Future<NetworkAddressModel> getOwnLocalIpWithPortBinarySearch() async {
    var networkAddress = await generateListOfLocalIp();
    var start = 0;
    var end = networkAddress.length - 1;
    while (start <= end) {
      var mid = (start + end) ~/ 2;
      var response = await InternetAddress.lookup(networkAddress[mid].host!);
      if (response.isNotEmpty && response[0].rawAddress.isNotEmpty) {
        return networkAddress[mid];
      } else if (response.isEmpty || response[0].rawAddress.isEmpty) {
        start = mid + 1;
      } else {
        end = mid - 1;
      }
    }
    return networkAddress[0];
  }
}
