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
