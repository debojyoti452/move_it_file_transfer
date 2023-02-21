#include "include/move_db/move_db_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "move_db_plugin.h"

void MoveDbPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  move_db::MoveDbPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
