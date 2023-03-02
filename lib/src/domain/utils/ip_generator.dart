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
    return List.generate(256, (index) {
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
