import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/screens/doctor_board.dart';
import 'package:voice_prescription/screens/patient_board.dart';
import 'package:voice_prescription/screens/profile.dart';

class AppScreen extends StatefulWidget {
  // static final String path = "lib/src/pages/misc/navybar.dart";
  final String uid;
  AppScreen({this.uid});
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  // Selected Page Index
  int _selectedIndex = 0;

  // Page Storage Bucket
  final PageStorageBucket bucket = PageStorageBucket();
  SharedPreferences _prefs;

  _AppScreenState() {
    init();
  }

  void init() async {
    this._prefs = await SharedPreferences.getInstance();
    print(this._prefs.getBool("isPatient"));
    setState(() {
      pages[1] =
          this._prefs.getBool("isPatient") ? PatientBoard() : DoctorBoard();
    });
  }

  // Bottom Pages
  List<Widget> pages = <Widget>[
    Container(
      child: Center(child: Text("Home")),
    ),
    Container(
      child: Text("sdjfhsdj"),
    ),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Prescription'),
        actions: [
          FlatButton(
              child: Text("Logout"),
              textColor: Colors.white,
              onPressed: () {
                FirebaseAuth.instance.signOut();
              })
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 142.0,
        child: IndexedStack(
          index: _selectedIndex,
          children: pages.map((Widget p) {
            return PageStorage(
              child: p,
              bucket: bucket,
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.apps, title: "Dashboard"),
          TabData(iconData: Icons.person, title: "Profile"),
        ],
        onTabChangedListener: (int index) {
          setState(() {
            this._selectedIndex = index;
          });
        },
      ),
    );
  }
}
