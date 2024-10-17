#include "hybrid_v4l2_texture.h"

#include <flutter_linux/flutter_linux.h>

#include "hybrid_v4l2_api.h"

#define HYBRID_V4L2_TEXTURE(obj)                                               \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), hybrid_v4l2_texture_get_type(),           \
                              HybridV4l2Texture))

struct _HybridV4l2Texture {
  FlPixelBufferTexture parent_instance;

  const uint8_t *buffer;
  size_t buffer_size;
  int width;
  int height;
  GMutex mutex;
  uint8_t *out_buffer;
};

G_DEFINE_TYPE(HybridV4l2Texture, hybrid_v4l2_texture,
              fl_pixel_buffer_texture_get_type())

static void hybrid_v4l2_texture_init(HybridV4l2Texture *self) {
  g_mutex_init(&self->mutex);
}

static gboolean hybrid_v4l2_texture_copy_pixels(FlPixelBufferTexture *texture,
                                                const uint8_t **out_buffer,
                                                uint32_t *width,
                                                uint32_t *height,
                                                GError **error) {
  // This method is called on Render Thread. Be careful with your
  // cross-thread operatio
  // @width and @height are initially stored the canvas size in Flutter.

  // You must prepare your pixel buffer in RGBA format.
  // So you may do some format conversion first if your original pixel
  // buffer is not in RGBA format.
  HybridV4l2Texture *self = HYBRID_V4L2_TEXTURE(texture);
  if (self->buffer) {
    // Directly return pointer to your pixel buffer here.
    // Flutter takes content of your pixel buffer after this function
    // is finished. So you must make the buffer live long enough until
    // next tick of Render Thread.
    // If it is hard to manage lifetime of your pixel buffer, you should
    // take look into #FlTextureGL.
    g_mutex_lock(&self->mutex);
    if (self->out_buffer) {
      delete[] self->out_buffer;
    }
    self->out_buffer = new uint8_t[self->buffer_size];
    memcpy(self->out_buffer, self->buffer, self->buffer_size);
    *out_buffer = self->out_buffer;
    *width = self->width;
    *height = self->height;
    delete[] self->buffer;
    self->buffer = NULL;
    g_mutex_unlock(&self->mutex);
    return TRUE;
  } else {
    // set @error to report failure.
    return FALSE;
  }
}

static void hybrid_v4l2_texture_dispose(GObject *object) {
  HybridV4l2Texture *self = HYBRID_V4L2_TEXTURE(object);
  if (self->buffer) {
    g_mutex_lock(&self->mutex);
    delete[] self->buffer;
    self->buffer = NULL;
    g_mutex_unlock(&self->mutex);
  }
  g_mutex_clear(&self->mutex);

  G_OBJECT_CLASS(hybrid_v4l2_texture_parent_class)->dispose(object);
}

static void hybrid_v4l2_texture_class_init(HybridV4l2TextureClass *klass) {
  G_OBJECT_CLASS(klass)->dispose = hybrid_v4l2_texture_dispose;
  FL_PIXEL_BUFFER_TEXTURE_CLASS(klass)->copy_pixels =
      hybrid_v4l2_texture_copy_pixels;
}

HybridV4l2Texture *hybrid_v4l2_texture_new() {
  return HYBRID_V4L2_TEXTURE(
      g_object_new(hybrid_v4l2_texture_get_type(), NULL));
}

gboolean hybrid_v4l2_texture_mark_frame_available(FlTexture *texture,
                                                  const uint8_t *buffer,
                                                  size_t buffer_size,
                                                  uint32_t width,
                                                  uint32_t height) {
  HybridV4l2Texture *self = HYBRID_V4L2_TEXTURE(texture);
  if (self->buffer) {
    delete[] buffer;
    return FALSE;
  } else {
    g_mutex_lock(&self->mutex);
    self->buffer = buffer;
    self->buffer_size = buffer_size;
    self->width = width;
    self->height = height;
    g_mutex_unlock(&self->mutex);
    return TRUE;
  }
}
