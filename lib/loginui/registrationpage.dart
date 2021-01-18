import 'package:chatroom/databasesmethods/database_access_methods.dart';
import 'package:chatroom/utils/app_colors.dart';
import 'package:chatroom/utils/app_textstyles.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = "/registrationpage";
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String token;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseMessaging _messaging = FirebaseMessaging();

  generateToken() async {
    String str = await _messaging.getToken();
    setState(() {
      token = str;
    });
  }

  @override
  void initState() {
    generateToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffBackgroundColor.withOpacity(0.2),
      appBar: AppBar(
        title: Text("Registration State"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _nameController,
                style: TextStyle(color: AppColor.textfieldColor),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                decoration: textFieldStyle(hintext: "Name"),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                  controller: _emailController,
                  style: TextStyle(color: AppColor.textfieldColor),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: textFieldStyle(hintext: "Email")),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                  controller: _passwordController,
                  style: TextStyle(color: AppColor.textfieldColor),
                  obscureText: true,
                  decoration: textFieldStyle(hintext: "Password")),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: ButtonTheme(
                  height: 50.0,
                  minWidth: MediaQuery.of(context).size.width * 0.6,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onPressed: () async {
                      try {
                        final result =
                            await _auth.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        if (result != null) {
                          DatabaseMethodsAcess().createDatabase(
                            email: _emailController.text,
                            name: _nameController.text,
                            uid: _auth.currentUser.uid,
                            token: token,
                          );
                          SystemChannels.textInput
                              .invokeMethod("TextInput.hide");
                          Toast.show(
                            "Data Submitted",
                            context,
                            duration: 3,
                            gravity: Toast.CENTER,
                            backgroundColor: AppColor.toastBackground,
                            textColor: AppColor.toastTextColor,
                          );
                          _nameController.clear();
                          _emailController.clear();
                          _passwordController.clear();
                        } else {
                          Toast.show(
                            "Not Registered",
                            context,
                            duration: 3,
                            gravity: Toast.CENTER,
                            backgroundColor: AppColor.toastBackground,
                            textColor: AppColor.toastTextColor,
                          );
                        }
                      } catch (e) {
                        print(e.message);
                        Toast.show(
                          e.message,
                          context,
                          duration: 3,
                          gravity: Toast.CENTER,
                          backgroundColor: AppColor.toastBackground,
                          textColor: AppColor.toastTextColor,
                        );
                      }
                    },
                    child: Text("Register", style: buttonStyle()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
