import 'package:flutter_test/flutter_test.dart';
import 'package:move_db/move_db.dart';
import 'package:move_db/move_db_platform_interface.dart';
import 'package:move_db/move_db_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMoveDbPlatform
    with MockPlatformInterfaceMixin
    implements MoveDbPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MoveDbPlatform initialPlatform = MoveDbPlatform.instance;

  test('$MethodChannelMoveDb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMoveDb>());
  });

  test('getPlatformVersion', () async {
    MoveDb moveDbPlugin = MoveDb();
    MockMoveDbPlatform fakePlatform = MockMoveDbPlatform();
    MoveDbPlatform.instance = fakePlatform;

    expect(await moveDbPlugin.getPlatformVersion(), '42');
  });
}
