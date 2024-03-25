package br.com.pwlimaverde.sistem_configure_vt

import android.content.Intent
import android.media.MediaRecorder
import android.os.Build
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANEL = "method.record"
    private var recorder: MediaRecorder? = null

    private fun initService() {
        val initIntent = Intent(this, RecorderService::class.java).apply {
            action = RecorderService.ACTION_INIT
        }
        ContextCompat.startForegroundService(this, initIntent)
    }

    private fun startRecord() {
        val startIntent = Intent(this, RecorderService::class.java).apply {
            action = RecorderService.ACTION_START
        }
        ContextCompat.startForegroundService(this, startIntent)
    }

    private fun stopRecord(): String {
        val stopIntent = Intent(this, RecorderService::class.java).apply {
            action = RecorderService.ACTION_STOP
        }
        ContextCompat.startForegroundService(this, stopIntent)
        return RecorderService.pathSave
    }

    private fun endService() {
        val endIntent = Intent(this, RecorderService::class.java).apply {
            action = RecorderService.ACTION_END
        }
        ContextCompat.startForegroundService(this, endIntent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "onInit") {
                initService()
                result.success("Method Init Service")
            }
            if (call.method == "onStart") {
                startRecord()
                result.success("Method Start Record")
            }
            if (call.method == "onStop") {
                val pathSave = stopRecord()
                result.success(pathSave)
            }
            if (call.method == "onEnd") {
                initService()
                result.success("Method End Service")
            }
        }
    }
}
