import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_prescription/modals/user.dart';

abstract class AuthBase {
  login(String email, String password);
  signup(UserModal user);
  completeProfile({String gender, int age});
  get user;
  set user(UserModal user);

  get stackIndex;
  set stackIndex(int i);
}

class AuthServices extends AuthBase {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UserModal _user;
  int _sIndex = 0;

  AuthServices();

  login(String email, String password) async {
    var loginCreds = await _fireAuth.signInWithEmailAndPassword(
        email: email, password: password);

    print(loginCreds);

    var obj =
        await _fireStore.collection("users").doc(loginCreds.user.uid).get();
    this._user = UserModal.fromMap(obj.data());
  }

  signup(UserModal user) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password);

    user.uid = userCredential.user.uid;

    await _fireStore.collection("users").doc(user.uid).set(user.toMap());
    this._user = user;
  }

  get user {
    return this._user;
  }

  set user(UserModal lUser) {
    this._user = lUser;
  }

  logout() {
    return this._fireAuth.signOut();
  }

  changePassword(String old, String newP) async {
    await this._fireAuth.currentUser.reauthenticateWithCredential(
        EmailAuthProvider.credential(
            email: _fireAuth.currentUser.email, password: old));

    return _fireAuth.currentUser.updatePassword(newP);
  }

  deleteAccount() {
    return _fireAuth.currentUser.delete();
  }

  completeProfile({String gender, int age}) async {
    _user.gender = gender;
    _user.age = age;
    await _fireStore.collection("users").doc(_fireAuth.currentUser.uid).update(
        {if (gender != null) "gender": gender, if (age != null) "age": age});
    _fireAuth.authStateChanges();
  }

  get stackIndex {
    return this._sIndex;
  }

  set stackIndex(int i) {
    this._sIndex = i;
  }
}
