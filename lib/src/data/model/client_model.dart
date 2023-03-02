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
import 'package:move_db/move_db.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
class ClientModel with _$ClientModel, MoveObject<ClientModel> {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ClientModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'client_id') String? clientId,
    @JsonKey(name: 'client_name') String? clientName,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'connect_url') String? connectUrl,
    @JsonKey(name: 'platform') String? platform,
    @JsonKey(name: 'is_connected', defaultValue: false) bool? isConnected,
  }) = _ClientModel;

  const ClientModel._();

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);

  @override
  Map<String, dynamic> toMoveMap() {
    return toJson();
  }

  /// Temp Solution for MoveDb
  /// Currently MoveDb does not support schemaName using annotation
  @override
  String assignSchemaName() {
    return 'client_schema';
  }

  @override
  ClientModel fromMoveMap(Map<String, dynamic> map) {
    return ClientModel.fromJson(map);
  }
}
