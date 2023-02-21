#ifndef FLUTTER_PLUGIN_MOVE_DB_PLUGIN_H_
#define FLUTTER_PLUGIN_MOVE_DB_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace move_db {

class MoveDbPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  MoveDbPlugin();

  virtual ~MoveDbPlugin();

  // Disallow copy and assign.
  MoveDbPlugin(const MoveDbPlugin&) = delete;
  MoveDbPlugin& operator=(const MoveDbPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace move_db

#endif  // FLUTTER_PLUGIN_MOVE_DB_PLUGIN_H_
