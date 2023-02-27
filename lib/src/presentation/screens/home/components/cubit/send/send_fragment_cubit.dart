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

import 'dart:isolate';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../data/db/shared_pref.dart';
import '../../../../../../data/model/client_model.dart';
import '../../../../../../data/model/connect_model.dart';
import '../../../../../../domain/core/move_server_service.dart';
import '../../../../../../domain/di/move_di.dart';
import '../../../../../../domain/global/app_cubit_status.dart';

part 'send_fragment_state.dart';

class SendFragmentCubit extends Cubit<SendFragmentState> {
  SendFragmentCubit()
      : super(SendFragmentState(
          status: AppCubitInitial(),
          nearbyClients: [],
          userModel: const ClientModel(),
        ));

  final MoveServerService moveServerService =
      MoveDI.moveServerService;
  ReceivePort receivePort = ReceivePort();
  Isolate? searchAlgoIsolate;

  void initialize() async {
    emit(state.copyWith(status: AppCubitLoading()));
    try {
      BotToast.showLoading();
      debugPrint(
          'SendFragmentState: initialHome: end ${LocalDb.isAppOnboarded()} user: ${await LocalDb.getUserData()}');

      if (LocalDb.isAppOnboarded() == true) {
        emit(state.copyWith(userModel: await LocalDb.getUserData()));
      }
      emit(state.copyWith(status: AppCubitSuccess()));
    } catch (e) {
      debugPrint('SendFragmentState: initialHome: $e');
      emit(state.copyWith(
          status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void searchNearbyDevices() async {
    if (state.status is AppCubitLoading) {
      return;
    }
    try {
      BotToast.showLoading();
      emit(state.copyWith(status: AppCubitLoading()));

      var nearbyClients = state.nearbyClients;
      final BgMethodModel args = BgMethodModel(
        sendPort: receivePort.sendPort,
        dataList: nearbyClients,
      );

      /// Spawn the isolate
      searchAlgoIsolate =
          await Isolate.spawn(_computeSearchDeviceInBg, args);

      /// Listen to the stream of messages from the isolate
      receivePort.asBroadcastStream().listen((message) {
        if (message is! List<ClientModel>) {
          return;
        }

        for (var element in message) {
          if (nearbyClients.contains(element) == false) {
            nearbyClients.add(element);
          }
        }
        emit(state.copyWith(
          nearbyClients: nearbyClients,
          status: AppCubitSuccess(),
        ));
      }, onDone: () {
        debugPrint('SendFragmentState: searchNearbyDevices: onDone');
      }, onError: (e) {
        debugPrint('SendFragmentState: searchNearbyDevices: $e');
      }, cancelOnError: true);
    } catch (e) {
      debugPrint('SendFragmentState: serverStream: $e');
      emit(state.copyWith(
        status: AppCubitError(message: e.toString()),
      ));
    } finally {
      BotToast.closeAllLoading();
      // dispose();
    }
  }

  static void _computeSearchDeviceInBg(
    BgMethodModel args,
  ) {
    var nearbyClients = args.dataList;
    MoveDI.moveServerService.nearbyClients().listen((event) {
      for (var element in event) {
        if (nearbyClients.any(
            (element) => element.ipAddress == element.ipAddress)) {
          continue;
        }
        if (nearbyClients.contains(element) == false) {
          nearbyClients.add(element);
        }
      }
      args.sendPort?.send(nearbyClients);
    });
  }

  void dispose() {
    moveServerService.dispose();
    receivePort.close();
    searchAlgoIsolate?.kill(priority: Isolate.immediate);
  }

  void sendRequestToDevice({
    required ClientModel clientModel,
  }) {
    try {
      BotToast.showLoading();
      emit(state.copyWith(status: AppCubitLoading()));
      var userModel = state.userModel;
      moveServerService.sendRequestToDevice(
        connectRequest: ConnectRequest(
          fromData: userModel,
          toData: clientModel,
          fromIp: userModel.ipAddress,
          toIp: clientModel.ipAddress,
        ),
      );

      emit(state.copyWith(status: AppCubitSuccess()));
    } catch (e) {
      debugPrint('SendFragmentState: sendDataToDevice: $e');
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void updateAcceptedRequestClient({required ConnectRequest model}) {
    try {
      BotToast.showLoading();
      emit(state.copyWith(status: AppCubitLoading()));
      var dataList = state.nearbyClients;
      var nearbyClients = dataList.firstWhere(
          (element) => element.ipAddress == model.toIp,
          orElse: () => const ClientModel());
      dataList
          .removeWhere((element) => element.ipAddress == model.toIp);

      var updatedNearbyClient = nearbyClients.copyWith(
        isConnected: true,
      );
      dataList.add(updatedNearbyClient);
      emit(state.copyWith(
          nearbyClients: dataList, status: AppCubitSuccess()));
    } catch (e) {
      debugPrint(
          'SendFragmentState: updateAcceptedRequestClient: $e');
      emit(state.copyWith(
        status: AppCubitError(message: e.toString()),
      ));
    } finally {
      BotToast.closeAllLoading();
    }
  }
}

class BgMethodModel {
  final List<ClientModel> dataList;
  final SendPort? sendPort;

  BgMethodModel({required this.dataList, required this.sendPort});
}
