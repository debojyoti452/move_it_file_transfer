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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:move_db/move_db.dart';

import '../utils/file_helper.dart';

abstract class _IOMoveDbInterface {
  void initialize();

  Future<Map<String, dynamic>> findById(int key);

  Future<Map<String, dynamic>> findAll();

  Future<Map<String, dynamic>> getFirst();

  Future<Map<String, dynamic>> getLast();

  Future<Map<String, dynamic>> getSingle();

  Future<int> insert<T>(T data);

  Future<int> update(Map<String, dynamic> data);

  Future<int> deleteByKey(String key);

  Future<int> deleteAll();
}

/// A class to handle all the file operations.
class MoveDb extends _IOMoveDbInterface {
  late FileHelper _fileHelper;

  @override
  void initialize() {
    _fileHelper = FileHelper();
    _fileHelper.initAsync();
  }

  @override
  Future<int> deleteAll() {
    throw UnimplementedError();
  }

  @override
  Future<int> deleteByKey(String key) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> findById(int key) async {
    var bytes = _fileHelper.readAsBytesSync();
    var data = await _fileHelper.serialize(bytes);
    var result = <String, dynamic>{};
    if (data.containsKey('id')) {
      if (data['id'] == key) {
        result = data;
      }
    } else {
      return Future.error(Exception('No data found'));
    }
    return Future.value(result);
  }

  @override
  Future<Map<String, dynamic>> findAll() async {
    var bytes = _fileHelper.readAsBytesSync();
    var serializeMap = await _fileHelper.serialize(bytes);
    return Future.value(serializeMap);
  }

  @override
  Future<Map<String, dynamic>> getFirst() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getLast() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getSingle() {
    throw UnimplementedError();
  }

  @override
  Future<int> insert<T>(T data) async {
    if (data is! MoveObject) {
      throw Exception('Data must be of type MoveObject');
    }
    _fileHelper.createDb(dbName: data.assignSchemaName());
    var bytes = await _fileHelper.deserialize(data.toMoveMap());
    if (_fileHelper.writeAsBytesSync(bytes)) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  Future<int> update(Map<String, dynamic> data) async {
    var bytes = await _fileHelper.deserialize(data);
    debugPrint('bytes: $bytes');
    if (_fileHelper.writeAsBytesSync(bytes)) {
      return 1;
    } else {
      return 0;
    }
  }
}
