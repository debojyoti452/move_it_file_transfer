import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:move_db/move_db_method_channel.dart';

void main() {
  MethodChannelMoveDb platform = MethodChannelMoveDb();
  const MethodChannel channel = MethodChannel('move_db');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
