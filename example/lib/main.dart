import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_listener/sms_listener.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    message = Message("PENDING", "PENDING");
    listener = SmsListener();
  }

  SmsListener listener;
  Message message;
  PlatformException error;

  void listenOnce() {
    listener.receiveOnce((Message newMessage) {
      print(newMessage);
      setState(() {
        message = newMessage;
      });
    }, errorCallback: (PlatformException exception) {
      error = exception;
    }, cancelOnError: true);
  }

  void listen() {
    listener.onReceive((Message newMessage) {
      print(newMessage);
      setState(() {
        message = newMessage;
      });
    }, errorCallback: (PlatformException exception) {
      setState(() {
        error = exception;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SMS Listener'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Text("Sender :" + message.sender),
            Text("Message : " + message.message),
            Text("Error : " + (error != null ? error.code + " " + error.message : "None")),
            RaisedButton(
              onPressed: listen,
              child: Text("Listen Once"),
            ),
            RaisedButton(
              onPressed: listen,
              child: Text("Listen Multiple"),
            ),
          ],
        )),
      ),
    );
  }
}
