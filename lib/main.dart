import 'package:chatroom/chatscreen/chatscreenwindow.dart';
import 'package:chatroom/loginui/forgetpass.dart';
import 'package:chatroom/loginui/loginpage.dart';
import 'package:chatroom/loginui/registrationpage.dart';
import 'package:chatroom/pages/homescreen.dart';
import 'package:chatroom/pages/searchpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Ubuntu",
      ),
      initialRoute: LoginPage.id,
      routes: {
        //LoginUi
        LoginPage.id: (context) => LoginPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        ForgetPass.id: (context) => ForgetPass(),
        //chatPages
        HomeScreen.id: (context) => HomeScreen(),
        SearchPage.id: (context) => SearchPage(),
        ChatScreenWindow.id: (context) => ChatScreenWindow(),
      },
    );
  }
}
