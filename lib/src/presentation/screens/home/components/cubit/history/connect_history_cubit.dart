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

import 'package:equatable/equatable.dart';

import '../../../../../../data/db/shared_pref.dart';
import '../../../../../../data/model/client_model.dart';
import '../../../../../../domain/global/app_cubit_status.dart';
import '../../../../../../domain/global/base_cubit_wrapper.dart';

part 'connect_history_state.dart';

class ConnectHistoryCubit extends BaseCubitWrapper<ConnectHistoryState> {
  ConnectHistoryCubit()
      : super(ConnectHistoryState(
          status: AppCubitInitial(),
          acceptedList: [],
          userModel: const ClientModel(),
        ));

  @override
  void initialize() async {
    try {
      emit(state.copyWith(status: AppCubitLoading(), acceptedList: []));
      var acceptedList = await LocalDb.getRecentSearch();
      var userModel = await LocalDb.getUserData();
      emit(state.copyWith(
        status: AppCubitSuccess(),
        acceptedList: acceptedList,
        userModel: userModel,
      ));
    } catch (e) {
      emit(state.copyWith(status: AppCubitError(message: '$e')));
    }
  }

  @override
  void dispose() {}

  @override
  Future<bool> isSenderConnected(String ipAddress) async {
    return await moveServerService.isServerRunning(ipAddress);
  }
}
