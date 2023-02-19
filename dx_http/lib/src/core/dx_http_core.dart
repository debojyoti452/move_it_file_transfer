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
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/response.dart';
import '../utils/helper.dart';

class DxHttpCore {
  late final HttpClient _httpClients;

  DxHttpCore() {
    _httpClients = HttpClient();
    _httpClients.autoUncompress = true;
    _httpClients.idleTimeout = const Duration(seconds: 30);
    _httpClients.connectionTimeout =
        const Duration(seconds: 30);
    _httpClients.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      return true;
    };
  }

  Future<Response<T>> get<T>(
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

    var responseModel = Response<T>(
      data: responseBody as T,
      headers: Helper.decodeHeader(response.headers),
      statusCode: response.statusCode,
    );

    return responseModel;
  }

  Future<Response<String>> post(
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
    } else {
      request.headers.add(
        HttpHeaders.contentTypeHeader,
        'application/json; charset=UTF-8',
      );
    }

    if (params != null) {
      request.write(json.encode(params));
    }

    final response = await request.close();
    final responseBody =
        await response.transform(utf8.decoder).join();

    var responseModel = Response<String>(
      data: responseBody,
      headers: Helper.decodeHeader(response.headers),
      statusCode: response.statusCode,
    );

    return responseModel;
  }

  Future<Response<T>> download<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
  }) async {
    var downloadData = '';

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

    HttpClientResponse response = await request.close();
    // final responseBody =
    //     await consolidateHttpClientResponseBytes(response);

    response.transform(utf8.decoder).toList().then((value) {
      var responseBody = value.join('');
      debugPrint(responseBody);
      downloadData = responseBody;
    });

    return Response<T>(
      data: downloadData as T,
      headers: Helper.decodeHeader(response.headers),
      statusCode: response.statusCode,
    );
  }

  Future<Response<T>> downloadFile<T>(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? params,
    String? savePath,
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

    HttpClientResponse response = await request.close();
    final responseBody =
        await consolidateHttpClientResponseBytes(response);

    var path =
        savePath ?? await Helper.getFileNameFromUrl(url);
    var files = File(path);

    List<List<int>> chunks = [];
    int offset = 0;
    for (var chunk in chunks) {
      responseBody.setRange(
          offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }
    await files.writeAsBytes(responseBody);

    return Response<T>(
      data: files as T,
      headers: Helper.decodeHeader(response.headers),
      statusCode: response.statusCode,
      statusMessage: 'File saved',
    );
  }
}
