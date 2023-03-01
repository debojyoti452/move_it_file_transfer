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

import 'dart:io';

import 'package:equatable/equatable.dart';

class FileModel extends Equatable {
  final String fileName;
  final File fileStream;
  final int? fileSize;
  final String? fileExtension;
  final bool? isAlreadySend;

  FileModel({
    required this.fileName,
    required this.fileStream,
    this.fileSize,
    this.fileExtension,
    this.isAlreadySend,
  });

  /// copyWith
  FileModel copyWith({
    String? fileName,
    File? fileStream,
    int? fileSize,
    String? fileExtension,
    bool? isAlreadySend,
  }) {
    return FileModel(
      fileName: fileName ?? this.fileName,
      fileStream: fileStream ?? this.fileStream,
      fileSize: fileSize ?? this.fileSize,
      fileExtension: fileExtension ?? this.fileExtension,
      isAlreadySend: isAlreadySend ?? this.isAlreadySend,
    );
  }

  @override
  List<Object?> get props => [
        fileName,
        fileStream,
        fileSize,
        fileExtension,
        isAlreadySend,
      ];
}
