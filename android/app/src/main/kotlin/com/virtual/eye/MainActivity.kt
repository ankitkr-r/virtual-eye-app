package com.virtual.eye

import android.content.Intent
import android.provider.Settings
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Context
import android.view.accessibility.AccessibilityManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "system_settings"
        ).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->

            if (call.method == "data-roaming") {
                openSetting(Settings.ACTION_DATA_ROAMING_SETTINGS)
                result.success(true)
            } else if(call.method == "isAccessibilityEnabled") {
                val accessibilityManager = getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager

                // --- ACCESSIBILITY FIX ---
                // Changed FEEDBACK_ALL_MASK to FEEDBACK_SPOKEN to strictly detect Screen Readers like TalkBack
                val enabledServices = accessibilityManager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_SPOKEN)
                // -------------------------

                result.success(enabledServices.isNotEmpty())
            } else {
                result.notImplemented()
            }

        }
    }

    private fun openSetting(name: String) {
        try {
            startActivity(Intent(name).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        } catch (e: Exception) {
            openSystemSettings()
        }
    }

    private fun openSystemSettings() {
        startActivity(Intent(Settings.ACTION_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
    }
}