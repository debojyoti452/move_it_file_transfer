//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <move_db/move_db_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) move_db_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MoveDbPlugin");
  move_db_plugin_register_with_registrar(move_db_registrar);
}
