#ifndef FLUTTER_PLUGIN_HYBRID_JPEG_PLUGIN_H_
#define FLUTTER_PLUGIN_HYBRID_JPEG_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace hybrid_jpeg {

class HybridJpegPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HybridJpegPlugin();

  virtual ~HybridJpegPlugin();

  // Disallow copy and assign.
  HybridJpegPlugin(const HybridJpegPlugin&) = delete;
  HybridJpegPlugin& operator=(const HybridJpegPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace hybrid_jpeg

#endif  // FLUTTER_PLUGIN_HYBRID_JPEG_PLUGIN_H_
