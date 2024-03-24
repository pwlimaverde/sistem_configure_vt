package br.com.pwlimaverde.sistem_configure_vt

import android.app.Service
import android.content.Intent
import android.media.MediaRecorder
import android.os.Build
import android.os.IBinder
import android.widget.Toast
import java.io.File
import java.io.FileOutputStream

class RecorderService : Service() {

    private var recorder: MediaRecorder? = null
    private var audioFile: File? = null

    companion object {
        val ACTION_START = "ActionStart"
        val ACTION_STOP = "ActionStop"
    }


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        return if (intent != null) {
            when (intent.action) {
                ACTION_START -> {
                    Toast.makeText(this, "Service Start", Toast.LENGTH_SHORT).show()
                    File(cacheDir, "teste.mp3").also {
                        startRecord(it)
                        audioFile = it

                    }
                    Toast.makeText(this, "Caminho cacheDir", Toast.LENGTH_SHORT).show()
                    START_STICKY
                }

                ACTION_STOP -> {
                    Toast.makeText(this, "Service Stop", Toast.LENGTH_SHORT).show()
                    stop()
                    START_NOT_STICKY
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
}