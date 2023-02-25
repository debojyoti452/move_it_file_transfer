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

import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/db/shared_pref.dart';
import '../../../../data/model/client_model.dart';
import '../../../../domain/core/move_server_service.dart';
import '../../../../domain/di/move_di.dart';
import '../../../../domain/global/app_cubit_status.dart';
import '../../../../domain/routes/endpoints.dart';
import '../../../../domain/utils/helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(status: AppCubitInitial()));

  final MoveServerService moveServerService =
      MoveDI.moveServerService;

  void initialHome() async {
    emit(HomeState(status: AppCubitLoading()));
    try {
      BotToast.showLoading();
      debugPrint(
          'SendFragmentState: initialHome: start ${LocalDb.isAppOnboarded()}');
      var ownIp = await moveServerService.getOwnServerIpWithPort();
      var ownName = Helper.generateRandomName();
      var userModel = ClientModel(
        id: 1,
        clientId: '1',
        clientName: ownName,
        ipAddress: '${ownIp.host}',
        token: 'NO_TOKEN_YET',
        platform: Platform.operatingSystem,
      );
      await LocalDb.setUserData(userModel);
      await LocalDb.setIsAppOnboarded(true);

      debugPrint(
          'SendFragmentState: initialHome: end ${LocalDb.isAppOnboarded()} user: ${await LocalDb.getUserData()}');

      moveServerService.createServer();
      emit(HomeState(status: AppCubitSuccess()));
    } catch (e) {
      debugPrint('SendFragmentState: initialHome: $e');
      emit(HomeState(status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
      debugPrint('SendFragmentState: initialHome: finally');
      Future.delayed(const Duration(seconds: 2), () {
        runServerStream();
      });
    }
  }

  void runServerStream() async {
    moveServerService.getServerStream()?.listen((request) async {
      debugPrint(
          'SendFragmentState: serverStream: ${request.requestedUri.path}');
      switch (request.requestedUri.path) {
        case Endpoints.REQUEST_CONNECTION:
          var myUserData = await LocalDb.getUserData();
          request.response.write(jsonEncode(myUserData.toJson()));
          request.response.close();
          break;

        case Endpoints.ACCEPT_CONNECTION:
          debugPrint(
              'SendFragmentState: serverStream: ACCEPT_CONNECTION: ${request.requestedUri.queryParameters}');
          break;

        case Endpoints.SEARCH_NEARBY_CLIENTS:
          debugPrint(
              'SendFragmentState: serverStream: SEARCH_NEARBY_CLIENTS: ${request.requestedUri.queryParameters}');
          break;

        case Endpoints.SEND_FILE:
          debugPrint(
              'SendFragmentState: serverStream: SEND_FILE: ${request.requestedUri.queryParameters}');
          break;
      }
    });
  }
}
