#include "hybrid_v4l2_view_api.h"

namespace hybrid_v4l2 {
ViewAPI::ViewAPI(flutter::TextureRegistrar *texture_registrar)
    : texture_registrar(texture_registrar) {}

ViewAPI::~ViewAPI() {}

ErrorOr<int64_t> ViewAPI::RegisterTexture() {
  auto v4l2_texture = std::make_unique<V4L2Texture>();
  auto texture =
      std::make_unique<flutter::TextureVariant>(flutter::PixelBufferTexture(
          [v4l2_texture = v4l2_texture.get()](
              size_t width, auto height) -> const FlutterDesktopPixelBuffer * {
            return v4l2_texture->CopyBuffer();
          }));
  auto id = texture_registrar->RegisterTexture(texture.get());

  v4l2_textures[id] = std::move(v4l2_texture);
  textures[id] = std::move(texture);

  return id;
}

std::optional<FlutterError>
ViewAPI::UpdateTexture(int64_t id_args, const std::vector<uint8_t> &buffer_args,
                       int64_t width_args, int64_t height_args) {
  auto id = id_args;
  auto v4l2_texture = v4l2_textures[id].get();
  auto updated = v4l2_texture->Update(buffer_args, width_args, height_args);
  if (updated) {
    auto marked = texture_registrar->MarkTextureFrameAvailable(id);
    if (marked) {
      return std::nullopt;
    } else {
      return FlutterError("UpdateTexture",
                          "mark texture frame available failed.");
    }
  } else {
    return FlutterError("UpdateTexture", "update failed.");
  }
}

std::optional<FlutterError> ViewAPI::UnregisterTexture(int64_t id_args) {
  auto id = id_args;

  texture_registrar->UnregisterTexture(id);
  v4l2_textures.erase(id);
  textures.erase(id);

  return std::nullopt;
}
} // namespace hybrid_v4l2
