
import 'move_db_platform_interface.dart';

class MoveDb {
  Future<String?> getPlatformVersion() {
    return MoveDbPlatform.instance.getPlatformVersion();
  }
}
