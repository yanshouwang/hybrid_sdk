#if !defined(HYBRID_V4L2_VIEW_API_H_)
#define HYBRID_V4L2_VIEW_API_H_

#include "hybrid_v4l2_api.h"
#include "hybrid_v4l2_texture.h"

namespace hybrid_v4l2 {
class ViewAPI : public ViewHostAPI {
private:
  flutter::TextureRegistrar *texture_registrar;
  std::map<int64_t, std::unique_ptr<V4L2Texture>> v4l2_textures;
  std::map<int64_t, std::unique_ptr<flutter::TextureVariant>> textures;

public:
  ViewAPI(flutter::TextureRegistrar *texture_registrar);
  ~ViewAPI();
  ErrorOr<int64_t> RegisterTexture() override;
  std::optional<FlutterError>
  UpdateTexture(int64_t id_args, const std::vector<uint8_t> &buffer_args,
                int64_t width_args, int64_t height_args) override;
  std::optional<FlutterError> UnregisterTexture(int64_t id_args) override;
};
} // namespace hybrid_v4l2

#endif // HYBRID_V4L2_VIEW_API_H_
