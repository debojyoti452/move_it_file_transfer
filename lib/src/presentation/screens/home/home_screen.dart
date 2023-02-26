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

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/global/app_cubit_status.dart';
import '../../../domain/global/base_state_wrapper.dart';
import '../../../domain/global/status_code.dart';
import '../../widgets/dx_bottom_navigation_bar.dart';
import 'components/cubit/receive/receive_fragment_cubit.dart';
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
    _homeCubit.initialHome();
    initialize();
  }

  void initialize() {
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  @override
  Widget onBuild(
    BuildContext context,
    Constraints constraints,
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
