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

import 'package:dx_http/src/models/response.dart';

import '../interface/methods.dart';
import 'dx_http_core.dart';

class DxHttp extends Methods {
  late DxHttpCore _instance;

  /// constructor
  DxHttp() : super() {
    _instance = DxHttpCore();
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) {
    return _instance.get<T>(
      url,
      headers: headers,
      params: params,
    );
  }

  @override
  Future<Response<String>> post(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) {
    return _instance.post(
      url,
      headers: headers,
      params: params,
    );
  }

  @override
  Future<Response<T>> download<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) {
    return _instance.download<T>(
      url,
      headers: headers,
      params: params,
    );
  }

  @override
  Future<Response<File>> downloadFile<File>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    String? savePath,
  }) {
    return _instance.downloadFile<File>(
      url,
      headers: headers,
      params: params,
      savePath: savePath,
    );
  }
}