#include "include/hybrid_adb_windows/hybrid_adb_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "hybrid_adb_windows_plugin.h"

void HybridAdbWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  hybrid_adb_windows::HybridAdbWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
