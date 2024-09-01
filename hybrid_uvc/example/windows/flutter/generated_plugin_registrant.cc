//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <hybrid_jpeg/hybrid_jpeg_plugin_c_api.h>
#include <hybrid_usb/hybrid_usb_plugin_c_api.h>
#include <hybrid_uvc/hybrid_uvc_plugin_c_api.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  HybridJpegPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HybridJpegPluginCApi"));
  HybridUsbPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HybridUsbPluginCApi"));
  HybridUvcPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HybridUvcPluginCApi"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
}
