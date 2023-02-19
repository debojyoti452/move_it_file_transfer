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

import '../models/response.dart';

enum MethodType {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}

abstract class Methods {
  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String DELETE = 'DELETE';
  static const String PATCH = 'PATCH';

  static String getMethod(MethodType methodType) {
    switch (methodType) {
      case MethodType.GET:
        return GET;
      case MethodType.POST:
        return POST;
      case MethodType.PUT:
        return PUT;
      case MethodType.DELETE:
        return DELETE;
      case MethodType.PATCH:
        return PATCH;
      default:
        return GET;
    }
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  });

  Future<Response<String>> post(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  });

  Future<Response<T>> download<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  });

  Future<Response<File>> downloadFile<File>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    String? savePath,
  });
}
