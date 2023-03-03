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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../data/constants/app_constants.dart';
import '../../../../data/db/shared_pref.dart';
import '../../../../data/model/client_model.dart';
import '../../../../data/model/connect_model.dart';
import '../../../../data/model/file_model.dart';
import '../../../../domain/core/move_server_service.dart';
import '../../../../domain/global/app_cubit_status.dart';
import '../../../../domain/global/base_cubit_wrapper.dart';
import '../../../../domain/global/status_code.dart';
import '../../../../domain/routes/endpoints.dart';
import '../../../../domain/utils/helper.dart';

part 'home_state.dart';

class HomeCubit extends BaseCubitWrapper<HomeState> {
  HomeCubit()
      : super(HomeState(
          status: AppCubitInitial(),
          connectRequestList: [],
          userModel: const ClientModel(),
          fileModelList: [],
          downloadStatus: DownloadStatus.initial,
        ));

  @override
  void initialize() async {
    emit(state.copyWith(status: AppCubitLoading()));
    try {
      BotToast.showLoading();
      var ownIp = await moveServerService.getOwnServerIpWithPort();
      if (LocalDb.isAppOnboarded()) {
        var userData = await LocalDb.getUserData();
        var updatedData = userData.copyWith(
          ipAddress: '${ownIp.host}',
          connectUrl: '${AppConstants.http}${ownIp.host}:${ownIp.port}',
          platform: Platform.operatingSystem,
        );
        await LocalDb.setUserData(updatedData);
      } else {
        var ownName = Helper.generateRandomName();
        var userModel = ClientModel(
          id: 1,
          clientId: '1',
          clientName: ownName,
          ipAddress: '${ownIp.host}',
          connectUrl: '${AppConstants.http}${ownIp.host}:${ownIp.port}',
          token: 'NO_TOKEN_YET',
          platform: Platform.operatingSystem,
        );
        await LocalDb.setUserData(userModel);
        await LocalDb.setIsAppOnboarded(true);
      }
      emit(state.copyWith(
        status: AppCubitSuccess(),
        userModel: await LocalDb.getUserData(),
      ));
    } catch (e) {
      debugPrint('SendFragmentState: initialHome: $e');
      emit(state.copyWith(status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
      moveServerService.createServer();
      Future.delayed(const Duration(seconds: 2), () {
        runServerStream();
      });
    }
  }

  void runServerStream() async {
    moveServerService.getServerStream()?.listen((request) async {
      debugPrint('Requested URI: ${request.requestedUri.path}');
      switch (request.requestedUri.path) {
        case Endpoints.REQUEST_CONNECTION:
          if (request.method == Methods.POST) {
            var body = await utf8.decoder.bind(request).join();
            var data = jsonDecode(body);
            debugPrint('REQUEST_CONNECTION: $data');
            updateConnectRequestModel(ConnectRequest.fromJson(data));
            request.response.write(data);
            request.response.close();
          }
          break;

        case Endpoints.ACCEPT_CONNECTION:
          if (request.method == Methods.POST) {
            var body = await utf8.decoder.bind(request).join();
            var data = jsonDecode(body);
            debugPrint('ACCEPT_CONNECTION: $data');
            updateAcceptRequestModel(ConnectRequest.fromJson(data));
            request.response.write(data);
            request.response.close();
          }
          break;

        case Endpoints.SEARCH_NEARBY_CLIENTS:
          if (request.method == Methods.GET) {
            var myUserData = await LocalDb.getUserData();
            request.response.write(jsonEncode(myUserData.toJson()));
            request.response.close();
          }
          break;

        case Endpoints.TRANSFER_FILE:
          if (request.method == Methods.POST) {
            var savePath = await Helper.getDownloadPath();
            var fileList =
                await moveServerService.receiveFileFromDeviceWithProgress(
              request: request,
              savePath: savePath,
              onProgress: (progress, total, fileModel) {
                debugPrint('File Transfer Progress: $progress/$total');
              },
              onCompleted: (status) {
                debugPrint('File Transfer Completed: $status');
                emitState(state.copyWith(downloadStatus: status));
                switch (status) {
                  case DownloadStatus.downloading:
                    BotToast.showText(text: 'File Transfer Success');
                    break;
                  case DownloadStatus.failed:
                    BotToast.showText(text: 'File Transfer Failed');
                    break;
                  case DownloadStatus.completed:
                    BotToast.showText(text: 'File Transfer Completed');
                    break;
                  case DownloadStatus.initial:
                    debugPrint('File Transfer Initial');
                    break;
                }
              },
            );
            updateFileTransferProgress(fileList);
          }
          break;
      }
    });
  }

  /// Update file transfer progress
  void updateFileTransferProgress(List<FileModel> fileModel) {
    emit(state.copyWith(status: AppCubitLoading()));
    var fileModelList = state.fileModelList ?? [];
    fileModelList.addAll(fileModel);
    // for (var element in fileModel) {
    //   if (fileModelList.contains(element) == false) {
    //     fileModelList.add(element);
    //   }
    // }
    emit(state.copyWith(
      fileModelList: fileModelList,
      status: AppCubitSuccess(
        code: StatusCode.NEW_FILE_RECEIVER,
      ),
    ));
  }

  /// Update the accept request list
  void updateAcceptRequestModel(ConnectRequest model) {
    emit(state.copyWith(status: AppCubitLoading()));
    var connectList = state.connectRequestList ?? [];
    if (connectList.contains(model) == false) {
      connectList.add(model);
    }
    emit(state.copyWith(
      connectRequestList: connectList,
      acceptedClientModel: model,
      status: AppCubitSuccess(
        code: StatusCode.NEW_CONNECTION_ACCEPTED,
      ),
    ));
  }

  /// Update the connect request list
  void updateConnectRequestModel(ConnectRequest model) {
    emit(state.copyWith(status: AppCubitLoading()));
    var connectList = state.connectRequestList ?? [];
    if (connectList.contains(model) == false) {
      connectList.add(model);
    }
    emit(state.copyWith(
      connectRequestList: connectList,
      status: AppCubitSuccess(
        code: StatusCode.NEW_CONNECTION_REQUEST,
      ),
    ));
  }

  @override
  Future<bool> isSenderConnected(String ipAddress) async {
    return await moveServerService.isServerRunning(ipAddress);
  }

  @override
  void dispose() {}
}
