import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'move_db_platform_interface.dart';

/// An implementation of [MoveDbPlatform] that uses method channels.
class MethodChannelMoveDb extends MoveDbPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('move_db');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
