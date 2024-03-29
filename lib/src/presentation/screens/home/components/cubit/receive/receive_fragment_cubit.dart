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

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../../data/db/shared_pref.dart';
import '../../../../../../data/model/client_model.dart';
import '../../../../../../data/model/connect_model.dart';
import '../../../../../../domain/global/app_cubit_status.dart';
import '../../../../../../domain/global/base_cubit_wrapper.dart';

part 'receive_fragment_state.dart';

class ReceiveFragmentCubit extends BaseCubitWrapper<ReceiveFragmentState> {
  ReceiveFragmentCubit()
      : super(ReceiveFragmentState(
          status: AppCubitInitial(),
          userModel: const ClientModel(),
          requestList: const [],
          acceptedList: const [],
        ));

  // final MoveServerService _moveServerService = MoveDI.moveServerService;

  @override
  void initialize() async {
    try {
      BotToast.showLoading();
      emitState(state.copyWith(status: AppCubitLoading()));
      var userModel = await LocalDb.getUserData();
      var cachedConnectedList = await getCachedConnectionList();

      emitState(state.copyWith(
        status: AppCubitSuccess(),
        userModel: userModel,
        acceptedList: cachedConnectedList,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emitState(state.copyWith(status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  /// update requested list
  void updateRequestList(List<ConnectRequest> requestList) {
    emitState(state.copyWith(
      status: AppCubitSuccess(),
    ));
    var acceptedList = state.acceptedList.toList();

    /// remove all the request which is already accepted
    requestList.removeWhere(
      (element) => acceptedList.any(
        (item) =>
            item.ipAddress == element.senderModel?.ipAddress &&
            item.clientName == element.senderModel?.clientName,
      ),
    );

    emitState(state.copyWith(
      status: AppCubitSuccess(),
      requestList: requestList,
    ));
  }

  void rejectRequest(ConnectRequest item) {
    try {
      BotToast.showLoading();
      emitState(state.copyWith(status: AppCubitLoading()));
      var requestedList = state.requestList.toList();
      requestedList.remove(item);
      emitState(state.copyWith(
        status: AppCubitSuccess(),
        requestList: state.requestList,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emitState(state.copyWith(status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void acceptRequest(ConnectRequest item) async {
    try {
      BotToast.showLoading();
      emitState(state.copyWith(status: AppCubitLoading()));
      var response =
          await moveServerService.acceptConnectionRequest(connectRequest: item);
      if (response == true) {
        var acceptedList = state.acceptedList.toList();
        var requestedList = state.requestList.toList();
        var itemFromData = item.senderModel?.copyWith(isConnected: true);

        if (acceptedList.any((element) =>
                element.ipAddress == item.senderModel?.ipAddress) ==
            false) {
          acceptedList.add(itemFromData ?? const ClientModel());
          saveConnectionList(model: itemFromData ?? const ClientModel());
        }

        requestedList.remove(item);

        emitState(state.copyWith(
          status: AppCubitSuccess(),
          requestList: requestedList,
          acceptedList: acceptedList,
        ));
      } else {
        emitState(state.copyWith(
          status: AppCubitError(message: 'Request Not Accepted.'),
        ));
      }
      emitState(state.copyWith(
        status: AppCubitSuccess(),
        requestList: state.requestList,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emitState(state.copyWith(status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  /// Refresh Accepted List
  /// and check if the sender is online or not
  /// if not online then remove from the list
  void refreshAcceptedList() async {
    debugPrint('refreshAcceptedList');
    try {
      BotToast.showLoading();
      emitState(state.copyWith(
        status: AppCubitLoading(),
      ));
      // var acceptedList = state.acceptedList.toList();
      var acceptedList = await getCachedConnectionList();
      var updatedList = <ClientModel>[];
      for (var item in acceptedList) {
        var isOnline = await isSenderConnected(item.ipAddress ?? '');
        if (isOnline == true) {
          updatedList.add(item.copyWith(isConnected: true));
        }
      }
      emitState(state.copyWith(
        status: AppCubitSuccess(),
        acceptedList: updatedList,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emitState(state.copyWith(status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  @override
  Future<bool> isSenderConnected(String ipAddress) async {
    return await moveServerService.isServerRunning(ipAddress);
  }

  @override
  void dispose() {}
}
