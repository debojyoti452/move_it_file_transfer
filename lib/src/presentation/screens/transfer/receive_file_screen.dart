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

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/model/connect_model.dart';
import '../../../domain/core/move_server_service.dart';
import '../../../domain/global/base_state_wrapper.dart';
import '../../../domain/themes/color_constants.dart';
import '../../../domain/utils/helper.dart';
import '../../widgets/dx_dotted_view.dart';
import '../../widgets/dx_file_transfer_view.dart';
import 'cubit/transfer_cubit.dart';

class ReceiveFileScreen extends StatefulWidget {
  static const id = 'RECEIVE_FILE_SCREEN';

  const ReceiveFileScreen({Key? key}) : super(key: key);

  @override
  _ReceiveFileScreenState createState() => _ReceiveFileScreenState();
}

class _ReceiveFileScreenState extends BaseStateWrapper<ReceiveFileScreen> {
  late TransferCubit _cubit;

  @override
  void onInit() {
    _cubit = context.read<TransferCubit>();
    _cubit.initialize();
  }

  @override
  Widget onBuild(
    BuildContext context,
    BoxConstraints constraints,
    PlatformType platform,
  ) {
    return BlocConsumer<TransferCubit, TransferState>(
      bloc: _cubit,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Receive File',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: Container(
            height: constraints.maxHeight,
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                _userItemView(
                  state.connectRequest ?? const ConnectRequest(),
                ),
                const DxDottedView(),
                SizedBox(
                  height: 10.h,
                ),
                LinearProgressIndicator(
                  value: () {
                    switch (state.downloadStatus) {
                      case DownloadStatus.initial:
                        return 0.0;
                      case DownloadStatus.downloading:
                        return null;
                      case DownloadStatus.completed:
                        return 100.0;
                      case DownloadStatus.failed:
                        return 0.0;
                    }
                  }(),
                  minHeight: 8.h,
                  backgroundColor: ColorConstants.GREY_DARK,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorConstants.PRIMARY_BLUE,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                _fileReceiveList(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _fileReceiveList(TransferState state) {
    return StreamBuilder<int>(
        stream: _cubit.progressStreamController.stream,
        builder: (context, snapshot) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: state.fileList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var item = state.fileList[index];
              if (item.fileStream.existsSync() == false) {
                return Container();
              }
              return DxFileTransferView(
                progress: item.isAlreadySend == true ? 100 : snapshot.data ?? 0,
                fileModel: item,
                onRemoveClick: (deleteIndex) {
                  _cubit.removeFileFromQueueList(deleteIndex);
                },
                index: index,
                isRemoveButtonVisible: false,
              );
            },
          );
        });
  }

  Widget _userItemView(ConnectRequest connectRequest) {
    if (connectRequest.toData == null || connectRequest.fromData == null) {
      BotToast.showText(
        text: 'Something went wrong',
      );
      // Navigator.pop(context);
    }
    var clientModel = connectRequest.toData;
    var userModel = connectRequest.fromData;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: ColorConstants.GREY_DARK,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Helper.getIconByPlatform(
                  userModel?.platform ?? '',
                ),
                width: 40.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${userModel?.clientName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstants.PRIMARY_BLUE,
                            )),
                    Text(
                      '${userModel?.platform}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.arrow_downward,
          color: ColorConstants.GREY_DARK,
        ),
        Container(
          margin: EdgeInsets.only(
            bottom: 10.h,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: ColorConstants.GREY_DARK,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                Helper.getIconByPlatform(
                  clientModel?.platform ?? '',
                ),
                width: 40.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${clientModel?.clientName} (You)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstants.PRIMARY_BLUE,
                            )),
                    Text(
                      '${clientModel?.platform}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onDestroy() {}

  @override
  void onDispose() {}

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  void onStop() {}
}
