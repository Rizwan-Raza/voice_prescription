import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_prescription/modals/user.dart';

abstract class AuthBase {
  login(String email, String password);
  getUser();
}

class AuthServices extends AuthBase {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UserModal user;

  AuthServices();

  login(String email, String password) async {
    var loginCreds = await _fireAuth.signInWithEmailAndPassword(
        email: email, password: password);

    var obj =
        await _fireStore.collection("users").doc(loginCreds.user.uid).get();
    updatePrefs(UserModal.fromMap(obj.data()));
  }

  signup(UserModal user) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password);

    user.uid = userCredential.user.uid;

    await _fireStore.collection("users").doc(user.uid).set(user.toMap());
    updatePrefs(user);
  }

  getUser() {
    if (this.user == null) {
      // user = await _fireStore.collection("users").doc(value.user.uid).get();
    }
    return this.user;
  }

  updatePrefs(UserModal user) async {
    print(user.uid);
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString("uid", user.uid);
    _prefs.setBool("isPatient", user.isPatient);
    _prefs.setString("isPatientS", user.isPatient.toString());
    print("patient added");
    _prefs.setString("name", user.name);
    _prefs.setString("email", user.email);
    this.user = user;
  }
}
