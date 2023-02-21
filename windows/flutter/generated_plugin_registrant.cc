//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <move_db/move_db_plugin_c_api.h>
#include <window_size/window_size_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  MoveDbPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MoveDbPluginCApi"));
  WindowSizePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowSizePlugin"));
}
