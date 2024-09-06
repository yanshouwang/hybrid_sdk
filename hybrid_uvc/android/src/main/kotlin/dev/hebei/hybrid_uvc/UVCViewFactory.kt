package dev.hebei.hybrid_uvc

import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.util.Log
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import kotlin.concurrent.thread


object UVCViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    private val views = mutableMapOf<Int, UVCView>()

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("UVCViewFactory", "create $viewId.")
        return views.getOrPut(viewId) { UVCView(viewId, context) }
    }

    fun retrieve(viewId: Int): UVCView {
        return views[viewId] ?: throw IllegalArgumentException("Illegal viewId $viewId.")
    }

    fun dispose(viewId: Int) {
        views.remove(viewId)
    }
}