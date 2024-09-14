package dev.hebei.hybrid_media_android

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class BroadcastReceiverImpl(private val callback: BroadcastCallback) : BroadcastReceiver() {

    interface BroadcastCallback {
        fun onReceive(context: Context, intent: Intent)
    }

    override fun onReceive(context: Context, intent: Intent) {
        callback.onReceive(context, intent)
    }
}