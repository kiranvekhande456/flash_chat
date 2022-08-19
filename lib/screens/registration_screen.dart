import 'package:flash_chat/Materialbutton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = "reg_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: inProgress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  height: 200,
                  child: Image.asset(
                    'images/logo.png',
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kbutton.copyWith(hintText: "Enter your email")),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration:
                      kbutton.copyWith(hintText: "Enter your password")),
              Materialbutton(
                  title: 'Register',
                  color: Colors.blueAccent,
                  onPressed: () async {
                    try {
                      setState(() {
                        inProgress = true;
                      });

                      var user = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                      print(user);
                      setState(() {
                        inProgress = false;
                      });
                      Navigator.pushNamed(context, ChatScreen.id);
                    } catch (e) {
                      print(e);
                      setState(() {
                        inProgress = false;
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
