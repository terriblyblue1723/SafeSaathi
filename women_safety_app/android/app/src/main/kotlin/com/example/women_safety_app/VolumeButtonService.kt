import android.app.Service
import android.content.Intent
import android.content.IntentFilter
import android.os.IBinder
import android.content.BroadcastReceiver  // Add this
import android.content.Context  // Add this

class VolumeButtonService : Service() {
    private var volumeReceiver: BroadcastReceiver? = null

    override fun onCreate() {
        super.onCreate()
        registerVolumeReceiver()
    }

    private fun registerVolumeReceiver() {
        volumeReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                if (intent?.action == "android.media.VOLUME_CHANGED_ACTION") {
                    // Handle volume button press
                    val i = Intent("com.example.women_safety_app.VOLUME_BUTTON_PRESSED")
                    sendBroadcast(i)
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

    override fun onBind(intent: Intent?): IBinder? = null
}