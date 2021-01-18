import 'package:chatroom/loginui/loginpage.dart';
import 'package:chatroom/notificationservice/notification_testing.dart';
import 'package:chatroom/pages/searchpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "/homescreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  QuerySnapshot userData;
  //Methods for all the user present in databse.
  Future<QuerySnapshot> getAllUsers() async {
    QuerySnapshot data = await _firebaseFirestore.collection('users').get();
    setState(() {
      userData = data;
    });
    return data;
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () => Navigator.pushNamed(context, SearchPage.id),
      ),
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        title: Text("Chat Room"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notification_important_outlined,
              size: 30.0,
              color: Colors.white54,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPage(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 30.0,
            color: Colors.white60,
            onPressed: () async {
              await _auth.signOut();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLogged', false);
              Navigator.pushReplacementNamed(context, LoginPage.id);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FutureBuilder<QuerySnapshot>(
          future: getAllUsers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white54,
                  strokeWidth: 5.0,
                ),
              );
            }
            return ListView.builder(
              itemCount: userData.docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 10.0),
                  child: ListTile(
                    tileColor: Colors.white60,
                    title: Text(userData.docs[index].data()['name']),
                    subtitle: Text(userData.docs[index].data()['email']),
                    trailing: FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Message",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                );
              },
              shrinkWrap: true,
            );
          },
        ),
      ),
    );
  }
}
