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

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/model/connect_model.dart';
import '../../../domain/global/base_state_wrapper.dart';
import '../../../domain/themes/color_constants.dart';
import '../../../domain/utils/helper.dart';
import '../../widgets/dx_dotted_view.dart';
import '../../widgets/dx_file_transfer_view.dart';
import 'cubit/transfer_cubit.dart';
import 'receive_file_screen.dart';

class SendFileScreen extends StatefulWidget {
  static const id = 'SEND_FILE_SCREEN';

  const SendFileScreen({
    Key? key,
    required this.isFromReceiverScreen,
  }) : super(key: key);

  final bool isFromReceiverScreen;

  @override
  _SendFileScreenState createState() => _SendFileScreenState();
}

class _SendFileScreenState extends BaseStateWrapper<SendFileScreen> {
  late TransferCubit _cubit;

  @override
  void onInit() {
    _cubit = context.read<TransferCubit>();
    _cubit.initialize();
    if (widget.isFromReceiverScreen) {
      logger('isFromReceiverScreen: ${widget.isFromReceiverScreen}');
      _cubit.swapSenderToReceiver(isSender: true);
    }
  }

  @override
  Widget onMobile(
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
              'Send File',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                if (widget.isFromReceiverScreen == true) {
                  _cubit.swapSenderToReceiver(isSender: true);
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstants.BLACK,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ReceiveFileScreen.id,
                    arguments: true,
                  );
                },
                icon: const Icon(
                  Icons.call_received,
                  color: ColorConstants.BLACK,
                ),
              ),
            ],
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
                _addFileButton(
                  onAddFileClick: () {
                    _cubit.fileSelector();
                  },
                ),
                SizedBox(
                  height: 8.h,
                ),
                _fileListView(state),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: ColorConstants.PRIMARY_BLUE,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              onPressed: () {
                _cubit.sendFile();
              },
              child: Text(
                'Send',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorConstants.PRIMARY_BLUE,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget onTablet(
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
              'Send File',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                if (widget.isFromReceiverScreen == true) {
                  _cubit.swapSenderToReceiver(isSender: true);
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: ColorConstants.BLACK,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ReceiveFileScreen.id,
                    arguments: true,
                  );
                },
                icon: const Icon(
                  Icons.call_received,
                  color: ColorConstants.BLACK,
                ),
              ),
            ],
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
                _addFileButton(
                  onAddFileClick: () {
                    _cubit.fileSelector();
                  },
                ),
                SizedBox(
                  height: 8.h,
                ),
                _fileListView(state),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: ColorConstants.PRIMARY_BLUE,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              onPressed: () {
                _cubit.sendFile();
              },
              child: Text(
                'Send',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorConstants.PRIMARY_BLUE,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _fileListView(TransferState state) {
    if (state.fileList.isEmpty) {
      return SizedBox(
        height: 100.h,
        child: Center(
          child: Text(
            'No file selected.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      );
    }
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
              );
            },
          );
        });
  }

  Widget _userItemView(ConnectRequest connectRequest) {
    if (connectRequest.receiverModel == null ||
        connectRequest.senderModel == null) {
      BotToast.showText(
        text: 'Something went wrong',
      );
      Navigator.pop(context);
    }
    var clientModel = connectRequest.senderModel;
    var userModel = connectRequest.receiverModel;
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
                    Text('${userModel?.clientName} (You)',
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
                    Text('${clientModel?.clientName}',
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

  Widget _addFileButton({
    required VoidCallback onAddFileClick,
  }) {
    return Container(
      width: ScreenUtil().screenWidth,
      height: 100.h,
      decoration: BoxDecoration(
        color: ColorConstants.GREY_DARK,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorConstants.BLACK.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAddFileClick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Upload or Drag File Here',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: ColorConstants.BLACK.withOpacity(0.4),
                    ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Icon(
                Icons.add_circle_rounded,
                color: ColorConstants.BLACK.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
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
