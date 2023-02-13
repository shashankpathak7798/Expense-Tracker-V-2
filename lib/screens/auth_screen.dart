import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_v2/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void submitForm(String emailId, String userName, String password, bool isLogin, BuildContext ctx) async {
    UserCredential result;
    try {
      if(isLogin) {
        result = await _auth.signInWithEmailAndPassword(email: emailId, password: password);
        _firestore.collection('users').doc(result.user?.uid);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName, arguments: result.user?.uid);
      } else {
        result = await _auth.createUserWithEmailAndPassword(email: emailId, password: password);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName, arguments: result.user?.uid);
      }
    } on PlatformException catch(err) {
      print(err);
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AuthForm(submitForm),
      ),
    );
  }
}
