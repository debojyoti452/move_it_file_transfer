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

import 'package:freezed_annotation/freezed_annotation.dart';

import 'client_model.dart';

part 'connect_model.freezed.dart';
part 'connect_model.g.dart';

@freezed
class ConnectRequest with _$ConnectRequest {
  const factory ConnectRequest({
    @JsonKey(name: 'from_ip') String? senderIp,
    @JsonKey(name: 'to_ip') String? receiverIp,
    @JsonKey(name: 'from_data') ClientModel? senderModel,
    @JsonKey(name: 'to_data') ClientModel? receiverModel,
  }) = _ConnectRequest;

  factory ConnectRequest.fromJson(Map<String, dynamic> json) =>
      _$ConnectRequestFromJson(json);
}

@freezed
class ConnectResponse with _$ConnectResponse {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ConnectResponse({
    @JsonKey(name: 'from_ip') String? senderIp,
    @JsonKey(name: 'to_ip') String? receiverIp,
    @JsonKey(name: 'acceptedStatus') bool? acceptedStatus,
  }) = _ConnectResponse;

  factory ConnectResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectResponseFromJson(json);
}

@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    @JsonKey(name: 'sender_model') ClientModel? senderModel,
    @JsonKey(name: 'receiver_model') ClientModel? receiverModel,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}
