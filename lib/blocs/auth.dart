import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_prescription/modals/user.dart';

abstract class AuthBase {
  login(String email, String password);
  signup(UserModal user);
  get user;
  set user(UserModal user);
}

class AuthServices extends AuthBase {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UserModal _user;

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

  deleteAccount() async {
    return _fireAuth.currentUser.delete();
  }
}
