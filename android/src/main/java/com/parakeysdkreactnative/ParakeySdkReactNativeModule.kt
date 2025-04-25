package com.parakeysdkreactnative


import android.app.Application
import co.parakey.sdk.Parakey
import co.parakey.sdk.ParakeyError
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

class ParakeySdkReactNativeModule(
  private val context: ReactApplicationContext
) : ReactContextBaseJavaModule(context) {
  private val scope = MainScope()
  private val app: Application
    get() = context.applicationContext as Application

  override fun getName() = "ParakeyBridge"

  @ReactMethod
  fun initialize(promise: Promise) {
    Parakey.initialize(app)
    promise.resolve(null)
  }

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

  private fun complete(promise: Promise, result: ParakeyError?) {
    if (result != null) {
      promise.reject(code = result.toString(), message = null)
    } else {
      promise.resolve(null)
    }
  }
}
