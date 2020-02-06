library sms_listener;

import 'package:flutter/services.dart';

class Message {
  String sender;
  String message;

  Message(this.sender, this.message);
}

class SmsListener {
  final String _channelName = "me.oska.sms_listener/SmsListener";
  EventChannel _channel;

  SmsListener() {
    this._channel = EventChannel(_channelName);
  }

  // Another exception was thrown: type '_BroadcastSubscription<dynamic>' is not a subtype of type 'StreamSubscription<String>'
  // Stream error unable assign type-safety.
  Function() onReceive(Function(Message) fn,
      {Function(PlatformException) errorCallback, bool cancelOnError}) {
    dynamic _stream = this._channel.receiveBroadcastStream().listen(null);

    _stream.onData((dynamic data) {
      final List<dynamic> arrayData = data;
      fn(Message(arrayData[0], arrayData[1]));
    });

    if (errorCallback != null || cancelOnError != null) {
      _stream.onError((dynamic error) {
        if (cancelOnError != null && cancelOnError) {
          _stream.cancel();
          _stream = null;
        }

        if (errorCallback != null) {
          errorCallback(error);
        }
      });
    }
    return () {
      _stream.cancel();
    };
  }

  Function() receiveOnce(Function(Message) fn,
      {Function(PlatformException) errorCallback, bool cancelOnError}) {
    dynamic _stream = this._channel.receiveBroadcastStream().listen(null);
    _stream.onData((dynamic data) {
      final List<dynamic> arrayData = data;
      fn(Message(arrayData[0], arrayData[1]));
      _stream.cancel();
      _stream = null;
    });

    if (errorCallback != null || cancelOnError != null) {
      _stream.onError((dynamic error) {
        if (cancelOnError != null && cancelOnError) {
          _stream.cancel();
          _stream = null;
        }

        if (errorCallback != null) {
          errorCallback(error);
        }
      });
    }

    return () {
      if (_stream != null) {
        _stream.cancel();
      }
    };
  }
}
