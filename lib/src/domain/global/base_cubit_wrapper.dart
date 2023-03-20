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
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/move_server_service.dart';
import '../di/move_di.dart';
import '../native/native_calls.dart';

abstract class BaseCubitWrapper<T> extends Cubit<T> {
  BaseCubitWrapper(T state) : super(state);

  MoveServerService get moveServerService => MoveDI.moveServerService;

  void initialize();

  void dispose();

  void emitState(T state) {
    emit(state);
  }

  void emitError(T state, Object error) {
    debugPrint(error.toString());
    emit(state);
  }

  Future<bool> isSenderConnected(String ipAddress);

  void logger(dynamic message) {
    debugPrint('[$runtimeType] $message');
  }

  Future<bool> isStoragePermissionGranted() async {
    if (!Platform.isAndroid) return true;
    return await NativeCalls.isStoragePermissionGranted();
  }

  Future<bool> requestStoragePermission() async {
    return await NativeCalls.requestStoragePermission();
  }
}
