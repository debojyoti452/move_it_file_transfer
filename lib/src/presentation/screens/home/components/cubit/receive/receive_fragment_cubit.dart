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

part 'receive_fragment_state.dart';

class ReceiveFragmentCubit extends Cubit<ReceiveFragmentState> {
  ReceiveFragmentCubit()
      : super(ReceiveFragmentState(
          status: AppCubitInitial(),
          userModel: const ClientModel(),
          requestList: const [],
          acceptedList: const [],
        ));

  final MoveServerService _moveServerService =
      MoveDI.moveServerService;

  void initialize() async {
    try {
      BotToast.showLoading();
      emit(state.copyWith(status: AppCubitLoading()));
      var userModel = await LocalDb.getUserData();
      emit(state.copyWith(
          status: AppCubitSuccess(), userModel: userModel));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  /// update requested list
  void updateRequestList(List<ConnectRequest> requestList) {
    emit(state.copyWith(requestList: requestList));
  }

  void rejectRequest(ConnectRequest item) {
    try {
      BotToast.showLoading();
      emit(state.copyWith(status: AppCubitLoading()));
      emit(state.copyWith(
          status: AppCubitSuccess(), requestList: state.requestList));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void acceptRequest(ConnectRequest item) async {
    try {
      BotToast.showLoading();
      emit(state.copyWith(status: AppCubitLoading()));
      var response = await _moveServerService.acceptConnectionRequest(
          connectRequest: item);
      if (response == true) {
        var acceptedList = state.acceptedList.toList();
        var requestedList = state.requestList.toList();
        var itemFromData = item.fromData?.copyWith(isConnected: true);

        acceptedList.add(itemFromData ?? const ClientModel());
        requestedList.remove(item);

        emit(state.copyWith(
          status: AppCubitSuccess(),
          requestList: requestedList,
          acceptedList: acceptedList,
        ));
      } else {
        emit(state.copyWith(
          status: AppCubitError(message: 'Request Not Accepted.'),
        ));
      }
      emit(state.copyWith(
          status: AppCubitSuccess(), requestList: state.requestList));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(
          status: AppCubitError(message: e.toString())));
    } finally {
      BotToast.closeAllLoading();
    }
  }
}
