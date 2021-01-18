import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String title = "Title";
  String helperText = "Helper";

  @override
  void initState() {
    _firebaseMessaging.configure(
      //this is to recieve the message from the firebase messaging.
      onMessage: (message) async {
        setState(() {
          title = message['notification']['title'];
          helperText = "This is from onMessage function.";
        });
        print(title);
        print(helperText);
      },
      // this is when our appliction in is background then this method is called.
      onResume: (message) async {
        setState(() {
          title = message['data']['title'];
          helperText = "This is from onResume method!!!!";
        });
      },
      //this onLaunch works when the app is not in the background anymore and recieved an notification from Server side it'll open the app also.5
      onLaunch: (message) async {
        setState(() {
          title = message['data']['title'];
          helperText = "This is from onLaunch method!!!!";
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification",
        ),
      ),
      body: Center(
        child: Text(
          "$title and $helperText",
          style: TextStyle(color: Colors.grey, fontSize: 30.0),
        ),
      ),
    );
  }
}
