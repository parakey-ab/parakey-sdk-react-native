package co.parakey.sdk.reactnative

import android.app.Application
import co.parakey.sdk.Parakey
import co.parakey.sdk.ParakeyError
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch
import androidx.core.graphics.toColorInt



class ParakeySdkReactNativeModule(
    private val context: ReactApplicationContext
) : ReactContextBaseJavaModule(context) {
    private val scope = MainScope()
    private val app: Application
        get() = context.applicationContext as Application

    override fun getName() = "ParakeyBridge"

    @ReactMethod
    fun configure(tokenBundle: String, promise: Promise) {
        scope.launch {
            complete(promise, Parakey.configure(tokenBundle))
        }
    }

    @ReactMethod
    fun deconfigure(promise: Promise) {
        scope.launch {
            Parakey.deconfigure()
            promise.resolve(null)
        }
    }

    @ReactMethod
    fun showScan(promise: Promise) {
        scope.launch {
            complete(promise, Parakey.showScan())
        }
    }

    @ReactMethod
    fun setTheme(hexColors: ReadableMap, promise: Promise) {
        try {
            fun color(name: String) = hexColors.getString(name)?.normalizeColor()

            Parakey.theme(
                actionLight = color("actionLight"),
                actionDark = color("actionDark"),
                titleLight = color("titleLight"),
                titleDark = color("titleDark"),
            )

            promise.resolve(null)
        } catch (e: Exception) {
            promise.reject("INVALID_THEME_COLOR", e.message)
        }
    }

    // String.toColorInt() expects #AARRGGBB for 8-char hex, but JS/CSS uses #RRGGBBAA.
    private fun String.normalizeColor(): Int {
        val hex = trim().removePrefix("#")
        val normalized = if (hex.length == 8) hex.takeLast(2) + hex.dropLast(2) else hex
        return "#$normalized".toColorInt()
    }

    private fun complete(promise: Promise, result: ParakeyError?) {
        if (result != null) {
            promise.reject(code = result.toString(), message = null)
        } else {
            promise.resolve(null)
        }
    }
}
