package com.example.women_safety_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.women_safety_app/volume_button"
    private lateinit var channel: MethodChannel
    private var volumeReceiver: BroadcastReceiver? = null
    private var lastVolume: Int = -1
    private lateinit var audioManager: AudioManager

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        lastVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
        
        setupMethodChannel()
        registerVolumeReceiver()
    }

    private fun setupMethodChannel() {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "configureAudio" -> {
                    configureAudioForSOS()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun configureAudioForSOS() {
        // Force audio to phone speaker
        audioManager.mode = AudioManager.MODE_NORMAL
        audioManager.isSpeakerphoneOn = true
        
        // Set volume to maximum
        val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        audioManager.setStreamVolume(
            AudioManager.STREAM_MUSIC,
            maxVolume,
            0
        )

        // Request audio focus
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val focusRequest = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
                .setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build()
                )
                .build()
            audioManager.requestAudioFocus(focusRequest)
        } else {
            @Suppress("DEPRECATION")
            audioManager.requestAudioFocus(null, AudioManager.STREAM_MUSIC, AudioManager.AUDIOFOCUS_GAIN)
        }
    }

    private fun registerVolumeReceiver() {
        volumeReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == "android.media.VOLUME_CHANGED_ACTION") {
                    val currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
                    if (currentVolume < lastVolume) {  // Check if it's volume down
                        runOnUiThread {
                            channel.invokeMethod("volumeButtonPressed", true)
                        }
                    }
                    lastVolume = currentVolume
                }
            }
        }

        val filter = IntentFilter("android.media.VOLUME_CHANGED_ACTION")
        registerReceiver(volumeReceiver, filter)
    }

    override fun onDestroy() {
        volumeReceiver?.let { unregisterReceiver(it) }
        super.onDestroy()
    }
}