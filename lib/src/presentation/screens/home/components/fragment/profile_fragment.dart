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

import '../../../../../domain/global/base_state_wrapper.dart';

class ProfileFragment extends StatefulWidget {
  static const String id = 'PROFILE_FRAGMENT';

  const ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends BaseStateWrapper<ProfileFragment> {
  @override
  void onInit() {}

  @override
  Widget onMobile(
      BuildContext context, BoxConstraints constraints, PlatformType platform) {
    return Container(
        child: Column(
      children: [
        const Text('Profile Fragment'),
      ],
    ));
  }

  @override
  Widget onTablet(
      BuildContext context, BoxConstraints constraints, PlatformType platform) {
    return Container(
        child: Column(
      children: [
        const Text('Profile Fragment'),
      ],
    ));
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
