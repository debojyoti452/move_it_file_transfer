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
import 'dart:developer';

import 'package:flutter/services.dart';

class NativeConstant {
  static const String CHANNEL = 'com.swing.moveit/native_call';

  /// Methods
  static const String getDownloadPath = 'getDownloadPath';
  static const String saveFileMethod = 'saveFileMethod';
}

class NativeCalls {
  static const MethodChannel _channel = MethodChannel(NativeConstant.CHANNEL);

  static Future<String> getDownloadPath() async {
    final String result =
        await _channel.invokeMethod(NativeConstant.getDownloadPath);
    log('getDownloadPath: $result');
    return result;
  }

  static Future<bool> saveFileMethod({
    required String fileName,
    required String fileExtension,
    required String filePath,
  }) async {
    final bool result = await _channel
        .invokeMethod(NativeConstant.saveFileMethod, <String, dynamic>{
      'fileName': fileName,
      'fileExtension': fileExtension,
      'filePath': filePath,
    });
    log('getDownloadPath: $result');
    return result;
  }
}
