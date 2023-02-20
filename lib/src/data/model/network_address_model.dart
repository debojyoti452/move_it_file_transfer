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

part 'network_address_model.freezed.dart';
part 'network_address_model.g.dart';

enum NetworkAddressType { ipv4, ipv6 }

@freezed
class NetworkAddressModel with _$NetworkAddressModel {
  @JsonSerializable(
      fieldRename: FieldRename.snake, explicitToJson: true)
  const factory NetworkAddressModel({
    @JsonKey(name: 'address') String? address,
    @JsonKey(name: 'host') String? host,
    @JsonKey(name: 'port') int? port,
    @JsonKey(name: 'path') String? path,
    @JsonKey(name: 'type') NetworkAddressType? type,
  }) = _NetworkAddressModel;

  factory NetworkAddressModel.fromJson(
          Map<String, dynamic> json) =>
      _$NetworkAddressModelFromJson(json);
}
