import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/screens/diseases.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print("Bool: " + snapshot.data.getBool("isPatient").toString());
          // print("String Bool: " + snapshot.data.getString("isPatientS"));
          // Bottom Pages
          List<Widget> pages = <Widget>[
            DiseasesScreen(),
            // Container(
            //   child: Text("Hahahaha"),
            // ),

            snapshot.data.getBool("isPatient") == null
                ? (snapshot.data.getString("isPatientS") == "true"
                    ? PatientBoard()
                    : DoctorBoard())
                : (snapshot.data.getBool("isPatient")
                    ? PatientBoard()
                    : DoctorBoard()),
            ProfileScreen(),
          ];
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

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
