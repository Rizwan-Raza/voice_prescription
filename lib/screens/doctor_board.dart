import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/screens/dashboard.dart';

class DoctorBoard extends StatefulWidget {
  const DoctorBoard({Key key}) : super(key: key);

  @override
  _DoctorBoardState createState() => _DoctorBoardState();
}

class _DoctorBoardState extends State<DoctorBoard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
                future: Provider.of<PatientBase>(context, listen: false)
                    .getDiseases(snapshot.data.getString("uid")),
                builder: (context, sSnapshot) {
                  if (sSnapshot.hasData) {
                    List<dynamic> map = sSnapshot.data.docs;
                    // return ListView.builder(itemBuilder: (_, index) {
                    //   return ListTile(title: map[index].);
                    // });
                    return Column(
                        children: map
                            .map((e) => ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DashboardScreen(
                                              uid: e.data()['user']['uid'])),
                                    );
                                  },
                                  leading: Icon(Icons.opacity),
                                  title: Text(e.data()['disease']),
                                  subtitle: Text(e.data()['user']['name']),
                                ))
                            .toList());
                    // return Text("Hello");
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
