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

import 'package:network_info_plus/network_info_plus.dart';

import '../core/move_server_service.dart';

class MoveDI {
  static final MoveDI _singleton = MoveDI._internal();

  factory MoveDI() {
    return _singleton;
  }

  MoveDI._internal();

  static MoveServerService? _moveServerService;
  static NetworkInfo? _networkInfo;

  static MoveServerService get moveServerService {
    if (_moveServerService == null) {
      init();
    }
    return _moveServerService!;
  }

  static NetworkInfo get networkInfo {
    if (_networkInfo == null) {
      init();
    }
    return _networkInfo!;
  }

  static void init() {
    _moveServerService = MoveServerService();
    _networkInfo = NetworkInfo();
  }

  void dispose() {
    _moveServerService?.dispose();
  }
}
