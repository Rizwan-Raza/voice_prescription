import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_prescription/blocs/auth.dart';

class CompleteProfile extends StatefulWidget {
  CompleteProfile({Key key}) : super(key: key);

  @override
  _CompleteProfileState createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _profileFormKey = GlobalKey<FormState>();

  String gender;
  int age;

  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    return !showLoader
        ? ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context)),
                title: Center(child: Text("Complete your profile")),
                trailing: Container(width: 48.0),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _profileFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 16.0),
                          child: DropdownButton<String>(
                            hint: Text("Gender"),
                            value: gender,
                            isExpanded: true,
                            items: <String>[
                              'Male',
                              'Female',
                              'Other',
                              'Rather not say'
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.green),
                          decoration: InputDecoration(
                            hintText: "Age",
                            hintStyle: TextStyle(color: Colors.green.shade200),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your age';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            age = int.parse(value);
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            child: Text("Continue"),
                            onPressed: () async {
                              if (_profileFormKey.currentState.validate()) {
                                setState(() {
                                  showLoader = true;
                                });
                                _profileFormKey.currentState.save();
                                await Provider.of<AuthBase>(context,
                                        listen: false)
                                    .completeProfile(gender: gender, age: age);
                                setState(() {
                                  showLoader = false;
                                });
                              }
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
