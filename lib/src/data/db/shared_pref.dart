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
    return SharedPref.get<bool>('isAppOnboarded', defaultValue: false) ?? false;
  }

  static Future<bool> setIsAppOnboarded(bool value) async {
    return await SharedPref.set<bool>('isAppOnboarded', value);
  }

  static Future<ClientModel> getUserData() async {
    var sharedModel = SharedPref.get<String>(
      'clientModel',
      defaultValue: NOT_FOUND,
    );

    if (sharedModel == null) {
      return const ClientModel();
    }

    return sharedModel == NOT_FOUND
        ? const ClientModel()
        : ClientModel.fromJson(jsonDecode(sharedModel));
  }

  static Future<bool> setUserData(ClientModel value) async {
    return SharedPref.set<String>('clientModel', jsonEncode(value.toJson()));
  }

  static Future<bool> clearUserData() async {
    return SharedPref.remove('clientModel');
  }

  static Future<bool> clearAll() async {
    return SharedPref.clear();
  }

  static Future<List<ClientModel>> getRecentSearch() async {
    var sharedModel = SharedPref.get<String>(
      'recentSearch',
      defaultValue: NOT_FOUND,
    );
    if (sharedModel == null) {
      return const [];
    }

    List<dynamic> jsonData = sharedModel == NOT_FOUND
        ? const []
        : jsonDecode(sharedModel) as List<dynamic>;

    var data = jsonData.map((e) => ClientModel.fromJson(e)).toList();

    return data;
  }

  static Future<bool> saveRecentSearch(List<ClientModel> value) async {
    return SharedPref.set<String>('recentSearch', jsonEncode(value));
  }
}
