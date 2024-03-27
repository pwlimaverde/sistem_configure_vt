package br.com.pwlimaverde.sistem_configure_vt

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.media.MediaRecorder
import android.os.Build
import android.os.IBinder
import android.widget.Toast
import androidx.core.app.NotificationCompat
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class RecorderService : Service() {

    private var recorder: MediaRecorder? = null

    companion object {
        val ACTION_START = "ActionStart"
        val ACTION_STOP = "ActionStop"
        val ACTION_INIT = "ActionInit"
        val ACTION_END = "ActionEnd"
        val ACTION_RESTART = "ActionRestart"

        var pathSave: String = "aguardando caminho..."

        private const val SERVICE_ID = 2000
        private const val NOTIFICATION_CHANEL_ID = "NotifyIDChannel"
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        startForeground(
            SERVICE_ID,
            NotificationCompat.Builder(this, NOTIFICATION_CHANEL_ID).build()
        )
    }


    private fun createNotificationChannel() {
        val notificationChannel = NotificationChannel(
            NOTIFICATION_CHANEL_ID,
            "Sistem Notification",
            NotificationManager.IMPORTANCE_DEFAULT
        )
        val notificationManager =
            getSystemService(NotificationManager::class.java) as NotificationManager

        notificationManager.createNotificationChannel(notificationChannel)
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return if (intent != null) {
            when (intent.action) {
                ACTION_INIT -> {
                    Toast.makeText(this, "Service Init", Toast.LENGTH_SHORT).show()
                    START_STICKY
                }
                ACTION_START -> {
                    var file = createFile()
                    startRecord(file)
                    START_STICKY
                }
                ACTION_STOP -> {
                    stop()
                    START_NOT_STICKY
                }
                ACTION_END -> {
                    stopSelf()
                    START_NOT_STICKY
                }
                ACTION_RESTART -> {
                    Toast.makeText(this, "Service Restart", Toast.LENGTH_SHORT).show()
                    START_STICKY
                }
                else -> throw RuntimeException("Falha no Serviço")
            }
        } else {
            START_NOT_STICKY
        }
    }



    override fun onBind(intent: Intent?): IBinder? = null

    private fun startRecord(outputFile: File) {
        createRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setOutputFile(FileOutputStream(outputFile).fd)

            prepare()
            start()

            recorder = this
        }
    }

    private fun stop() {
        recorder?.stop()
        recorder?.reset()
        recorder = null
    }

    private fun createRecorder(): MediaRecorder {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            MediaRecorder(this)
        } else MediaRecorder()
    }

    private fun createFile(): File {
        var dir = File(getExternalFilesDir(null), "/files_cript")
        if (!dir.exists()) {
            dir.mkdir()
        }
        val format = SimpleDateFormat("dd-mm-yyyy-hhmmss", Locale.US).format(Date())
        val filename = "file-$format.cript"
        pathSave = dir.absolutePath + "/" + filename
        return File(pathSave)
    }
}