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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../data/constants/assets_constants.dart';
import '../../../../../data/model/connect_model.dart';
import '../../../../../domain/global/app_cubit_status.dart';
import '../../../../../domain/global/base_state_wrapper.dart';
import '../../../../../domain/themes/color_constants.dart';
import '../../../../../domain/utils/helper.dart';
import '../../../transfer/cubit/transfer_cubit.dart';
import '../../../transfer/receive_file_screen.dart';
import '../cubit/receive/receive_fragment_cubit.dart';

class ReceiveFragment extends StatefulWidget {
  static const String id = 'RECEIVE_FRAGMENT';

  const ReceiveFragment({Key? key}) : super(key: key);

  @override
  State<ReceiveFragment> createState() => _ReceiveFragmentState();
}

class _ReceiveFragmentState extends BaseStateWrapper<ReceiveFragment> {
  late ReceiveFragmentCubit _cubit;

  @override
  void onInit() {
    _cubit = context.read<ReceiveFragmentCubit>();
    _cubit.initialize();
  }

  @override
  Widget onBuild(
    BuildContext context,
    BoxConstraints constraints,
    PlatformType platform,
  ) {
    return BlocConsumer<ReceiveFragmentCubit, ReceiveFragmentState>(
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
                SvgPicture.asset(
                  AssetsConstants.logo,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 8.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Accepted List',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.refresh,
                          color: ColorConstants.BLACK,
                        ),
                      ),
                    ],
                  ),
                ),
                _acceptedListWidget(state),
                Container(
                  padding: EdgeInsets.only(
                    left: 8.w,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Request List',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.refresh,
                          color: ColorConstants.BLACK,
                        ),
                      ),
                    ],
                  ),
                ),
                _requestedListWidget(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _acceptedListWidget(ReceiveFragmentState state) {
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
    var nearbyClients = state.acceptedList;
    if (nearbyClients.isEmpty) {
      return Container(
        margin: EdgeInsets.only(bottom: 20.h),
        child: Text(
          'No Accepted List found',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return ListView.builder(
      itemCount: nearbyClients.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            try {
              var client = nearbyClients[index];
              var connectModel = ConnectRequest(
                fromIp: state.userModel.ipAddress,
                toIp: client.ipAddress,
                fromData: client,
                toData: state.userModel,
              );
              context.read<TransferCubit>().updateConnectRequest(connectModel);
            } catch (e) {
              debugPrint(e.toString());
            } finally {
              Navigator.pushNamed(context, ReceiveFileScreen.id);
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

  Widget _requestedListWidget(ReceiveFragmentState state) {
    if (state.requestList.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Text(
          'No request found',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.requestList.length,
        itemBuilder: (context, index) {
          var item = state.requestList[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
            decoration: BoxDecoration(
              color: ColorConstants.WHITE,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: ColorConstants.BLACK.withOpacity(0.1),
                  blurRadius: 5.r,
                  spreadRadius: 1.r,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Request from',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstants.BLACK,
                      ),
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.fromData?.clientName ?? 'Debojyoti Singha',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: ColorConstants.PRIMARY_BLUE,
                                    ),
                          ),
                          Text(
                            item.fromData?.platform ?? 'android',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(
                      Helper.getIconByPlatform(
                        item.fromData?.platform ?? 'android',
                      ),
                      width: 40.w,
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _cubit.acceptRequest(item);
                        },
                        child: Text(
                          'Accept',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorConstants.WHITE,
                                  ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            ColorConstants.PRIMARY_BLUE,
                          ),
                          padding: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _cubit.rejectRequest(item);
                        },
                        child: Text(
                          'Reject',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorConstants.PRIMARY_BLUE,
                                  ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            ColorConstants.WHITE,
                          ),
                          padding: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            EdgeInsets.symmetric(
                              vertical: 10.h,
                            ),
                          ),
                          shape: MaterialStateProperty.all(
                            // ignore: prefer_const_constructors
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _connectedStatusView(bool isConnected) {
    return Text(
      isConnected ? 'Accepted' : 'Re-Connect',
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
