package me.oska.sms_listener

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

/** SmsListenerPlugin */
class SmsListenerPlugin: FlutterPlugin {

  private var listener: SmsListener? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    onInit(binding.applicationContext, binding.binaryMessenger)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    if (listener != null && listener!!.hasListener()) {
      binding.applicationContext.unregisterReceiver(listener);
    }
  }

  private fun onInit(context: Context, messenger: BinaryMessenger) {
    listener = SmsListener(context)
    EventChannel(messenger, CHANNEL).setStreamHandler(listener)
  }

  companion object {

    const val CHANNEL: String = "me.oska.sms_listener/SmsListener"

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = SmsListenerPlugin();
      instance.onInit(registrar.context(), registrar.messenger());
    }
  }
}
