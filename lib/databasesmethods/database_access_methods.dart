
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class DatabaseMethodsAcess {
  getUserByUserName(String userName) async {
    return await _firebaseFirestore
        .collection('users')
        .where('name', isEqualTo: userName)
        .get();
  }

  getUserByEmail(String email) async {
    return await _firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  createDatabase({String name, String email, String uid, String token}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .set({
      "name": name,
      "email": email,
      "uid": uid,
      "token": token,
      "createAt": FieldValue.serverTimestamp(),
    });
  }

  createChatRoom(String chatRoomId, userDataMap) {
    _firebaseFirestore
        .collection('chatRoom')
        .doc(chatRoomId)
        .set(userDataMap)
        .catchError((e) {
      print(e.message);
    });
  }

  sendChatMessages(String chatRoomId, messageMap) {
    _firebaseFirestore
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.message);
    });
  }

  getConversationMessages(String chatRoomId) {
    return _firebaseFirestore
        .collection('chatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }

  getChatRoom(String username) {
    return _firebaseFirestore
        .collection('chatRoom')
        .where("users", arrayContains: username)
        .snapshots();
  }
}
