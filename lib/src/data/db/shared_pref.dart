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

import 'package:shared_preferences/shared_preferences.dart';

mixin _SharedPrefInterface {
  T get<T>(String key, {T? defaultValue});

  Future<bool> set<T>(String key, T value);

  Future<bool> remove(String key);

  Future<bool> clear();
}

/// Shared Preference Class
class SharedPref with _SharedPrefInterface {
  /// Singleton instance
  static final SharedPref _instance = SharedPref._internal();

  /// Singleton factory
  factory SharedPref() => _instance;

  /// Private constructor
  SharedPref._internal();

  /// Shared Preference Instance
  late SharedPreferences _sharedPref;

  /// Initialize Shared Preference
  Future<void> init() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  /// Get Shared Preference Instance
  SharedPreferences get sharedPref => _sharedPref;

  @override
  T get<T>(String key, {T? defaultValue}) {
    return _sharedPref.get(key) as T;
  }

  @override
  Future<bool> set<T>(String key, T value) async {
    if (value is String) {
      return await _sharedPref.setString(key, value);
    } else if (value is int) {
      return await _sharedPref.setInt(key, value);
    } else if (value is double) {
      return await _sharedPref.setDouble(key, value);
    } else if (value is bool) {
      return await _sharedPref.setBool(key, value);
    } else if (value is List<String>) {
      return await _sharedPref.setStringList(key, value);
    } else {
      throw Exception('Unsupported type');
    }
  }

  @override
  Future<bool> remove(String key) async {
    return await _sharedPref.remove(key);
  }

  @override
  Future<bool> clear() async {
    return await _sharedPref.clear();
  }
}
