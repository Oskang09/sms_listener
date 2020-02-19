# Introduction

a simple native sms listener ( android only )

# Usage

```dart
// Construct listener
SmsListener listener = SmsListener();

// After listen first message will unsubscribe automatically or cancel when error.
listener.receiveOnce(
    (Message message) {},
    errorCallback: (PlatformException exception) {},
    cancelOnError: true,
);

// Will keep listening until error or cancel by unsubcribe
var sub = listener.onReceive(
    (Message message) {},
    errorCallback: (PlatformException exception) {},
    cancelOnError: true,
);
sub();
```