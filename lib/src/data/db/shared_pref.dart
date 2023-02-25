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
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/client_model.dart';

/// Shared Preference Class
class SharedPref {
  static final SharedPref _sharedPref = SharedPref._internal();

  factory SharedPref() {
    return _sharedPref;
  }

  SharedPref._internal();

  /// Singleton instance
  static late final SharedPreferences instance;

  /// Initialize Shared Preference
  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  static T? get<T>(String key, {T? defaultValue}) {
    if (defaultValue is String) {
      return instance.getString(key) as T?;
    } else if (defaultValue is int) {
      return instance.getInt(key) as T?;
    } else if (defaultValue is double) {
      return instance.getDouble(key) as T?;
    } else if (defaultValue is bool) {
      return instance.getBool(key) as T?;
    } else if (defaultValue is List<String>) {
      return instance.getStringList(key) as T?;
    } else {
      throw Exception('Unsupported type');
    }
  }

  static Future<bool> set<T>(String key, T value) async {
    if (value is String) {
      return await instance.setString(key, value);
    } else if (value is int) {
      return await instance.setInt(key, value);
    } else if (value is double) {
      return await instance.setDouble(key, value);
    } else if (value is bool) {
      return await instance.setBool(key, value);
    } else if (value is List<String>) {
      return await instance.setStringList(key, value);
    } else {
      throw Exception('Unsupported type');
    }
  }

  static Future<bool> remove(String key) async {
    return await instance.remove(key);
  }

  static Future<bool> clear() async {
    return await instance.clear();
  }
}

class LocalDb {
  static const NOT_FOUND = 'NOT_FOUND';

  static bool isAppOnboarded() {
    return SharedPref.get<bool>('isAppOnboarded',
            defaultValue: false) ??
        false;
  }

  static Future<bool> setIsAppOnboarded(bool value) async {
    return await SharedPref.set<bool>('isAppOnboarded', value);
  }

  static Future<ClientModel> getUserData() async {
    var sharedModel = SharedPref.get<String>(
      'clientModel',
      defaultValue: NOT_FOUND,
    );

    return sharedModel == NOT_FOUND
        ? const ClientModel()
        : ClientModel.fromJson(jsonDecode(sharedModel ?? ''));
  }

  static Future<bool> setUserData(ClientModel value) async {
    return SharedPref.set<String>(
        'clientModel', jsonEncode(value.toJson()));
  }
}
