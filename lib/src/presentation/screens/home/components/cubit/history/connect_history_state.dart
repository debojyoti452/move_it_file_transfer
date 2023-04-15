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

part of 'connect_history_cubit.dart';

class ConnectHistoryState extends Equatable {
  const ConnectHistoryState({
    required this.status,
    required this.acceptedList,
    required this.userModel,
  });

  final AppCubitStatus status;
  final List<ClientModel> acceptedList;
  final ClientModel userModel;

  @override
  List<Object?> get props => [
        status,
        acceptedList,
        userModel,
      ];

  ConnectHistoryState copyWith({
    AppCubitStatus? status,
    List<ClientModel>? acceptedList,
    ClientModel? userModel,
  }) {
    return ConnectHistoryState(
      status: status ?? this.status,
      acceptedList: acceptedList ?? this.acceptedList,
      userModel: userModel ?? this.userModel,
    );
  }
}
