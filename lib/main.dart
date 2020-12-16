import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voice_prescription/screens/home/Dashboard.dart';
import 'package:voice_prescription/screens/login_signup/Login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Prescription',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        // Initialize FlutterFire
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Container(
                color: Colors.red,
                child: Center(child: Text(snapshot.error.toString())));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return HomeApp();
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Container(
            color: Colors.green[200],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      // Initialize FlutterFire
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, AsyncSnapshot<User> snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
              color: Colors.red,
              child: Center(child: Text(snapshot.error.toString())));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Otherwise, show something whilst waiting for initialization to complete
          return Container(
            color: Colors.green[200],
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Once complete, show your application
        if (snapshot.hasData) {
          // User loginUser = snapshot.data;
          User loginUser;

          // FirebaseFirestore.instance
          //     .collection("user")
          //     .where("email", isEqualTo: snapshot.data.email)
          //     .get()
          //     .then((value) => loginUser = value.docs.first.data());
          return FancyBottomBarPage(loginUser: loginUser);
        } else {
          print("Make Login");
          return LoginTwoPage();
        }
      },
    );
  }
}
