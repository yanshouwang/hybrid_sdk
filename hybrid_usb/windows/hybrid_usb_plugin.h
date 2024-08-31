#ifndef FLUTTER_PLUGIN_HYBRID_USB_PLUGIN_H_
#define FLUTTER_PLUGIN_HYBRID_USB_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace hybrid_usb {

class HybridUsbPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  HybridUsbPlugin();

  virtual ~HybridUsbPlugin();

  // Disallow copy and assign.
  HybridUsbPlugin(const HybridUsbPlugin&) = delete;
  HybridUsbPlugin& operator=(const HybridUsbPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace hybrid_usb

#endif  // FLUTTER_PLUGIN_HYBRID_USB_PLUGIN_H_
