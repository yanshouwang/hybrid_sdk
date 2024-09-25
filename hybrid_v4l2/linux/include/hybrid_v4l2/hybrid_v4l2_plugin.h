#ifndef FLUTTER_PLUGIN_HYBRID_V4L2_PLUGIN_H_
#define FLUTTER_PLUGIN_HYBRID_V4L2_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _HybridV4l2Plugin HybridV4l2Plugin;
typedef struct {
  GObjectClass parent_class;
} HybridV4l2PluginClass;

FLUTTER_PLUGIN_EXPORT GType hybrid_v4l2_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void hybrid_v4l2_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_HYBRID_V4L2_PLUGIN_H_
