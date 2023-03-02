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

part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    required this.status,
    this.userModel,
    this.connectRequestList,
    this.acceptedClientModel,
    this.fileModelList,
    required this.downloadStatus,
  });

  final AppCubitStatus status;
  final ClientModel? userModel;
  final List<ConnectRequest>? connectRequestList;
  final ConnectRequest? acceptedClientModel;
  final List<FileModel>? fileModelList;
  final DownloadStatus downloadStatus;

  @override
  List<Object?> get props => [
        status,
        userModel,
        connectRequestList,
        acceptedClientModel,
        fileModelList,
        downloadStatus,
      ];

  HomeState copyWith({
    AppCubitStatus? status,
    ClientModel? userModel,
    List<ConnectRequest>? connectRequestList,
    ConnectRequest? acceptedClientModel,
    List<FileModel>? fileModelList,
    DownloadStatus? downloadStatus,
  }) {
    return HomeState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      connectRequestList: connectRequestList ?? this.connectRequestList,
      acceptedClientModel: acceptedClientModel ?? this.acceptedClientModel,
      fileModelList: fileModelList ?? this.fileModelList,
      downloadStatus: downloadStatus ?? this.downloadStatus,
    );
  }
}
