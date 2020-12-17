import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voice_prescription/modals/disease.dart';

abstract class PatientBase {
  addDisease(DiseaseModal disease);
  getDiseases(String uid);
}

class PatientServices extends PatientBase {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  PatientServices();

  Future<void> addDisease(DiseaseModal disease) {
    disease.did = Timeline.now.toString();
    return _fireStore
        .collection("diseases")
        .doc(disease.user.uid)
        .collection("list")
        .doc(disease.did)
        .set(disease.toMap());
  }

  Future<QuerySnapshot> getDiseases(String uid) {
    return _fireStore.collection("diseases").doc(uid).collection("list").get();
  }
}
