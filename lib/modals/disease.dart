import 'package:voice_prescription/modals/user.dart';

class DiseaseModal {
  DiseaseModal();

  String did;
  String uid;
  String disease;
  String kabSeH;
  bool diagnosed;
  String prescription;
  UserModal user;

  DiseaseModal.fromMap(Map<String, Object> map) {
    this.did = map['did'];
    this.uid = map['uid'];
    this.disease = map['disease'];
    this.kabSeH = map['kabSeH'];
    this.diagnosed = map['diagnosed'];
    this.prescription = map['prescription'];
    this.user = UserModal.fromMap(map['user']);
  }

  Map<String, Object> toMap() {
    return {
      "did": this.did,
      "uid": this.uid,
      "disease": this.disease,
      "kabSeH": this.kabSeH,
      "diagnosed": this.diagnosed,
      "prescription": this.prescription,
      "user": this.user.toMap(),
    };
  }
}
