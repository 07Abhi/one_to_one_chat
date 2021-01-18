import 'package:chatroom/utils/app_colors.dart';
import 'package:chatroom/utils/app_textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class ForgetPass extends StatefulWidget {
  static const String id = '/forgetPage';
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffBackgroundColor.withOpacity(0.2),
      appBar: AppBar(
        title: Text("Forget Password"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Enter your Registered E-Mail Address",
                  style: loginPageStyle(),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: AppColor.textfieldColor),
                decoration: textFieldStyle(hintext: "E-Mail Address"),
              ),
              SizedBox(
                height: 30.0,
              ),
              ButtonTheme(
                height: 50.0,
                minWidth: MediaQuery.of(context).size.width * 0.6,
                child: FlatButton(
                  onPressed: () async {
                    try {
                      await _auth.sendPasswordResetEmail(
                          email: _emailController.text);
                      SystemChannels.textInput.invokeMethod("TextInput.hide");
                      Toast.show(
                        "Reset Link sent!!!",
                        context,
                        duration: 3,
                        gravity: Toast.BOTTOM,
                        backgroundColor: AppColor.toastBackground,
                        textColor: AppColor.toastTextColor,
                      );
                      _emailController.clear();
                    } catch (e) {
                      Toast.show(
                        e.message,
                        context,
                        duration: 3,
                        gravity: Toast.BOTTOM,
                        backgroundColor: AppColor.toastBackground,
                        textColor: AppColor.toastTextColor,
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    "Send",
                    style: buttonStyle(),
                  ),
                  color: AppColor.flatButtonColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
