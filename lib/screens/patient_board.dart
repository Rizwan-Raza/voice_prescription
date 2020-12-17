import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/blocs/patient.dart';
import 'package:voice_prescription/modals/disease.dart';
import 'package:voice_prescription/modals/user.dart';

class PatientBoard extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DiseaseModal diseaseModal = DiseaseModal();
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.add),
          title: Text("Add new Disease"),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                actions: [
                  FlatButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          SharedPreferences _prefs =
                              await SharedPreferences.getInstance();
                          diseaseModal.user = UserModal.fromMap({
                            "uid": _prefs.getString("uid"),
                            "name": _prefs.getString("name")
                          });

                          PatientServices patientServices =
                              Provider.of<PatientBase>(context, listen: false);
                          patientServices
                              .addDisease(diseaseModal)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text("OK"))
                ],
                content: Container(
                  height: 150,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: TextFormField(
                          style: TextStyle(color: Colors.green),
                          decoration: InputDecoration(
                              hintText: "Disease",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.opacity,
                                color: Colors.green,
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a disease';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            diseaseModal.disease = value;
                          },
                        )),
                        Container(
                          child: Divider(
                            color: Colors.green.shade400,
                          ),
                          padding: EdgeInsets.only(bottom: 10.0),
                        ),
                        Container(
                            child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          style: TextStyle(color: Colors.green),
                          decoration: InputDecoration(
                              hintText: "Kab se h?",
                              hintStyle:
                                  TextStyle(color: Colors.green.shade200),
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.event,
                                color: Colors.green,
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a date';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            diseaseModal.kabSeH = value;
                          },
                        )),
                        Container(
                          child: Divider(
                            color: Colors.green.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
