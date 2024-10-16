#include "hybrid_v4l2_texture.h"

#include <flutter_linux/flutter_linux.h>
#include <libyuv.h>

#include "hybrid_v4l2_api.h"

#define HYBRID_V4L2_TEXTURE(obj)                                               \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), hybrid_v4l2_texture_get_type(),           \
                              HybridV4l2Texture))

struct _HybridV4l2Texture {
  FlPixelBufferTexture parent_instance;

  uint8_t *buffer;
  size_t buffer_size;
  GMutex buffer_mutex;
  uint8_t *out_buffer;
  int width;
  int height;
};

G_DEFINE_TYPE(HybridV4l2Texture, hybrid_v4l2_texture,
              fl_pixel_buffer_texture_get_type())

static void hybrid_v4l2_texture_init(HybridV4l2Texture *self) {
  g_mutex_init(&self->buffer_mutex);
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
  g_mutex_lock(&self->buffer_mutex);
  int code = libyuv::MJPGSize(self->buffer, self->buffer_size, &self->width,
                              &self->height);
  int stride = self->width * 4;
  uint8_t *argb = new uint8_t[self->width * self->height * 4];
  code =
      libyuv::MJPGToARGB(self->buffer, self->buffer_size, argb, stride,
                         self->width, self->height, self->width, self->height);
  if (self->out_buffer != NULL) {
    delete self->out_buffer;
  }
  self->out_buffer = new uint8_t[self->width * self->height * 4];
  code = libyuv::ARGBToRGBA(argb, stride, self->out_buffer, stride, self->width,
                            self->height);
  delete[] argb;
  delete[] self->buffer;
  self->buffer = NULL;
  g_mutex_unlock(&self->buffer_mutex);
  if (code == 0) {
    // Directly return pointer to your pixel buffer here.
    // Flutter takes content of your pixel buffer after this function
    // is finished. So you must make the buffer live long enough until
    // next tick of Render Thread.
    // If it is hard to manage lifetime of your pixel buffer, you should
    // take look into #FlTextureGL.
    *out_buffer = self->out_buffer;
    *width = self->width;
    *height = self->height;
    return TRUE;
  } else {
    // set @error to report failure.
    *error =
        g_error_new(HYBRID_V4L2_TEXTURE_ERROR, code, "MJPEGToRGBA failed.");
    return FALSE;
  }
}

static void hybrid_v4l2_texture_dispose(GObject *object) {
  HybridV4l2Texture *self = HYBRID_V4L2_TEXTURE(object);
  g_mutex_lock(&self->buffer_mutex);
  if (self->buffer) {
    delete self->buffer;
  }
  if (self->out_buffer) {
    delete self->out_buffer;
  }
  g_mutex_unlock(&self->buffer_mutex);
  g_mutex_clear(&self->buffer_mutex);

  G_OBJECT_CLASS(hybrid_v4l2_texture_parent_class)->dispose(object);
}

static void hybrid_v4l2_texture_class_init(HybridV4l2TextureClass *klass) {
  G_OBJECT_CLASS(klass)->dispose = hybrid_v4l2_texture_dispose;
  FL_PIXEL_BUFFER_TEXTURE_CLASS(klass)->copy_pixels =
      hybrid_v4l2_texture_copy_pixels;
}

int hybrid_v4l2_texture_update(FlTexture *texture, const uint8_t *buffer,
                               size_t buffer_size) {
  HybridV4l2Texture *self = HYBRID_V4L2_TEXTURE(texture);
  int code;
  g_mutex_lock(&self->buffer_mutex);
  if (self->buffer) {
    code = 1;
  } else {
    self->buffer = new uint8_t[buffer_size];
    memcpy(self->buffer, buffer, buffer_size);
    self->buffer_size = buffer_size;
    code = 0;
  }
  g_mutex_unlock(&self->buffer_mutex);
  return code;
}
