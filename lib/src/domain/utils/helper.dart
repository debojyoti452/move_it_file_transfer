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

import 'package:path_provider/path_provider.dart';

import '../../data/constants/assets_constants.dart';
import '../global/base_state_wrapper.dart';

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
        return '/storage/emulated/0/Download/';
      case 'ios':
        return (await getApplicationDocumentsDirectory()).path;
      case 'windows':
      case 'macos':
      case 'linux':
        return (await getDownloadsDirectory())?.path.replaceAll('\\', '/') ??
            'No Download Directory';
      default:
        return '/storage/emulated/0/Download/';
    }
  }
}
