#if !defined(HYBRID_V4L2_TEXTURE_H_)
#define HYBRID_V4L2_TEXTURE_H_

#include <flutter_linux/flutter_linux.h>

#include "hybrid_v4l2_api.h"

G_BEGIN_DECLS

#define HYBRID_V4L2_TEXTURE_ERROR g_spawn_error_quark()

typedef struct _HybridV4l2Texture HybridV4l2Texture;
typedef struct {
  FlPixelBufferTextureClass parent_class;
} HybridV4l2TextureClass;

HybridV4l2Texture *hybrid_v4l2_texture_new();

gboolean hybrid_v4l2_texture_update(FlTexture *texture, const uint8_t *buffer,
                                    size_t buffer_size, uint32_t width,
                                    uint32_t height);

G_END_DECLS

#endif // HYBRID_V4L2_TEXTURE_H_
