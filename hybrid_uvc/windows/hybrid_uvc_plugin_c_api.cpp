#include "include/hybrid_uvc/hybrid_uvc_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "hybrid_uvc_plugin.h"

void HybridUvcPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hybrid_uvc::HybridUvcPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
