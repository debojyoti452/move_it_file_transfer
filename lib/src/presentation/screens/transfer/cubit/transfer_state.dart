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

part of 'transfer_cubit.dart';

class TransferState extends Equatable {
  const TransferState({
    required this.status,
    this.connectRequest,
    required this.transferData,
    required this.fileList,
    required this.downloadStatus,
  });

  final AppCubitStatus status;
  final ConnectRequest? connectRequest;
  final TransferModel transferData;
  final List<FileModel> fileList;
  final DownloadStatus downloadStatus;

  @override
  List<Object?> get props => [
        status,
        connectRequest,
        transferData,
        fileList,
        downloadStatus,
      ];

  TransferState copyWith({
    AppCubitStatus? status,
    ConnectRequest? connectRequest,
    TransferModel? transferData,
    List<FileModel>? fileList,
    DownloadStatus? downloadStatus,
  }) {
    return TransferState(
      status: status ?? this.status,
      connectRequest: connectRequest ?? this.connectRequest,
      transferData: transferData ?? this.transferData,
      fileList: fileList ?? this.fileList,
      downloadStatus: downloadStatus ?? this.downloadStatus,
    );
  }
}
