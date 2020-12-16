import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/screens/app.dart';
import 'package:voice_prescription/screens/auth/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => AuthServices(),
      child: MaterialApp(
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
          print("Main");
          print(snapshot.data.uid);
          return Dashboard(uid: snapshot.data.uid);
        } else {
          print("Make Login");
          return LoginScreen();
        }
      },
    );
  }
}
