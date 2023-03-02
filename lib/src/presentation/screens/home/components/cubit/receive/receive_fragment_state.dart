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

part of 'receive_fragment_cubit.dart';

class ReceiveFragmentState extends Equatable {
  const ReceiveFragmentState({
    required this.status,
    required this.userModel,
    required this.requestList,
    required this.acceptedList,
  });

  final AppCubitStatus status;
  final ClientModel userModel;
  final List<ConnectRequest> requestList;
  final List<ClientModel> acceptedList;

  @override
  List<Object> get props => [
        status,
        userModel,
        requestList,
        acceptedList,
      ];

  ReceiveFragmentState copyWith({
    AppCubitStatus? status,
    ClientModel? userModel,
    List<ConnectRequest>? requestList,
    List<ClientModel>? acceptedList,
  }) {
    return ReceiveFragmentState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      requestList: requestList ?? this.requestList,
      acceptedList: acceptedList ?? this.acceptedList,
    );
  }
}
