//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <hybrid_jpeg/hybrid_jpeg_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) hybrid_jpeg_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HybridJpegPlugin");
  hybrid_jpeg_plugin_register_with_registrar(hybrid_jpeg_registrar);
}
