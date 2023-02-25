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

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:move_db/move_db.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
class ClientModel with _$ClientModel, MoveObject<ClientModel> {
  @JsonSerializable(
      fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ClientModel({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'client_id') String? clientId,
    @JsonKey(name: 'client_name') String? clientName,
    @JsonKey(name: 'token') String? token,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'platform') String? platform,
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
