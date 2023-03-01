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

import 'client_model.dart';

part 'connect_model.freezed.dart';
part 'connect_model.g.dart';

@freezed
class ConnectRequest with _$ConnectRequest {
  const factory ConnectRequest({
    @JsonKey(name: 'from_ip') String? fromIp,
    @JsonKey(name: 'to_ip') String? toIp,
    @JsonKey(name: 'from_data') ClientModel? fromData,
    @JsonKey(name: 'to_data') ClientModel? toData,
  }) = _ConnectRequest;

  factory ConnectRequest.fromJson(Map<String, dynamic> json) =>
      _$ConnectRequestFromJson(json);
}

@freezed
class ConnectResponse with _$ConnectResponse {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ConnectResponse({
    @JsonKey(name: 'from_ip') String? fromIp,
    @JsonKey(name: 'to_ip') String? toIp,
    @JsonKey(name: 'acceptedStatus') bool? acceptedStatus,
  }) = _ConnectResponse;

  factory ConnectResponse.fromJson(Map<String, dynamic> json) =>
      _$ConnectResponseFromJson(json);
}

@freezed
class TransferModel with _$TransferModel {
  const factory TransferModel({
    @JsonKey(name: 'send_model') ClientModel? sendModel,
    @JsonKey(name: 'receiver_model') ClientModel? receiverModel,
  }) = _TransferModel;

  factory TransferModel.fromJson(Map<String, dynamic> json) =>
      _$TransferModelFromJson(json);
}
