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

import 'dart:io';

import 'package:flutter/material.dart';

enum PlatformType {
  android,
  iOS,
  windows,
  linux,
  macOS,
  fuchsia,
  unknown,
}

abstract class BaseStateWrapper<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  void onInit();

  void onStop();

  void onPause();

  void onResume();

  void onDestroy();

  void onDispose();

  Widget onBuild(
    BuildContext context,
    BoxConstraints constraints,
    PlatformType platform,
  );

  late PlatformType platform;

  @override
  void initState() {
    platform = getCurrentPlatform();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    onInit();
  }

  @override
  Widget build(BuildContext context) {
    if (platform == PlatformType.unknown) {
      return const Center(
        child: Text('Unknown Platform'),
      );
    } else {
      return LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return onBuild(
          context,
          constraints,
          platform,
        );
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.inactive:
        onStop();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.detached:
        onDestroy();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  PlatformType getCurrentPlatform() {
    if (Platform.isAndroid) {
      return PlatformType.android;
    } else if (Platform.isIOS) {
      return PlatformType.iOS;
    } else if (Platform.isFuchsia) {
      return PlatformType.fuchsia;
    } else if (Platform.isLinux) {
      return PlatformType.linux;
    } else if (Platform.isMacOS) {
      return PlatformType.macOS;
    } else if (Platform.isWindows) {
      return PlatformType.windows;
    } else {
      return PlatformType.unknown;
    }
  }
}
