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

import '../../../../../data/model/client_model.dart';
import '../../../../../data/model/connect_model.dart';
import '../../../../../domain/global/app_cubit_status.dart';
import '../../../../../domain/global/base_state_wrapper.dart';
import '../../../../../domain/themes/color_constants.dart';
import '../../../../../domain/utils/helper.dart';
import '../../../../widgets/dx_nearby_view.dart';
import '../../../transfer/cubit/transfer_cubit.dart';
import '../../../transfer/send_file_screen.dart';
import '../cubit/send/send_fragment_cubit.dart';

class SendFragment extends StatefulWidget {
  static const String id = 'SEND_FRAGMENT';

  const SendFragment({Key? key}) : super(key: key);

  @override
  _SendFragmentState createState() => _SendFragmentState();
}

class _SendFragmentState extends BaseStateWrapper<SendFragment> {
  late SendFragmentCubit _cubit;

  @override
  void onInit() {
    _cubit = context.read<SendFragmentCubit>();
    _cubit.initialize();
  }

  @override
  Widget onBuild(
    BuildContext context,
    BoxConstraints constraints,
    PlatformType platform,
  ) {
    return BlocConsumer<SendFragmentCubit, SendFragmentState>(
      bloc: _cubit,
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      text: 'See devices in your radar nearby\n',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: ColorConstants.BLACK,
                                fontWeight: FontWeight.bold,
                              ),
                      children: [
                        TextSpan(
                          text: 'Make sure all devices are in same WiFi\n',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: 'Name: ${state.userModel.clientName ?? ''}\n',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorConstants.PRIMARY_BLUE,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                SizedBox(
                  height: 200.h,
                  child: const DxNearbyView(),
                ),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text('All devices in your radar'),
                    ),
                    IconButton(
                      onPressed: () {
                        // Navigator.pushNamed(
                        //   context,
                        //   ReceiveFileScreen.id,
                        // );
                        _cubit.searchNearbyDevices();
                      },
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.refresh,
                        color: ColorConstants.BLACK,
                      ),
                    ),
                  ],
                ),
                _allDeviceListView(
                  nearbyClients: state.nearbyClients,
                  state: state,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _allDeviceListView({
    required List<ClientModel> nearbyClients,
    required SendFragmentState state,
  }) {
    if (state.status is AppCubitLoading) {
      return Container(
        margin: EdgeInsets.only(
          top: 90.h,
        ),
        child: CircularProgressIndicator(
          color: ColorConstants.BLACK,
          strokeWidth: 2.w,
        ),
      );
    }
    if (nearbyClients.isEmpty) {
      return Container(
        margin: EdgeInsets.only(
          top: 90.h,
        ),
        child: Text(
          'No device found.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: nearbyClients.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () async {
            if (await _cubit
                .isSenderConnected(nearbyClients[index].ipAddress ?? 'NULL')) {
              if (nearbyClients[index].isConnected == false) {
                _cubit.sendRequestToDevice(
                  clientModel: nearbyClients[index],
                );
              } else {
                try {
                  var client = nearbyClients[index];
                  var connectModel = ConnectRequest(
                    fromIp: client.ipAddress,
                    toIp: state.userModel.ipAddress,
                    fromData: state.userModel,
                    toData: client,
                  );
                  context
                      .read<TransferCubit>()
                      .updateConnectRequest(connectModel);
                } catch (e) {
                  debugPrint(e.toString());
                } finally {
                  Navigator.pushNamed(context, SendFileScreen.id);
                }
              }
            } else {
              BotToast.showText(
                text: 'Sender is Offline',
                contentColor: Colors.red,
              );
            }
          },
          child: Container(
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
                    nearbyClients[index].platform ?? '',
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
                      Text(
                        '${nearbyClients[index].clientName}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${nearbyClients[index].platform}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      _connectedStatusView(
                          (nearbyClients[index].isConnected ?? false)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _connectedStatusView(bool isConnected) {
    return Text(
      isConnected ? 'Connected' : 'Not connected',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isConnected ? Colors.green : Colors.red,
          ),
    );
  }

  @override
  void onDestroy() {}

  @override
  void onDispose() {
    _cubit.dispose();
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  void onStop() {}
}
