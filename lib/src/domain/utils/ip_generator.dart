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

import 'package:flutter/foundation.dart';

import '../../data/model/network_address_model.dart';

mixin IpGenerator {
  static const int _port = 4520;

  static Future<List<NetworkAddressModel>> getIpAddress() async {
    var ipList = <NetworkAddressModel>[];
    var interfaces = await NetworkInterface.list();
    for (var interface in interfaces) {
      for (var networkAddress in interface.addresses) {
        debugPrint('[GetIpAddress] Network Address: ${networkAddress.address}');
        if (networkAddress.type == InternetAddressType.IPv4) {
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
    var indexOfOwnIp = networkAddress.indexWhere((element) =>
        (element.host?.startsWith('192.') ?? false) ||
        (element.host?.startsWith('172.') ?? false));
    if (indexOfOwnIp != -1) {
      return networkAddress[indexOfOwnIp];
    } else {
      return networkAddress[0];
    }
  }

  /// generate list of ip address with port
  static Future<List<NetworkAddressModel>> generateListOfLocalIp({
    String? host,
  }) async {
    var list = List.generate(256, (index) {
      var host0 = '${host?.split('.').take(3).join('.')}.$index';
      return NetworkAddressModel(
        address: 'http://$host0:$_port',
        host: host0,
        port: _port,
        type: NetworkAddressType.ipv4,
      );
    });
    var updatedList = list.where((element) => element.host != host).toList();
    updatedList.sort((a, b) => a.host!.compareTo(b.host!));
    return updatedList;
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

  /// IP Matcher
  // check two ip address are same or not
  static bool isSameIp(String host, String ownHost) {
    var hostList = host.split('.').join();
    var ownHostList = ownHost.split('.').join();
    if (hostList == ownHostList) {
      return true;
    }
    return false;
  }
}
