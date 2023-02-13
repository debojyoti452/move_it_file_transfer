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

abstract class _Response {
  int get statusCode;

  String get statusMessage;

  dynamic get data;

  Map<String, dynamic> get headers;
}

class Response extends _Response {
  int? _statusCode;
  String? _statusMessage;
  dynamic _data;
  Map<String, dynamic>? _headers;

  Response({
    int? statusCode,
    String? statusMessage,
    dynamic data,
    Map<String, dynamic>? headers,
  }) {
    _statusCode = statusCode;
    _statusMessage = statusMessage;
    _data = data;
    _headers = headers;
  }

  @override
  int get statusCode => _statusCode ?? 404;

  @override
  String get statusMessage => _statusMessage ?? 'Not Found';

  @override
  dynamic get data => _data;

  @override
  Map<String, dynamic> get headers => _headers ?? {};

  @override
  String toString() {
    return 'Response{_statusCode: $_statusCode, _statusMessage: $_statusMessage, _data: $_data, _headers: $_headers}';
  }
}
