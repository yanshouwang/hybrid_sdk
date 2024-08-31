#include "include/hybrid_usb/hybrid_usb_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "hybrid_usb_plugin.h"

void HybridUsbPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hybrid_usb::HybridUsbPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
