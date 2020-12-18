import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferences _prefs;

  _ProfileScreenState() {
    init();
  }

  void init() async {
    super.initState();
    this._prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    // print(user);
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Text(this._prefs != null
                  ? this._prefs.getString("name")
                  : "Loading ..."),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(this._prefs != null
                  ? this._prefs.getBool("isPatient")
                      ? "Patient"
                      : "Doctor"
                  : "Loading ..."),
            )
          ],
        ),
      ),
    );
  }
}
