#ifndef FLUTTER_PLUGIN_MOVE_DB_PLUGIN_H_
#define FLUTTER_PLUGIN_MOVE_DB_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _MoveDbPlugin MoveDbPlugin;
typedef struct {
  GObjectClass parent_class;
} MoveDbPluginClass;

FLUTTER_PLUGIN_EXPORT GType move_db_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void move_db_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_MOVE_DB_PLUGIN_H_
