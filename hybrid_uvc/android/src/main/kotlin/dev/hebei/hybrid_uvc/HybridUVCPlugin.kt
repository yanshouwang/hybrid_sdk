package dev.hebei.hybrid_uvc

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** HybridUVCPlugin */
class HybridUVCPlugin : FlutterPlugin {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val registry = binding.platformViewRegistry
        registry.registerViewFactory("hebei.dev/UVCView", UVCViewFactory)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }
}
