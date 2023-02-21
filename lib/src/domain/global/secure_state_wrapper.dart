import 'package:flutter/material.dart';

abstract class BaseStateWrapper<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  void onInit();

  void onStop();

  void onPause();

  void onResume();

  void onDestroy();

  void onDispose();

  Widget onBuild(BuildContext context);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    onInit();
  }

  @override
  Widget build(BuildContext context) {
    return onBuild(context);
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
}
