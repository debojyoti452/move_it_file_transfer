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

import 'dart:isolate';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../data/db/shared_pref.dart';
import '../../../../../../data/model/client_model.dart';
import '../../../../../../data/model/connect_model.dart';
import '../../../../../../domain/di/move_di.dart';
import '../../../../../../domain/global/app_cubit_status.dart';
import '../../../../../../domain/global/base_cubit_wrapper.dart';

part 'send_fragment_state.dart';

class SendFragmentCubit extends BaseCubitWrapper<SendFragmentState> {
  SendFragmentCubit()
      : super(SendFragmentState(
          status: AppCubitInitial(),
          nearbyClients: [],
          userModel: const ClientModel(),
        ));

  ReceivePort receivePort = ReceivePort();
  Isolate? searchAlgoIsolate;

  @override
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
      emit(state.copyWith(status: AppCubitError(message: e.toString())));
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
      searchAlgoIsolate = await Isolate.spawn(_computeSearchDeviceInBg, args);

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
        if (nearbyClients
            .any((element) => element.ipAddress == element.ipAddress)) {
          continue;
        }
        if (nearbyClients.contains(element) == false) {
          nearbyClients.add(element);
        }
      }
      args.sendPort?.send(nearbyClients);
    });
  }

  @override
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
          senderModel: userModel,
          receiverModel: clientModel,
          senderIp: userModel.ipAddress,
          receiverIp: clientModel.ipAddress,
        ),
      );

      emit(state.copyWith(status: AppCubitSuccess()));
    } catch (e) {
      debugPrint('SendFragmentState: sendDataToDevice: $e');
    } finally {
      BotToast.closeAllLoading();
    }
  }

  Future<void> updateAcceptedRequestClient(
      {required ConnectRequest model}) async {
    try {
      BotToast.showLoading();
      emit(state.copyWith(status: AppCubitLoading()));
      var dataList = state.nearbyClients;

      var nearbyClients = dataList.firstWhere(
          (element) => element.ipAddress == model.receiverIp,
          orElse: () => const ClientModel());

      dataList.removeWhere((element) => element.ipAddress == model.receiverIp);

      var updatedNearbyClient = nearbyClients.copyWith(
        isConnected: true,
      );
      dataList.add(updatedNearbyClient);

      emit(state.copyWith(nearbyClients: dataList, status: AppCubitSuccess()));
    } catch (e) {
      debugPrint('SendFragmentState: updateAcceptedRequestClient: $e');
      emit(state.copyWith(
        status: AppCubitError(message: e.toString()),
      ));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  @override
  Future<bool> isSenderConnected(String ipAddress) async {
    return await moveServerService.isServerRunning(ipAddress);
  }
}

class BgMethodModel {
  final List<ClientModel> dataList;
  final SendPort? sendPort;

  BgMethodModel({required this.dataList, required this.sendPort});
}
