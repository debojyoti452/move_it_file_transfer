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

import 'package:continental_network/src/interface/methods.dart';

abstract class _Request {
  String get url;

  MethodType get method;

  Map<String, dynamic> get headers;

  Map<String, dynamic> get body;

  int get timeout;

  bool get isMultipart;

  int get contentLength;

  String get contentType;
}

class Request extends _Request {
  String? _url;

  MethodType? _method;

  Map<String, dynamic>? _headers;

  Map<String, dynamic>? _body;

  int? _timeout;

  bool? _isMultipart;

  int? _contentLength;

  String? _contentType;

  @override
  Map<String, dynamic> get body => _body ?? {};

  @override
  int get contentLength => _contentLength ?? 0;

  @override
  String get contentType => _contentType ?? '';

  @override
  Map<String, dynamic> get headers => _headers ?? {};

  @override
  bool get isMultipart => _isMultipart ?? false;

  @override
  MethodType get method => _method ?? MethodType.GET;

  @override
  int get timeout => _timeout ?? 0;

  @override
  String get url => _url ?? '';
}
