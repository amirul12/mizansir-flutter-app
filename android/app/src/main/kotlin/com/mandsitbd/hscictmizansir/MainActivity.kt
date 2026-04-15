package com.mandsitbd.hscictmizansir

import android.os.Bundle
import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "mizansir/screen_security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSecurity" -> {
                    enableScreenSecurity()
                    result.success(null)
                }
                "disableSecurity" -> {
                    disableScreenSecurity()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun enableScreenSecurity() {
        runOnUiThread {
            window.setFlags(
                LayoutParams.FLAG_SECURE,
                LayoutParams.FLAG_SECURE
            )
        }
    }

    private fun disableScreenSecurity() {
        runOnUiThread {
            window.clearFlags(
                LayoutParams.FLAG_SECURE
            )
        }
    }
}
