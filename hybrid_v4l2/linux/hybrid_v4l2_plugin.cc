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
  GHashTable *textures;
};

G_DEFINE_TYPE(HybridV4l2Plugin, hybrid_v4l2_plugin, g_object_get_type())

static void hybrid_v4l2_plugin_init(HybridV4l2Plugin *self) {
  self->textures = g_hash_table_new_full(g_direct_hash, g_direct_equal, NULL,
                                         g_object_unref);
}

static void hybrid_v4l2_plugin_dispose(GObject *object) {
  HybridV4l2Plugin *self = HYBRID_V4L2_PLUGIN(object);

  g_clear_pointer(&self->textures, g_hash_table_unref);
  G_OBJECT_CLASS(hybrid_v4l2_plugin_parent_class)->dispose(object);
}

static void hybrid_v4l2_plugin_class_init(HybridV4l2PluginClass *klass) {
  G_OBJECT_CLASS(klass)->dispose = hybrid_v4l2_plugin_dispose;
}

static HybridV4l2V4L2ViewHostAPIRegisterTextureResponse *
hybrid_v4l2_plugin_register_texture(gpointer user_data) {
  HybridV4l2Plugin *self = HYBRID_V4L2_PLUGIN(user_data);
  FlTextureRegistrar *registrar = self->registrar;
  FlTexture *texture =
      FL_TEXTURE(g_object_new(hybrid_v4l2_texture_get_type(), NULL));
  gboolean registered =
      fl_texture_registrar_register_texture(registrar, texture);
  if (registered) {
    int64_t id = fl_texture_get_id(texture);
    g_hash_table_insert(self->textures, GINT_TO_POINTER(id),
                        g_object_ref(texture));
    return hybrid_v4l2_v4_l2_view_host_a_p_i_register_texture_response_new(id);
  } else {
    return hybrid_v4l2_v4_l2_view_host_a_p_i_register_texture_response_new_error(
        "fl_texture_registrar_register_texture", "register texture failed",
        NULL);
  }
}

static HybridV4l2V4L2ViewHostAPIUpdateTextureResponse *
hybrid_v4l2_plugin_update_texture(int64_t id_args, const uint8_t *buffer_args,
                                  size_t buffer_args_length,
                                  gpointer user_data) {
  HybridV4l2Plugin *self = HYBRID_V4L2_PLUGIN(user_data);
  FlTextureRegistrar *registrar = self->registrar;
  FlTexture *texture = reinterpret_cast<FlTexture *>(
      g_hash_table_lookup(self->textures, GINT_TO_POINTER(id_args)));
  int err =
      hybrid_v4l2_texture_update(texture, buffer_args, buffer_args_length);
  if (err) {
    return hybrid_v4l2_v4_l2_view_host_a_p_i_update_texture_response_new_error(
        "hybrid_v4l2_texture_update", "update texture failed", NULL);
  }
  gboolean marked =
      fl_texture_registrar_mark_texture_frame_available(registrar, texture);
  if (marked) {
    return hybrid_v4l2_v4_l2_view_host_a_p_i_update_texture_response_new();
  } else {
    return hybrid_v4l2_v4_l2_view_host_a_p_i_update_texture_response_new_error(
        "hybrid_v4l2_texture_update", "mark texture frame available failed",
        NULL);
  }
}

static HybridV4l2V4L2ViewHostAPIUnregisterTextureResponse *
hybrid_v4l2_plugin_unregister_texture(int64_t id_args, gpointer user_data) {
  HybridV4l2Plugin *self = HYBRID_V4L2_PLUGIN(user_data);
  FlTextureRegistrar *registrar = self->registrar;
  FlTexture *texture = reinterpret_cast<FlTexture *>(
      g_hash_table_lookup(self->textures, GINT_TO_POINTER(id_args)));
  gboolean unregistered =
      fl_texture_registrar_unregister_texture(registrar, texture) &&
      g_hash_table_remove(self->textures, GINT_TO_POINTER(id_args));
  if (unregistered) {
    return hybrid_v4l2_v4_l2_view_host_a_p_i_unregister_texture_response_new();
  } else {
    return hybrid_v4l2_v4_l2_view_host_a_p_i_unregister_texture_response_new_error(
        "fl_texture_registrar_unregister_texture", "unregister texture failed",
        NULL);
  }
}

static HybridV4l2V4L2ViewHostAPIVTable view_host_api_vtable = {
    .register_texture = hybrid_v4l2_plugin_register_texture,
    .update_texture = hybrid_v4l2_plugin_update_texture,
    .unregister_texture = hybrid_v4l2_plugin_unregister_texture,
};

void hybrid_v4l2_plugin_register_with_registrar(FlPluginRegistrar *registrar) {
  HybridV4l2Plugin *plugin =
      HYBRID_V4L2_PLUGIN(g_object_new(hybrid_v4l2_plugin_get_type(), NULL));
  plugin->registrar = fl_plugin_registrar_get_texture_registrar(registrar);

  FlBinaryMessenger *messenger = fl_plugin_registrar_get_messenger(registrar);

  hybrid_v4l2_v4_l2_view_host_a_p_i_set_method_handlers(
      messenger, NULL, &view_host_api_vtable, g_object_ref(plugin),
      g_object_unref);

  g_object_unref(plugin);
}
