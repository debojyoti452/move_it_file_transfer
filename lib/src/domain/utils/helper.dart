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

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/constants/assets_constants.dart';
import '../global/base_state_wrapper.dart';
import '../native/native_calls.dart';

mixin Helper {
  static String generateRandomName() {
    return 'user${Random().nextInt(100000)}';
  }

  static String getIconByPlatform(String platform) {
    var platformType = PlatformType.values.firstWhere(
      (element) => element.toString().split('.').last == platform,
      orElse: () => PlatformType.unknown,
    );
    return AssetsConstants.deviceIconMap[platformType.name] ??
        AssetsConstants.logo;
  }

  static Future<String> getDownloadPath() async {
    switch (Platform.operatingSystem) {
      case 'android':
        return await getAndroidDownloadPath();
      case 'ios':
        return (await getApplicationDocumentsDirectory()).path;
      case 'windows':
      case 'macos':
      case 'linux':
        return (await getDownloadsDirectory())?.path.replaceAll('\\', '/') ??
            'No Download Directory';
      default:
        return await getDownloadPath();
    }
  }

  static Future<String> getAndroidDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        var downloadPath = await NativeCalls.getDownloadPath();
        // directory = Directory(downloadPath);
        // if (!await directory.exists()) {
        //   directory = await getExternalStorageDirectory();
        // }
        directory = Directory(downloadPath);
      }
    } catch (err, stack) {
      debugPrint('Cannot get download folder path $err $stack');
    }
    return directory?.path ?? '/storage/emulated/0/Download';
  }
}
