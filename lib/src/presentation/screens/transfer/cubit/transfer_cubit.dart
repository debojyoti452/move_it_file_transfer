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
import '../../../../domain/global/app_cubit_status.dart';
import '../../../../domain/global/base_cubit_wrapper.dart';

part 'transfer_state.dart';

class TransferCubit extends BaseCubitWrapper<TransferState> {
  TransferCubit()
      : super(TransferState(
          status: AppCubitInitial(),
          transferData: const TransferModel(),
          fileList: const [],
          downloadStatus: DownloadStatus.initial,
        ));

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

  void updateTransferData(
    List<FileModel> fileList,
    DownloadStatus downloadStatus,
  ) {
    emitState(state.copyWith(
      fileList: fileList,
      downloadStatus: downloadStatus,
    ));
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
  Future<bool> isSenderConnected(String ipAddress) async {
    return await moveServerService.isServerRunning(ipAddress);
  }

  @override
  void dispose() {}
}
