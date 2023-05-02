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

import '../../../../../data/model/connect_model.dart';
import '../../../../../domain/global/app_cubit_status.dart';
import '../../../../../domain/global/base_state_wrapper.dart';
import '../../../../../domain/themes/color_constants.dart';
import '../../../../../domain/utils/helper.dart';
import '../../../../widgets/extra_view.dart';
import '../../../transfer/cubit/transfer_cubit.dart';
import '../../../transfer/receive_file_screen.dart';
import '../cubit/history/connect_history_cubit.dart';

class ConnectHistoryFragment extends StatefulWidget {
  static const id = 'CONNECT_HISTORY_FRAGMENT';

  const ConnectHistoryFragment({Key? key}) : super(key: key);

  @override
  _ConnectHistoryFragmentState createState() => _ConnectHistoryFragmentState();
}

class _ConnectHistoryFragmentState
    extends BaseStateWrapper<ConnectHistoryFragment> {
  late ConnectHistoryCubit _cubit;

  @override
  void onInit() {
    _cubit = context.read<ConnectHistoryCubit>();
    _cubit.initialize();
  }

  @override
  Widget onMobile(
    BuildContext context,
    BoxConstraints constraints,
    PlatformType platform,
  ) {
    return BlocConsumer<ConnectHistoryCubit, ConnectHistoryState>(
      bloc: _cubit,
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Already Connected History',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ColorConstants.BLACK,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Expanded(child: _acceptedListWidget(state)),
            ],
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
    return onMobile(context, constraints, platform);
  }

  Widget _acceptedListWidget(ConnectHistoryState state) {
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
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        margin: EdgeInsets.only(bottom: 20.h),
        child: Center(
          child: Text(
            'No Accepted List found',
            style: Theme.of(context).textTheme.bodySmall,
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
              try {
                var client = nearbyClients[index];
                var connectModel = ConnectRequest(
                  senderIp: state.userModel.ipAddress,
                  receiverIp: client.ipAddress,
                  senderModel: client,
                  receiverModel: state.userModel,
                );
                context
                    .read<TransferCubit>()
                    .updateConnectRequest(connectModel);
              } catch (e) {
                debugPrint(e.toString());
              } finally {
                Navigator.pushNamed(context, ReceiveFileScreen.id);
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
                      connectedStatusView(
                          (nearbyClients[index].isConnected ?? false)),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      _cubit.deleteItem(index);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  @override
  void onStop() {}

  @override
  void onDestroy() {}

  @override
  void onDispose() {}
}
