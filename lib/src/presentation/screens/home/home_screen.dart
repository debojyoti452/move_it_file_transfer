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

import '../../../data/constants/app_constants.dart';
import '../../../data/constants/assets_constants.dart';
import '../../../data/model/client_model.dart';
import '../../../data/model/connect_model.dart';
import '../../../domain/global/app_cubit_status.dart';
import '../../../domain/global/base_state_wrapper.dart';
import '../../../domain/global/status_code.dart';
import '../../widgets/dx_bottom_navigation_bar.dart';
import '../../widgets/dx_sidebar.dart';
import '../transfer/cubit/transfer_cubit.dart';
import 'components/cubit/receive/receive_fragment_cubit.dart';
import 'components/cubit/send/send_fragment_cubit.dart';
import 'components/fragment/profile_fragment.dart';
import 'components/fragment/receive_fragment.dart';
import 'components/fragment/send_fragment.dart';
import 'cubit/home_cubit.dart';

enum BottomTabEnum {
  send('Send'),
  receive('Receive'),
  profile('Profile');

  final String value;

  const BottomTabEnum(this.value);
}

class HomeScreen extends StatefulWidget {
  static const String id = 'HOME_SCREEN';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseStateWrapper<HomeScreen> {
  final int _selectedIndex = 0;
  late PageController _pageController;
  late HomeCubit _homeCubit;

  @override
  void onInit() {
    _homeCubit = context.read<HomeCubit>();
    _homeCubit.initialize();
    initialize();
  }

  void initialize() {
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  @override
  Widget onMobile(
    BuildContext context,
    BoxConstraints constraints,
    PlatformType platform,
  ) {
    return BlocConsumer<HomeCubit, HomeState>(
      bloc: _homeCubit,
      listener: (context, state) {
        debugPrint('state: ${state.connectRequestList}');
        if (state.status is AppCubitSuccess) {
          if ((state.status as AppCubitSuccess).code ==
              StatusCode.NEW_CONNECTION_REQUEST) {
            if (state.connectRequestList?.isNotEmpty ?? false) {
              context.read<ReceiveFragmentCubit>().updateRequestList(
                    state.connectRequestList ?? [],
                  );
            }
          }

          if ((state.status as AppCubitSuccess).code ==
              StatusCode.NEW_CONNECTION_ACCEPTED) {
            if (state.connectRequestList?.isNotEmpty ?? false) {
              context.read<SendFragmentCubit>().updateAcceptedRequestClient(
                    model: state.acceptedClientModel ?? const ConnectRequest(),
                  );
            }
          }

          if ((state.status as AppCubitSuccess).code ==
              StatusCode.NEW_FILE_RECEIVER) {
            if (state.connectRequestList?.isNotEmpty ?? false) {
              context.read<TransferCubit>().updateTransferData(
                    state.fileModelList ?? [],
                    state.downloadStatus,
                  );
            }
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: PageView(
              controller: _pageController,
              children: [
                const SendFragment(),
                const ReceiveFragment(),
                const ProfileFragment(),
              ],
              physics: const NeverScrollableScrollPhysics(),
            ),
          ),
          bottomNavigationBar: DxBottomNavigationBar(
            onTabSelected: (item) {
              _pageController.animateToPage(
                item,
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
              );
              debugPrint('index: $item');
            },
            currentIndex: _selectedIndex,
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
    return BlocConsumer<HomeCubit, HomeState>(
      bloc: _homeCubit,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                SvgPicture.asset(
                  AssetsConstants.logo,
                  height: 30.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Row(
            children: [
              DxSidebar(
                userModel: state.userModel ?? const ClientModel(),
                onTabSelected: (item) {
                  _pageController.animateToPage(
                    item,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                  );
                  debugPrint('index: $item');
                },
              ),
              Container(
                  width: 1.w,
                  height: ScreenUtil().screenHeight / 1.2,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.r),
                  )),
              Expanded(
                flex: 5,
                child: Container(
                  child: PageView(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    children: [
                      const SendFragment(),
                      const ReceiveFragment(),
                      const ProfileFragment(),
                    ],
                    physics: const NeverScrollableScrollPhysics(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
