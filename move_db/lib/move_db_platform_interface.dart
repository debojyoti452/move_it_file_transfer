import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'move_db_method_channel.dart';

abstract class MoveDbPlatform extends PlatformInterface {
  /// Constructs a MoveDbPlatform.
  MoveDbPlatform() : super(token: _token);

  static final Object _token = Object();

  static MoveDbPlatform _instance = MethodChannelMoveDb();

  /// The default instance of [MoveDbPlatform] to use.
  ///
  /// Defaults to [MethodChannelMoveDb].
  static MoveDbPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MoveDbPlatform] when
  /// they register themselves.
  static set instance(MoveDbPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
