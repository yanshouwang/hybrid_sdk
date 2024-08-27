#ifndef FLUTTER_PLUGIN_HYBRID_UVC_PLUGIN_H_
#define FLUTTER_PLUGIN_HYBRID_UVC_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace hybrid_uvc {

class HybridUvcPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HybridUvcPlugin();

  virtual ~HybridUvcPlugin();

  // Disallow copy and assign.
  HybridUvcPlugin(const HybridUvcPlugin&) = delete;
  HybridUvcPlugin& operator=(const HybridUvcPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace hybrid_uvc

#endif  // FLUTTER_PLUGIN_HYBRID_UVC_PLUGIN_H_
