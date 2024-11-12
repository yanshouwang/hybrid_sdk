package dev.hebei.hybrid_os_android

import android.database.ContentObserver
import android.os.Handler
import androidx.annotation.Keep

@Keep
class ContentObserverImpl(handler: Handler, private val callback: ChangeCallback) :
    ContentObserver(handler) {
    override fun onChange(selfChange: Boolean) {
        super.onChange(selfChange)
        callback.onChange()
    }

    interface ChangeCallback {
        fun onChange()
    }
}