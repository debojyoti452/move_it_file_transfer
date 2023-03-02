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

part 'network_address_model.freezed.dart';
part 'network_address_model.g.dart';

enum NetworkAddressType { ipv4, ipv6 }

@freezed
class NetworkAddressModel with _$NetworkAddressModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory NetworkAddressModel({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'host') String? host,
    @JsonKey(name: 'port') int? port,
    @JsonKey(name: 'path') String? path,
    @JsonKey(name: 'type') NetworkAddressType? type,
  }) = _NetworkAddressModel;

  factory NetworkAddressModel.fromJson(Map<String, dynamic> json) =>
      _$NetworkAddressModelFromJson(json);
}
