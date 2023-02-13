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
import 'dart:io';

import '../interface/methods.dart';

class _ContinentalCalls {
  late final HttpClient _httpClients;

  _ContinentalCalls() {
    _httpClients = HttpClient();
  }

  Future<T> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    final request =
        await _httpClients.getUrl(Uri.parse(url));
    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });
    }

    /// query parameters
    if (params != null) {
      request.uri.queryParameters
          .addAll(params.cast<String, String>());
    }

    final response = await request.close();
    final responseBody =
        await response.transform(utf8.decoder).join();
    return responseBody as T;
  }

  Future<T> post<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    final request =
        await _httpClients.postUrl(Uri.parse(url));
    if (headers != null) {
      headers.forEach((key, value) {
        request.headers.add(key, value);
      });
    }
    if (params != null) {
      request.write(json.encode(params));
    }
    final response = await request.close();
    final responseBody =
        await response.transform(utf8.decoder).join();
    return responseBody as T;
  }
}

class ContinentalCalls extends Methods {
  static final _ContinentalCalls _instance =
      _ContinentalCalls();

  @override
  Future<Response> get<Response>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) {
    return _instance.get<Response>(
      url,
      headers: headers,
      params: params,
    );
  }

  @override
  Future<Response> post<Response>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) {
    return _instance.post<Response>(
      url,
      headers: headers,
      params: params,
    );
  }
}
