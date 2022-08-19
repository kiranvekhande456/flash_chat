import 'package:flash_chat/Materialbutton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = "login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  late String email = "";
  late String password = "";
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
                tag: 'logo',
                child: Container(
                  height: 200,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kbutton.copyWith(hintText: "Enter your email")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  decoration:
                      kbutton.copyWith(hintText: "Enter your password")),
              SizedBox(
                height: 24.0,
              ),
              Materialbutton(
                  title: 'Log In',
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    try {
                      setState(() {
                        inProgress = true;
                      });
                      print(email);
                      print(password);
                      await auth.signInWithEmailAndPassword(
                          email: email, password: password);
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
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
