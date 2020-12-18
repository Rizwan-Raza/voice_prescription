import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/modals/disease.dart';

class DiseasesScreen extends StatefulWidget {
  @override
  _DiseasesScreenState createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PatientServices services =
                Provider.of<PatientBase>(context, listen: false);
            Stream stream;
            stream = snapshot.data.getBool("isPatient") == null
                ? (snapshot.data.getString("isPatientS") == "true"
                    ? services.getDiseases(uid: snapshot.data.getString("uid"))
                    : services.getDiseases())
                : (snapshot.data.getBool("isPatient")
                    ? services.getDiseases(uid: snapshot.data.getString("uid"))
                    : services.getDiseases());

            return StreamBuilder(
                stream: stream,
                builder: (context, sSnapshot) {
                  if (sSnapshot.hasData) {
                    List<dynamic> map = sSnapshot.data.docs;
                    // return ListView.builder(itemBuilder: (_, index) {
                    //   return ListTile(title: map[index].);
                    // });
                    if (map.length == 0) {
                      return Center(
                        child: Text("No Diseases found"),
                      );
                    }
                    return Column(
                        children: map.map((e) {
                      DiseaseModal disease = DiseaseModal.fromMap(e.data());
                      return ListTile(
                        onTap: () {
                          if (disease.diagnosed)
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("OK"))
                                ],
                                content: ListView(shrinkWrap: true, children: [
                                  Text(
                                    disease.user.name,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20.0),
                                  ),
                                  Text(disease.kabSeH),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    disease.disease,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20.0),
                                  ),
                                  Text(disease.prescription)
                                ]),
                              ),
                            );
                        },
                        leading: Icon(Icons.opacity),
                        title: Text(disease.disease),
                        isThreeLine: true,
                        subtitle: Text(disease.diagnosed
                            ? "Diagnosed"
                            : "Not diagnosed yet" + "\n" + disease.kabSeH),
                      );
                    }).toList());
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
