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
        return _SlideAnimator(
          builder: (_) => const SendFileScreen(),
          settings: settings,
        );

      case ReceiveFileScreen.id:
        return _SlideAnimator(
          builder: (_) => const ReceiveFileScreen(),
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
