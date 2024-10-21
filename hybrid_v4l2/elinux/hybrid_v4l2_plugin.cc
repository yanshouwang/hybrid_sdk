#include "include/hybrid_v4l2/hybrid_v4l2_plugin.h"

#include <flutter/basic_message_channel.h>
#include <flutter/plugin_registrar.h>
#include <flutter/standard_message_codec.h>

#include "hybrid_v4l2_api.h"
#include "hybrid_v4l2_view_api.h"

namespace hybrid_v4l2 {
class HybridV4l2Plugin : public flutter::Plugin {
public:
  static void RegisterWithRegistrar(flutter::PluginRegistrar *registrar);

  HybridV4l2Plugin(std::unique_ptr<ViewAPI> view_api);

  virtual ~HybridV4l2Plugin();

private:
  std::unique_ptr<ViewAPI> view_api;
};

HybridV4l2Plugin::HybridV4l2Plugin(std::unique_ptr<ViewAPI> view_api)
    : view_api(std::move(view_api)) {}

HybridV4l2Plugin::~HybridV4l2Plugin() {}

// static
void HybridV4l2Plugin::RegisterWithRegistrar(
    flutter::PluginRegistrar *registrar) {
  auto messenger = registrar->messenger();
  auto texture_registrar = registrar->texture_registrar();

  auto view_api = std::make_unique<ViewAPI>(texture_registrar);
  ViewHostAPI::SetUp(messenger, view_api.get());

  auto plugin = std::make_unique<HybridV4l2Plugin>(std::move(view_api));
  registrar->AddPlugin(std::move(plugin));
}
} // namespace hybrid_v4l2

void HybridV4l2PluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hybrid_v4l2::HybridV4l2Plugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrar>(registrar));
}
