package br.com.pwlimaverde.sistem_configure_vt

import android.content.Context
import android.media.projection.MediaProjectionManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANEL = "method.record"

    private lateinit var mediaProjectionManage: MediaProjectionManager

    public fun onCapture() {
        start()
    }

    private fun start() {
        mediaProjectionManage =
            getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(
            mediaProjectionManage.createScreenCaptureIntent(),
            MEDIA_REQUEST_CODE
        )
    }

    companion object{
        private const val MEDIA_REQUEST_CODE = 2000
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANEL).setMethodCallHandler{
            call, result ->
            if(call.method == "onCapture") {
                start()
                result.success("Method chamado")
            }
        }
    }

}
