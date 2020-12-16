import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voice_prescription/screens/profile.dart';

class Dashboard extends StatefulWidget {
  // static final String path = "lib/src/pages/misc/navybar.dart";
  final String uid;
  Dashboard({this.uid});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Selected Page Index
  int _selectedIndex = 0;

  // Page Storage Bucket
  final PageStorageBucket bucket = PageStorageBucket();

  // Bottom Pages
  List<Widget> pages;
  @override
  Widget build(BuildContext context) {
    pages = <Widget>[
      Container(
        child: Center(child: Text("Home")),
      ),
      Container(
        child: Center(child: Text("Dashboard")),
      ),
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
}
