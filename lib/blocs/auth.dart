import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    _fireAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      var obj = await _fireStore.collection("users").doc(value.user.uid).get();
      user = UserModal.fromMap(obj.data());
    }).catchError((onError) => print(onError.message));
  }

  getUser() {
    return user;
  }
}
