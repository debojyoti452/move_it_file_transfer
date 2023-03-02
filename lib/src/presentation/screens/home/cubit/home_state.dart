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
