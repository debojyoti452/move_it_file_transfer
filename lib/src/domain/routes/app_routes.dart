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

import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/start/start_screen.dart';
import '../../presentation/screens/transfer/receive_file_screen.dart';
import '../../presentation/screens/transfer/send_file_screen.dart';

class AppRoutes {
  static Route<T> onGenerateRoute<T>(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.id:
        return _SlideAnimator(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case StartScreen.id:
        return _SlideAnimator(
          builder: (_) => const StartScreen(),
          settings: settings,
        );

      case SendFileScreen.id:
        var args = settings.arguments as bool? ?? false;
        return _SlideAnimator(
          builder: (_) => SendFileScreen(
            isFromReceiverScreen: args,
          ),
          settings: settings,
        );

      case ReceiveFileScreen.id:
        var args = settings.arguments as bool? ?? false;
        return _SlideAnimator(
          builder: (_) => ReceiveFileScreen(
            isFromSenderScreen: args,
          ),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
          settings: settings,
        );
    }
  }
}

class _SlideAnimator<T> extends MaterialPageRoute<T> {
  _SlideAnimator({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
