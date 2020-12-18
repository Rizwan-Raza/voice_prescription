import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voice_prescription/modals/disease.dart';

abstract class PatientBase {
  addDisease(DiseaseModal disease);
  getDiseases({bool diagnosed, String uid});
  makePrescription(DiseaseModal disease);
}

class PatientServices extends PatientBase {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  PatientServices();

  Future<void> addDisease(DiseaseModal disease) {
    disease.did = Timeline.now.toString();
    return _fireStore
        .collection("diseases")
        .doc(disease.did)
        .set(disease.toMap());
  }

  getDiseases({bool diagnosed, String uid}) {
    if (uid != null) {
      return _fireStore
          .collection("diseases")
          .where("uid", isEqualTo: uid)
          .snapshots();
    }
    if (diagnosed != null) {
      return _fireStore
          .collection("diseases")
          .where("diagnosed", isEqualTo: diagnosed)
          .snapshots();
    }
    return _fireStore.collection("diseases").snapshots();
  }

  makePrescription(DiseaseModal disease) async {
    return _fireStore
        .collection("diseases")
        .doc(disease.did)
        .update({"diagnosed": true, "prescription": disease.prescription});
  }
}
