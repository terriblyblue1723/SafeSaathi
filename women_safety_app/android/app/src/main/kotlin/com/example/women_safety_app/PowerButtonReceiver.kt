package com.example.women_safety_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class PowerButtonReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "PowerButtonReceiver"
        private const val PRESS_TIMEOUT = 3000L // 3 seconds timeout
        private var pressCount = 0
        private var lastPressTime = 0L
        private const val CHANNEL = "com.example.women_safety_app/power_button"
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            Intent.ACTION_SCREEN_OFF -> {
                val currentTime = System.currentTimeMillis()
                if (currentTime - lastPressTime > PRESS_TIMEOUT) {
                    pressCount = 1
                } else {
                    pressCount++
                }
                lastPressTime = currentTime

                if (pressCount >= 5) {
                    Log.d(TAG, "5 power button presses detected!")
                    pressCount = 0
                    triggerSOS(context)
                }

                // Reset press count after timeout
                Handler(Looper.getMainLooper()).postDelayed({
                    if (System.currentTimeMillis() - lastPressTime >= PRESS_TIMEOUT) {
                        pressCount = 0
                    }
                }, PRESS_TIMEOUT)
            }
        }
    }

    private fun triggerSOS(context: Context) {
        // Send event to Flutter
        FlutterEngine(context).dartExecutor.binaryMessenger.let { messenger ->
            MethodChannel(messenger, CHANNEL).invokeMethod("triggerSOS", null)
        }
    }
}
