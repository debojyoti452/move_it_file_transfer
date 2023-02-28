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

import 'dart:developer';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../data/model/connect_model.dart';
import '../../../../domain/core/move_server_service.dart';
import '../../../../domain/di/move_di.dart';
import '../../../../domain/global/app_cubit_status.dart';
import '../../../../domain/global/base_cubit_wrapper.dart';

part 'transfer_state.dart';

class TransferCubit extends BaseCubitWrapper<TransferState> {
  TransferCubit()
      : super(TransferState(
          status: AppCubitInitial(),
          selectedFileList: [],
        ));

  final MoveServerService moveServerService =
      MoveDI.moveServerService;

  @override
  void initialize() {
    try {
      BotToast.showLoading();
      emitState(state.copyWith(status: AppCubitLoading()));

      emitState(state.copyWith(status: AppCubitSuccess()));
    } catch (e) {
      emitError(
          state.copyWith(status: AppCubitError(message: 'Error')), e);
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

      var clientModel = state.connectRequest!.toData;
      var userModel = state.connectRequest!.fromData;
      var files = state.selectedFileList;
      moveServerService.sendFileToDeviceWithProgress(
        files: files,
        clientModel: clientModel!,
        onProgress: (value) {
          log('Progress: $value');
        },
        userModel: userModel!,
      );

      emitState(state.copyWith(
        status: AppCubitSuccess(),
      ));
    } catch (e) {
      emitError(
          state.copyWith(status: AppCubitError(message: 'Error')), e);
    } finally {
      BotToast.showText(text: 'File sent');
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
        List<File> files =
            result.paths.map((path) => File(path!)).toList();

        var alreadySelectedFiles = state.selectedFileList.toList();
        alreadySelectedFiles.addAll(files);

        emitState(state.copyWith(
          selectedFileList: alreadySelectedFiles,
          status: AppCubitSuccess(),
        ));
      } else {
        // User canceled the picker
        BotToast.showText(
            text: 'No file selected. User cancelled the picker');
      }
    } catch (e) {
      emitError(
          state.copyWith(status: AppCubitError(message: 'Error')), e);
    } finally {
      BotToast.showText(text: 'File selected');
    }
  }

  void removeFileFromQueueList(int index) async {
    var list = state.selectedFileList.toList();
    list.removeAt(index);
    emitState(state.copyWith(
      selectedFileList: list,
    ));
  }

  @override
  void dispose() {}
}
