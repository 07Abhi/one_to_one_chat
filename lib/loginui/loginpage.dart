import 'package:chatroom/internetaccess/connectionchecker.dart';
import 'package:chatroom/loginui/forgetpass.dart';
import 'package:chatroom/loginui/registrationpage.dart';
import 'package:chatroom/notificationservice/notification_service_methods/notificationservicesmethods.dart';
import 'package:chatroom/pages/homescreen.dart';
import 'package:chatroom/utils/app_colors.dart';
import 'package:chatroom/utils/app_textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  static const String id = "/loginpage";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoggedIn = false;
  getAutoSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLogged') ?? false;
    });
  }

  @override
  void initState() {
    checkConenctivity(context);
    getAutoSignIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn
        ? HomeScreen()
        : Scaffold(
            backgroundColor: AppColor.scaffBackgroundColor.withOpacity(0.2),
            appBar: AppBar(
              title: Text("Login Page"),
              centerTitle: true,
            ),
            body: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                      controller: _emailController,
                      style: TextStyle(color: AppColor.textfieldColor),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: textFieldStyle(hintext: "Email Address")),
                  SizedBox(
                    height: 40.0,
                  ),
                  TextField(
                    controller: _passwordController,
                    style: TextStyle(color: AppColor.textfieldColor),
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: textFieldStyle(hintext: "Password"),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, ForgetPass.id),
                      child: Text(
                        "Forget Password",
                        style: loginPageStyle(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ButtonTheme(
                      height: 50.0,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      child: FlatButton(
                        color: AppColor.flatButtonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          "Login",
                          style: buttonStyle(),
                        ),
                        onPressed: () async {
                          try {
                            final result =
                                await _auth.signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            pref.setBool('isLogged', true);
                            if (result != null) {
                              NotificationServices().saveDeviceTokenUpdate();
                              Toast.show(
                                "User loggedIn",
                                context,
                                duration: 3,
                                gravity: Toast.CENTER,
                                backgroundColor: AppColor.toastBackground,
                                textColor: AppColor.toastTextColor,
                              );
                              SystemChannels.textInput
                                  .invokeMethod("TextInput.hide");
                              _emailController.clear();
                              _passwordController.clear();
                              Navigator.pushNamed(context, HomeScreen.id);
                            }
                          } catch (e) {
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
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, RegistrationPage.id),
                    child: Text(
                      "Dont have Accout Register Now",
                      style: loginPageStyle(),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
