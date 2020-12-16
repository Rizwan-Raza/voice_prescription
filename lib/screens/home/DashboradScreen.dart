import 'package:flutter/material.dart';
//import 'package:flutter_ui_challenges/src/pages/animations/animation1/animation1.dart';
//import 'package:cached_network_image/cached_network_image.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:charts_flutter/flutter.dart';
// as charts;

class DashboardOnePage extends StatelessWidget {
  //static final String path = "lib/src/pages/dashboard/dash1.dart";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).buttonColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        // SliverAppBar(
        //   pinned: true,
        //   // floating: true,
        //   expandedHeight: 90,
        //   flexibleSpace: FlexibleSpaceBar(
        //     title: Text("Student Dashboard"),
        //   ),
        // ),
        // Container(
        //   height: 20,
        //   color: Colors.red,
        //   child: Text('Hey'),
        // ),
        //_buildProfile(),
        _buildActivities(context),
      ],
    );
  }

  // SliverPadding _buildProfile() {
  //   return SliverPadding(
  //     padding: const EdgeInsets.only(top: 0),
  //     sliver: SliverGrid.count(
  //       crossAxisCount: 1,
  //       crossAxisSpacing: 8.0,
  //       mainAxisSpacing: 8.0,
  //       childAspectRatio: 3.5,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(top: 35),
  //           child: Container(
  //             color: Colors.red,
  //             child: Text("Student Name"),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  SliverPadding _buildActivities(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverToBoxAdapter(
        child: _buildTitledContainer(
          "Activities",
          height: 580,
          child: Expanded(
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              children: activities
                  .map(
                    (activity) => Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Theme.of(context).buttonColor,
                          child: activity.icon != null
                              ? Icon(
                                  activity.icon,
                                  //Icons.home,
                                  color: Colors.pink,
                                  size: 18.0,
                                )
                              : null,
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          activity.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14.0),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildTitledContainer(String title, {Widget child, double height}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22.0),
          ),
          if (child != null) ...[const SizedBox(height: 20.0), child]
        ],
      ),
    );
  }
}

/// Sample linear data type.

class Activity {
  final String title;
  final IconData icon;
  Activity({this.title, this.icon});
}

final List<Activity> activities = [
  // Activity(title: "Time Table", icon: Icons.calendarWeek),
  // Activity(title: "Assignments", icon: FontAwesomeIcons.fileAlt),
  // Activity(title: "Live Classes", icon: FontAwesomeIcons.eye),
  // Activity(title: "School Calander", icon: FontAwesomeIcons.calendar),
  // Activity(title: "Attendance", icon: FontAwesomeIcons.chartBar),
  // Activity(title: "Study Material", icon: FontAwesomeIcons.book),
  // Activity(title: "Report Card", icon: FontAwesomeIcons.graduationCap),
  // Activity(title: "Notice Board", icon: FontAwesomeIcons.clipboard),
  // Activity(title: "School Gallery", icon: FontAwesomeIcons.photoVideo),
  // Activity(title: "Sports", icon: FontAwesomeIcons.gamepad),
  // Activity(title: "Awards", icon: FontAwesomeIcons.trophy),
  // Activity(title: "Fee Due", icon: FontAwesomeIcons.rupeeSign),
  // Activity(title: "Parent-Teacher Records", icon: FontAwesomeIcons.history),
  // Activity(title: "About US", icon: FontAwesomeIcons.addressBook),
];
