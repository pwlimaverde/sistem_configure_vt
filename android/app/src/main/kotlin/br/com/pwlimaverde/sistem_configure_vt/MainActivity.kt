package br.com.pwlimaverde.sistem_configure_vt

import android.content.Context
import android.content.Intent
import android.media.MediaRecorder
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.widget.Toast
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {



    private val CHANEL = "method.record"
    private var recorder: MediaRecorder? = null


    private lateinit var mediaProjectionManage: MediaProjectionManager


    private fun start() {
        mediaProjectionManage =
            getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(
            mediaProjectionManage.createScreenCaptureIntent(),
            MEDIA_REQUEST_CODE
        )
    }

    private fun startRecord() {
        createRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)

            prepare()
            start()

            recorder = this

        }
    }



    private fun startRecord2():String{
        val startIntent = Intent(this, RecorderService::class.java).apply {
            action = RecorderService.ACTION_START
        }
        ContextCompat.startForegroundService(this, startIntent)
        var pathSave = RecorderService.pathSave
        return pathSave

    }

    private fun stop2():String {
        val stopIntent = Intent(this, RecorderService::class.java).apply {
            action = RecorderService.ACTION_STOP
        }
        ContextCompat.startForegroundService(this, stopIntent)
        var pathSave = RecorderService.pathSave
        return pathSave

    }

    private fun stop() {
        recorder?.stop()
        recorder?.reset()
        recorder = null

    }

    private fun createRecorder(): MediaRecorder {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            MediaRecorder(context)
        } else MediaRecorder()
    }

    companion object {
        private const val MEDIA_REQUEST_CODE = 2000
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "onStart") {
                Toast.makeText(this, "on Start", Toast.LENGTH_SHORT).show()
                var pathSave = startRecord2()

                result.success("Method Start Record $pathSave")
            }
            if (call.method == "onStop") {
                var pathSave = stop2()
                Toast.makeText(this, "on Stop", Toast.LENGTH_SHORT).show()
                result.success(pathSave)
            }
        }
    }
}
