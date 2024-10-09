#include "hybrid_v4l2_texture.h"

#include <flutter_linux/flutter_linux.h>
#include <jpeglib.h>
#include <stdio.h>

#include "hybrid_v4l2_api.h"

#define HYBRID_V4L2_TEXTURE(obj)                                               \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), hybrid_v4l2_texture_get_type(),           \
                              HybridV4l2Texture))

struct _HybridV4l2Texture {
  FlPixelBufferTexture parent_instance;
  const uint8_t *buffer;
  size_t buffer_length;
  HybridV4l2PixelFormat format;
  uint32_t width;
  uint32_t height;
};

G_DEFINE_TYPE(HybridV4l2Texture, hybrid_v4l2_texture,
              fl_pixel_buffer_texture_get_type())

static void hybrid_v4l2_texture_init(HybridV4l2Texture *self) {}

gboolean hybrid_v4l2_texture_update(FlTextureRegistrar *registrar,
                                    FlTexture *texture, const uint8_t *buffer,
                                    size_t buffer_length) {
  HybridV4l2Texture *self = HYBRID_V4L2_TEXTURE(texture);
  self->buffer = buffer;
  self->buffer_length = buffer_length;
  self->format = HYBRID_V4L2_PIXEL_FORMAT_MJPEG;
  self->width = 0;
  self->height = 0;
  return fl_texture_registrar_mark_texture_frame_available(registrar, texture);
}

static gboolean hybrid_v4l2_texture_convert_pixels(HybridV4l2Texture *self) {
  switch (self->format) {
  case HYBRID_V4L2_PIXEL_FORMAT_MJPEG: {
    jpeg_decompress_struct cinfo;
    jpeg_error_mgr jerr;

    cinfo.err = jpeg_std_error(&jerr);
    cinfo.out_color_space = JCS_EXT_RGBX;
    cinfo.output_components = 4;

    jpeg_create_decompress(&cinfo);
    jpeg_mem_src(&cinfo, self->buffer, self->buffer_length);
    int header_err = jpeg_read_header(&cinfo, TRUE);
    if (header_err != JPEG_HEADER_OK) {
      jpeg_destroy_decompress(&cinfo);
      break;
    }
    uint32_t width = cinfo.image_width;
    uint32_t height = cinfo.image_height;
    size_t buffer_length = width * height * 4;
    uint8_t *buffer = new uint8_t[buffer_length];
    gboolean started = jpeg_start_decompress(&cinfo);
    if (!started) {
      jpeg_destroy_decompress(&cinfo);
      break;
    }
    while (cinfo.output_scanline < cinfo.output_height) {
      uint8_t *scanlines = buffer + cinfo.output_scanline * self->width * 3;
      jpeg_read_scanlines(&cinfo, &scanlines, 1);
    }
    gboolean finished = jpeg_finish_decompress(&cinfo);
    if (finished) {
      self->buffer = buffer;
      self->buffer_length = buffer_length;
      self->format = HYBRID_V4L2_PIXEL_FORMAT_RGBA;
      self->width = width;
      self->height = height;
    }
    jpeg_destroy_decompress(&cinfo);
    break;
  }
  default: {
    break;
  }
  }
  return self->format == HYBRID_V4L2_PIXEL_FORMAT_RGBA;
}

static gboolean hybrid_v4l2_texture_copy_pixels(FlPixelBufferTexture *texture,
                                                const uint8_t **out_buffer,
                                                uint32_t *width,
                                                uint32_t *height,
                                                GError **error) {
  // This method is called on Render Thread. Be careful with your
  // cross-thread operation.

  // @width and @height are initially stored the canvas size in Flutter.

  // You must prepare your pixel buffer in RGBA format.
  // So you may do some format conversion first if your original pixel
  // buffer is not in RGBA format.
  HybridV4l2Texture *self = HYBRID_V4L2_TEXTURE(texture);
  if (self->buffer == NULL) {
    return TRUE;
  }
  printf("convert");
  gboolean converted = hybrid_v4l2_texture_convert_pixels(self);
  printf("converted %d\n", converted);
  if (converted) {
    // Directly return pointer to your pixel buffer here.
    // Flutter takes content of your pixel buffer after this function
    // is finished. So you must make the buffer live long enough until
    // next tick of Render Thread.
    // If it is hard to manage lifetime of your pixel buffer, you should
    // take look into #FlTextureGL.
    *out_buffer = self->buffer;
    *width = self->width;
    *height = self->height;
    return TRUE;
  } else {
    // set @error to report failure.
    return FALSE;
  }
}

static void hybrid_v4l2_texture_class_init(HybridV4l2TextureClass *klass) {
  FL_PIXEL_BUFFER_TEXTURE_CLASS(klass)->copy_pixels =
      hybrid_v4l2_texture_copy_pixels;
}
