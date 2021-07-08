import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/modals/disease.dart';

class DiseasesScreen extends StatefulWidget {
  @override
  _DiseasesScreenState createState() => _DiseasesScreenState();
}

class _DiseasesScreenState extends State<DiseasesScreen> {
  @override
  Widget build(BuildContext context) {
    PatientServices patientServices =
        Provider.of<PatientBase>(context, listen: false);
    AuthServices authServices = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder(
        stream: authServices.user.isPatient
            ? patientServices.getDiseases(uid: authServices.user.uid)
            : patientServices.getDiseases(diagnosed: true),
        builder: (context, sSnapshot) {
          if (sSnapshot.hasData) {
            List<dynamic> map = sSnapshot.data.docs;
            if (map.length == 0) {
              return Center(
                child: Text("No Diseases found"),
              );
            }
            return Column(
              children: <Widget>[
                ...ListTile.divideTiles(
                  color: Colors.grey,
                  tiles: map.map((e) {
                    DiseaseModal disease = DiseaseModal.fromMap(e.data());
                    return Dismissible(
                        secondaryBackground: Container(
                            color: Colors.red,
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            )),
                        background: Container(
                            color: Colors.red,
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            )),
                        key: Key(disease.did),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you want to delete this disease?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text("CANCEL"),
                                    ),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("DELETE")),
                                  ],
                                );
                              });
                        },
                        onDismissed: (dir) async {
                          await patientServices.removeDisease(disease.did);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Padding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: Text("Disease deleted"),
                          )));
                        },
                        child: ListTile(
                          onTap: disease.diagnosed
                              ? () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("OK"))
                                      ],
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            disease.user.name,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 20.0),
                                          ),
                                          Text(disease.kabSeH),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            disease.disease,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 20.0),
                                          ),
                                          Text(disease.prescription),
                                        ],
                                      ),
                                    ),
                                  )
                              : null,
                          leading: Icon(Icons.opacity),
                          title: Text(disease.disease),
                          isThreeLine: authServices.user.isPatient,
                          subtitle: Text(disease.diagnosed
                              ? "Diagnosed"
                              : "Not diagnosed yet" + "\n" + disease.kabSeH),
                        ));
                  }).toList(),
                ),
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
