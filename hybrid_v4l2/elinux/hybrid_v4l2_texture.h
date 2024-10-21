#if !defined(HYBRID_V4L2_TEXTURE_H_)
#define HYBRID_V4L2_TEXTURE_H_

#include <flutter/texture_registrar.h>
#include <shared_mutex>

#include "hybrid_v4l2_api.h"

namespace hybrid_v4l2 {
class V4L2Texture {
private:
  std::vector<uint8_t> buffer;
  uint32_t width;
  uint32_t height;
  std::shared_mutex mutex;
  std::unique_ptr<FlutterDesktopPixelBuffer> out;
  std::vector<uint8_t> out_buffer;
  // FlutterDesktopPixelBuffer flutter_pixel_buffer_{};
  // flutter::TextureRegistrar* texture_registrar_ = nullptr;
  // std::unique_ptr<flutter::TextureVariant> texture_ = nullptr;
  // int64_t texture_id_;
  // std::mutex mutex_;
  // int fg_index_ = 0;
  // bool buff_ready_ = false;
  // size_t width_[2];
  // size_t height_[2];
  // std::vector<uint8_t> buffer_tmp_[2];

public:
  V4L2Texture();
  ~V4L2Texture();
  bool Update(const std::vector<uint8_t> &buffer, size_t width, size_t height);
  const FlutterDesktopPixelBuffer *CopyBuffer();
};
} // namespace hybrid_v4l2

#endif // HYBRID_V4L2_TEXTURE_H_
