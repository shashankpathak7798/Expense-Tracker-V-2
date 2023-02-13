import 'package:expense_tracker_v2/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import './screens/auth_screen.dart';
import './screens/view_transactions_screen.dart';

var firebase;
void main() async {
  runApp(MyApp());
  firebase =  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        errorColor: Colors.red,
        fontFamily: 'Quicksand'
      ),
      home: Scaffold(
        backgroundColor: Colors.white10,
        body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: ((context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done) {
              if(snapshot.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred'), backgroundColor: Theme.of(context).errorColor,),);
                return Center(
                  child: Text('Error!!'),
                );
              }
              return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (ctx, userSnapshot) {
                if (userSnapshot.hasData) {
                  return HomeScreen();
                }
                return AuthScreen();
              },);
            }
            return Center(
                child: CircularProgressIndicator(),
            );
          }),
        ),
      ),
      routes: {
        ViewTransactionsScreen.routeName: (ctx) => ViewTransactionsScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
      },

      );
  }
}