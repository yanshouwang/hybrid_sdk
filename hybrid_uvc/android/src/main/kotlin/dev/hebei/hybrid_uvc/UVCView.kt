package dev.hebei.hybrid_uvc

import android.content.Context
import android.graphics.BitmapFactory
import android.graphics.Rect
import android.util.Log
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import io.flutter.plugin.platform.PlatformView
import kotlin.concurrent.thread

class UVCView(private val viewId: Int, context: Context) : PlatformView {
    private val view = SurfaceView(context)

    // Will be called by JNI.
    var memory: ByteArray? = null

    private val callback = object : SurfaceHolder.Callback {
        override fun surfaceCreated(holder: SurfaceHolder) {
            Log.d("UVCView", "surfaceCreated")
            thread {
                while (true) {
                    val memory = this@UVCView.memory
                    this@UVCView.memory = null
                    if (memory == null) {
                        // Sleep an interval of 60 FPS.
                        Thread.sleep(1000 / 60)
                        continue
                    }
                    val canvas = holder.lockCanvas()
                    if (canvas == null) {
                        Log.d("UVCView", "draw: canvas is null.")
                        break
                    }
                    try {
                        val bitmap = BitmapFactory.decodeByteArray(memory, 0, memory.size)
                        if (bitmap == null) {
                            Log.e("UVCView", "draw: bitmap is null.")
                            continue
                        }
                        val dst = Rect(0, 0, view.width, view.height)
                        canvas.drawBitmap(bitmap, null, dst, null)
                    } finally {
                        holder.unlockCanvasAndPost(canvas)
                    }
                }
            }
        }

        override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
            Log.d("UVCView", "surfaceChanged.")
        }

        override fun surfaceDestroyed(holder: SurfaceHolder) {
            Log.d("UVCView", "surfaceDestroyed.")
        }
    }

    init {
        view.holder.addCallback(callback)
    }

    override fun getView(): View {
        return view
    }

    override fun dispose() {
        Log.d("UVCView", "dispose.")
        view.holder.removeCallback(callback)
        UVCViewFactory.dispose(viewId)
    }
}