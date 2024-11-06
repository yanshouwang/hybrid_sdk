//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <hybrid_v4l2/hybrid_v4l2_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) hybrid_v4l2_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HybridV4l2Plugin");
  hybrid_v4l2_plugin_register_with_registrar(hybrid_v4l2_registrar);
}
