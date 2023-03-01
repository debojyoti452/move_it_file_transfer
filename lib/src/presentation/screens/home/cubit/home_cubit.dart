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

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/db/shared_pref.dart';
import '../../../../data/model/client_model.dart';
import '../../../../data/model/connect_model.dart';
import '../../../../data/model/file_model.dart';
import '../../../../domain/core/move_server_service.dart';
import '../../../../domain/di/move_di.dart';
import '../../../../domain/global/app_cubit_status.dart';
import '../../../../domain/global/status_code.dart';
import '../../../../domain/routes/endpoints.dart';
import '../../../../domain/utils/helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(HomeState(
          status: AppCubitInitial(),
          connectRequestList: [],
          userModel: const ClientModel(),
          fileModelList: [],
        ));

  final MoveServerService moveServerService = MoveDI.moveServerService;

  void initialHome() async {
    emit(HomeState(status: AppCubitLoading()));
    try {
      BotToast.showLoading();
      var ownIp = await moveServerService.getOwnServerIpWithPort();
      if (LocalDb.isAppOnboarded()) {
        var userData = await LocalDb.getUserData();
        var updatedData = userData.copyWith(
          ipAddress: '${ownIp.host}',
          connectUrl: 'http://${ownIp.host}:${ownIp.port}',
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
          connectUrl: 'http://${ownIp.host}:${ownIp.port}',
          token: 'NO_TOKEN_YET',
          platform: Platform.operatingSystem,
        );
        await LocalDb.setUserData(userModel);
        await LocalDb.setIsAppOnboarded(true);
      }
      moveServerService.createServer();
      emit(HomeState(status: AppCubitSuccess()));
    } catch (e) {
      debugPrint('SendFragmentState: initialHome: $e');
      emit(HomeState(status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
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
          var myUserData = await LocalDb.getUserData();
          request.response.write(jsonEncode(myUserData.toJson()));
          request.response.close();
          break;

        case Endpoints.TRANSFER_FILE:
          if (request.method == Methods.POST) {
            var response =
                await moveServerService.receiveFileFromDeviceWithProgress(
              request: request,
              onProgress: (val) {},
            );
            updateFileTransferProgress(response);
          }
          break;
      }
    });
  }

  /// Update file transfer progress
  void updateFileTransferProgress(List<FileModel> fileList) {
    emit(state.copyWith(status: AppCubitLoading()));
    var fileModelList = state.fileModelList ?? [];
    fileModelList.addAll(fileList);
    emit(state.copyWith(
      fileModelList: fileList,
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
}
