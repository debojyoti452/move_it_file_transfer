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

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

mixin _IOFileInterface {
  void initAsync();

  void createDb({required String dbName});

  Future<Map<String, dynamic>> serialize(Uint8List bytes);

  Future<Uint8List> deserialize(Map<String, dynamic> map);

  Uint8List readAsBytesSync();

  bool writeAsBytesSync(Uint8List bytes);
}

class FileHelper implements _IOFileInterface {
  final _extension = '.move';
  String _basePath = '';
  late File _file;

  @override
  void initAsync() async {
    var dir = await getApplicationDocumentsDirectory();
    _basePath = '${dir.path}/move_db/';
    Directory(_basePath).createSync(recursive: true);
  }

  @override
  void createDb({required String dbName}) async {
    _file = File('$_basePath$dbName$_extension');
    if (!isFileExist()) {
      _file.createSync();
    }
  }

  bool isFileExist({String? path}) {
    return _file.existsSync();
  }

  @override
  Uint8List readAsBytesSync() {
    return _file.readAsBytesSync();
  }

  @override
  bool writeAsBytesSync(Uint8List bytes) {
    try {
      _file.writeAsBytesSync(bytes, mode: FileMode.write);
      return true;
    } catch (e) {
      debugPrint('FileHelper: $e');
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> serialize(Uint8List bytes) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < bytes.length;) {
      int firstWord = (bytes[i] << 8) + bytes[i + 1];
      if (0xD800 <= firstWord && firstWord <= 0xDBFF) {
        int secondWord = (bytes[i + 2] << 8) + bytes[i + 3];
        buffer.writeCharCode(((firstWord - 0xD800) << 10) +
            (secondWord - 0xDC00) +
            0x10000);
        i += 4;
      } else {
        buffer.writeCharCode(firstWord);
        i += 2;
      }
    }
    // JsonEncoder jsonEncoder = const JsonEncoder.withIndent(' ');
    // var encodeJson = jsonEncoder.convert(buffer.toString());
    // JsonDecoder jsonData = const JsonDecoder();
    // var map = jsonData.convert(encodeJson);
    log('FileHelper: ${buffer.toString()}}');
    return Future.value(
        Map<String, dynamic>.from(jsonDecode(buffer.toString())));
  }

  @override
  Future<Uint8List> deserialize(Map<String, dynamic> map) async {
    var jsonStr = json.encode(map);
    // var getExistedData = readAsBytesSync();
    // if (getExistedData.isNotEmpty) {
    //   jsonStr = jsonStr.substring(1, jsonStr.length - 1);
    // }

    log('FileHelper: $jsonStr');

    var list = <int>[];
    jsonStr.toString().runes.forEach((element) {
      if (element >= 0x10000) {
        element -= 0x10000;
        int firstWord = (element >> 10) + 0xD800;
        list.add(firstWord >> 8);
        list.add(firstWord & 0xFF);
        int secondWord = (element & 0x3FF) + 0xDC00;
        list.add(secondWord >> 8);
        list.add(secondWord & 0xFF);
      } else {
        list.add(element >> 8);
        list.add(element & 0xFF);
      }
    });
    var bytes = Uint8List.fromList(list);
    return bytes;
  }
}
