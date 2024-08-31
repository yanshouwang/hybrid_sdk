#include "include/hybrid_jpeg/hybrid_jpeg_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "hybrid_jpeg_plugin.h"

void HybridJpegPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hybrid_jpeg::HybridJpegPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
