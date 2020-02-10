package me.oska.sms_listener

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Telephony
import android.telephony.SmsMessage
import io.flutter.plugin.common.EventChannel


class SmsListener(private var context: Context): BroadcastReceiver(), EventChannel.StreamHandler {

    private var _eventSink: EventChannel.EventSink? = null

    fun hasListener(): Boolean {
        return _eventSink != null;
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this._eventSink = events;
        context.registerReceiver(this, IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION));
    }

    override fun onCancel(arguments: Any?) {
        this._eventSink = null;
        context.unregisterReceiver(this)
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent != null) {
            var sender = "";
            var message = "";

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                Telephony.Sms.Intents.getMessagesFromIntent(intent).forEach {
                    smsMessage ->
                        sender = smsMessage.displayOriginatingAddress
                        message += smsMessage.messageBody
                }
            } else {
                val bundle = intent.extras
                if (bundle != null) {
                    val pdus = bundle["pdus"] as Array<Any>
                    if (pdus == null) {
                        _eventSink?.error("INVALID_BUNDLE", "Sms bundle doesn't contains pdus key.", null);
                        return
                    }
                    val messages = arrayOfNulls<SmsMessage>(pdus.size)
                    for (i in messages.indices) {
                        messages[i] = SmsMessage.createFromPdu(pdus[i] as ByteArray)
                        message += messages[i]?.messageBody
                    }
                    sender = messages[0]!!.originatingAddress
                }
            }
            _eventSink?.success(arrayListOf(sender, message));
        }
    }
}