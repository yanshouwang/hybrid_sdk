package dev.hebei.hybrid_os_android

import android.app.Activity
import android.content.Intent
import androidx.annotation.Keep
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityOptionsCompat
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener

object AndroidImpl {
    private const val REQUEST_CODE = 1949

    private val listener = ActivityResultListener { requestCode, resultCode, _ ->
        if (requestCode != REQUEST_CODE) {
            return@ActivityResultListener false
        }
        Activity.RESULT_OK
        val callback = this.callback ?: return@ActivityResultListener false
        this.callback = null
        callback.onActivityResult()
        return@ActivityResultListener true
    }
    private var binding: ActivityPluginBinding? = null
    private var callback: StartActivityCallback? = null

    private val activity: Activity
        get() {
            val binding =
                this.binding ?: throw IllegalArgumentException("Activity binding is null.")
            return binding.activity
        }

    @Keep
    fun startActivity(intent: Intent, callback: StartActivityCallback) {
        if (this.callback != null) {
            throw IllegalStateException("Another request is ongoing and multiple requests cannot be handled at once.")
        }
        this.callback = callback
        val options = ActivityOptionsCompat.makeBasic().toBundle()
        ActivityCompat.startActivityForResult(activity, intent, REQUEST_CODE, options)
    }

    internal fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(this.listener)
        this.binding = binding
    }

    internal fun onDetachedFromActivity() {
        this.binding?.removeActivityResultListener(this.listener)
        this.binding = null
    }

    interface StartActivityCallback {
        fun onActivityResult()
    }
}