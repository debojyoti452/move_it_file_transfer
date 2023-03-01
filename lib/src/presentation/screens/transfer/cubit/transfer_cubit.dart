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

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../../../data/model/connect_model.dart';
import '../../../../data/model/file_model.dart';
import '../../../../domain/core/move_server_service.dart';
import '../../../../domain/di/move_di.dart';
import '../../../../domain/global/app_cubit_status.dart';
import '../../../../domain/global/base_cubit_wrapper.dart';

part 'transfer_state.dart';

class TransferCubit extends BaseCubitWrapper<TransferState> {
  TransferCubit()
      : super(TransferState(
          status: AppCubitInitial(),
          transferData: const TransferModel(),
          fileList: const [],
        ));

  final MoveServerService moveServerService = MoveDI.moveServerService;
  late StreamController<int> progressStreamController;

  @override
  void initialize() {
    try {
      BotToast.showLoading();
      emitState(state.copyWith(status: AppCubitLoading()));
      progressStreamController = StreamController<int>.broadcast();

      emitState(state.copyWith(
        status: AppCubitSuccess(),
      ));
    } catch (e) {
      emitError(state.copyWith(status: AppCubitError(message: 'Error')), e);
    } finally {
      BotToast.closeAllLoading();
    }
  }

  void updateConnectRequest(ConnectRequest connectRequest) {
    emitState(state.copyWith(connectRequest: connectRequest));
  }

  void sendFile() async {
    try {
      emitState(state.copyWith(
        status: AppCubitLoading(),
      ));

      var transferModel = state.transferData;
      var fileList = state.fileList.toList();

      debugPrint('transferModel: $transferModel');

      if (transferModel.sendModel == null ||
          transferModel.receiverModel == null ||
          (fileList.isEmpty)) {
        BotToast.showText(text: 'No file selected');
        throw Exception('Invalid data');
      }

      var response = await moveServerService.sendFileToDeviceWithProgress(
        fileList: fileList,
        transferModel: transferModel,
        onProgress: (value) {
          log('Progress: $value');
          progressStreamController.sink.add(value);
        },
      );

      debugPrint('response: $response');

      emitState(state.copyWith(
        status: AppCubitSuccess(),
        fileList: response,
      ));
    } catch (e) {
      emitError(state.copyWith(status: AppCubitError(message: 'Error')), e);
    } finally {
      if (state.status is AppCubitSuccess) {
        BotToast.showText(text: 'File sent');
        // progressStreamController.sink.close();
      }
    }
  }

  void openFileExplorer() async {
    try {
      emitState(state.copyWith(
        status: AppCubitLoading(),
      ));
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();

        var selectedList = state.fileList.toList();
        var fileModelList = <FileModel>[];
        for (File element in files) {
          fileModelList.add(FileModel(
            fileName: element.path.split('/').last,
            fileStream: element,
            fileExtension: element.path.split('.').last,
            fileSize: element.lengthSync(),
            isAlreadySend: false,
          ));
        }

        var updatedList = selectedList..addAll(fileModelList);
        var senderModel = state.connectRequest?.toData;
        var receiverModel = state.connectRequest?.fromData;

        progressStreamController.sink.add(0);
        emitState(
          state.copyWith(
            status: AppCubitSuccess(),
            fileList: updatedList,
            transferData: TransferModel(
              sendModel: senderModel,
              receiverModel: receiverModel,
            ),
          ),
        );
      } else {
        // User canceled the picker
        BotToast.showText(text: 'No file selected. User cancelled the picker');
      }
    } catch (e) {
      emitError(state.copyWith(status: AppCubitError(message: 'Error')), e);
    } finally {
      BotToast.showText(text: 'File selected');
    }
  }

  void removeFileFromQueueList(int index) async {
    var list = state.fileList.toList();
    list.removeAt(index);
    emitState(state.copyWith(
      fileList: list,
    ));
  }

  @override
  void dispose() {}
}
