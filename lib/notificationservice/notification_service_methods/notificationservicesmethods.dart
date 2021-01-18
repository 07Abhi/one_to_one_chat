import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseMessaging _fcm = FirebaseMessaging();

class NotificationServices {
  saveDeviceTokenUpdate() async {
    String uid = _auth.currentUser.uid;
    String token = await _fcm.getToken();
    if (token != null) {
      _firestore.collection('users').doc(uid).update({
        "createdAt": FieldValue.serverTimestamp(),
        "token": token,
        "platform": Platform.operatingSystem
      });
    }
  }
}
