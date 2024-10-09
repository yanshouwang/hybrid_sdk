#include "include/hybrid_v4l2/hybrid_v4l2_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <map>
#include <sys/utsname.h>

#include "hybrid_v4l2_api.h"
#include "hybrid_v4l2_texture.h"

#define HYBRID_V4L2_PLUGIN(obj)                                                \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), hybrid_v4l2_plugin_get_type(),            \
                              HybridV4l2Plugin))

struct _HybridV4l2Plugin {
  GObject parent_instance;
  FlTextureRegistrar *registrar;
  std::map<int64_t, FlTexture *> textures;
};

G_DEFINE_TYPE(HybridV4l2Plugin, hybrid_v4l2_plugin, g_object_get_type())

static void hybrid_v4l2_plugin_class_init(HybridV4l2PluginClass *klass) {
  G_OBJECT_CLASS(klass)->dispose = hybrid_v4l2_plugin_dispose;
}

static void hybrid_v4l2_plugin_init(HybridV4l2Plugin *self) {}

static void hybrid_v4l2_plugin_dispose(GObject *object) {
  G_OBJECT_CLASS(hybrid_v4l2_plugin_parent_class)->dispose(object);
}

void hybrid_v4l2_plugin_register_with_registrar(FlPluginRegistrar *registrar) {
  HybridV4l2Plugin *plugin =
      HYBRID_V4L2_PLUGIN(g_object_new(hybrid_v4l2_plugin_get_type(), NULL));
  plugin->registrar = fl_plugin_registrar_get_texture_registrar(registrar);

  FlBinaryMessenger *messenger = fl_plugin_registrar_get_messenger(registrar);
  HybridV4l2ViewHostAPIVTable view_host_api_vtable = {
      .register_texture = register_texture,
      .update_texture = update_texture,
      .unregister_texture = unregister_texture,
  };
  hybrid_v4l2_view_host_a_p_i_set_method_handlers(
      messenger, NULL, &view_host_api_vtable, g_object_ref(plugin),
      g_object_unref);

  g_object_unref(plugin);
}

static HybridV4l2ViewHostAPIRegisterTextureResponse *
register_texture(gpointer user_data) {
  HybridV4l2Plugin *plugin = HYBRID_V4L2_PLUGIN(user_data);
  FlTextureRegistrar *registrar = plugin->registrar;
  FlTexture *texture =
      FL_TEXTURE(g_object_new(fl_pixel_buffer_texture_get_type(), NULL));
  gboolean registered =
      fl_texture_registrar_register_texture(registrar, texture);
  if (registered) {
    int64_t id = fl_texture_get_id(texture);
    plugin->textures[id] = texture;
    return hybrid_v4l2_view_host_a_p_i_register_texture_response_new(id);
  } else {
    return hybrid_v4l2_view_host_a_p_i_register_texture_response_new_error(
        "fl_texture_registrar_register_texture", "register texture failed",
        NULL);
  }
}

static HybridV4l2ViewHostAPIUpdateTextureResponse *
update_texture(int64_t id, const uint8_t *buffer, size_t buffer_length,
               gpointer user_data) {
  HybridV4l2Plugin *plugin = HYBRID_V4L2_PLUGIN(user_data);
  FlTextureRegistrar *registrar = plugin->registrar;
  FlTexture *texture = plugin->textures[id];
  gboolean updated =
      hybrid_v4l2_texture_update(registrar, texture, buffer, buffer_length);
  if (updated) {
    return hybrid_v4l2_view_host_a_p_i_update_texture_response_new();
  } else {
    return hybrid_v4l2_view_host_a_p_i_update_texture_response_new_error(
        "hybrid_v4l2_texture_update", "update texture failed", NULL);
  }
}

static HybridV4l2ViewHostAPIUnregisterTextureResponse *
unregister_texture(int64_t id, gpointer user_data) {
  HybridV4l2Plugin *plugin = HYBRID_V4L2_PLUGIN(user_data);
  FlTextureRegistrar *registrar = plugin->registrar;
  FlTexture *texture = plugin->textures[id];
  gboolean unregistered =
      fl_texture_registrar_unregister_texture(registrar, texture);
  if (unregistered) {
    plugin->textures.erase(id);
    return hybrid_v4l2_view_host_a_p_i_unregister_texture_response_new();
  } else {
    return hybrid_v4l2_view_host_a_p_i_unregister_texture_response_new_error(
        "fl_texture_registrar_unregister_texture", "unregister texture failed",
        NULL);
  }
}
