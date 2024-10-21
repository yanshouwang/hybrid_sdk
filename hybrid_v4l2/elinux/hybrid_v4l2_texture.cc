#include <libyuv.h>

#include "hybrid_v4l2_texture.h"

namespace hybrid_v4l2 {
V4L2Texture::V4L2Texture() {}

V4L2Texture::~V4L2Texture() {}

bool V4L2Texture::Update(const std::vector<uint8_t> &buffer, size_t width,
                         size_t height) {
  std::lock_guard lock(this->mutex);
  if (this->buffer.empty()) {
    this->buffer = std::move(buffer);
    this->width = width;
    this->height = height;
    return true;
  } else {
    return false;
  }
}

const FlutterDesktopPixelBuffer *V4L2Texture::CopyBuffer() {
  std::lock_guard lock(this->mutex);
  if (this->buffer.empty()) {
    return NULL;
  } else {
    this->out_buffer.swap(this->buffer);
    this->buffer.clear();

    this->out = std::make_unique<FlutterDesktopPixelBuffer>();
    this->out->buffer = this->out_buffer.data();
    this->out->width = this->width;
    this->out->height = this->height;
    return this->out.get();
  }
}
} // namespace hybrid_v4l2
