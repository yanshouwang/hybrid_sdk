package dev.hebei.hybrid_uvc

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.graphics.Rect
import android.util.Log
import android.view.Surface
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import androidx.core.content.ContextCompat
import io.flutter.plugin.platform.PlatformView
import kotlin.concurrent.thread

class UVCView(private val viewId: Int, context: Context) : PlatformView {
    private val view = SurfaceView(context)
    private val display = ContextCompat.getDisplayOrDefault(context)

    private val memories = mutableListOf<ByteArray>()

    private val callback = object : SurfaceHolder.Callback {
        var drawable = true

        val threadCount = 3
        val timestamps = arrayOfNulls<Long>(threadCount)
        val bitmaps = mutableListOf<Bitmap>()

        override fun surfaceCreated(holder: SurfaceHolder) {
            Log.d("UVCView", "surfaceCreated")
            val millis = 10L
            // Decode threads.
            for (i in 0 until threadCount) {
                thread {
                    while (drawable) {
                        val item = synchronized(this) {
                            val memory = this@UVCView.memories.removeFirstOrNull() ?: return@synchronized null
                            val timestamp = System.currentTimeMillis()
                            this.timestamps[i] = timestamp
                            return@synchronized Pair(timestamp, memory)
                        }
                        if (item == null) {
                            Log.d("UVCView", "Decode thread waiting for memory.")
                            Thread.sleep(millis)
                            continue
                        }
                        val timestamp = item.first
                        val memory = item.second
                        val m = Matrix()
                        when (this@UVCView.display.rotation) {
                            Surface.ROTATION_0 -> m.setRotate(-90f)
                            Surface.ROTATION_90 -> m.setRotate(0f)
                            Surface.ROTATION_180 -> m.setRotate(90f)
                            Surface.ROTATION_270 -> m.setRotate(180f)
                        }
                        val source = BitmapFactory.decodeByteArray(memory, 0, memory.size)
                        if (source == null) {
                            Log.w("UVCView", "Draw thread source is null.")
                            continue
                        }
                        val bitmap = Bitmap.createBitmap(source, 0, 0, source.width, source.height, m, false)
                        while (true) {
                            val idle = synchronized(this) {
                                val isNewer = this.timestamps.any { it != null && it < timestamp }
                                if (isNewer) {
                                    Log.d("UVCView", "Draw thread Waiting for other threads.")
                                    return@synchronized false
                                }
                                if (this.bitmaps.size > 2) {
                                    Log.d("UVCView", "Draw thread Waiting to draw.")
                                    return@synchronized false
                                }
                                this.bitmaps.add(bitmap)
                                this.timestamps[i] = null
                                return@synchronized true
                            }
                            if (idle) {
                                break
                            }
                            Thread.sleep(millis)
                        }
                    }
                }
            }
            // Draw thread.
            thread {
                while (drawable) {
                    val bitmap = synchronized(this) { this.bitmaps.removeFirstOrNull() }
                    if (bitmap == null) {
                        // Log.d("UVCView", "Draw thread waiting for bitmap.")
                        Thread.sleep(millis)
                        continue
                    }
                    val canvas = holder.lockCanvas()
                    if (canvas == null) {
                        Log.d("UVCView", "Draw thread canvas is null.")
                        break
                    }
                    try {
                        val width = canvas.width
                        val height = canvas.height
                        val dst = Rect(0, 0, width, height)
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
            drawable = false
        }
    }

    init {
        view.holder.addCallback(callback)
    }

    override fun getView(): View {
        return view
    }

    // Called by JNI.
    fun getMemories(): List<ByteArray> {
        return synchronized(this) { this.memories }
    }

    // Called by JNI.
    fun addMemory(memory: ByteArray) {
        synchronized(this) { this.memories.add(memory) }
    }

    override fun dispose() {
        Log.d("UVCView", "dispose.")
        view.holder.removeCallback(callback)
        UVCViewFactory.dispose(viewId)
    }
}