import 'package:voice_prescription/modals/user.dart';

class DiseaseModal {
  DiseaseModal();

  String did;
  String disease;
  String kabSeH;
  UserModal user;

  DiseaseModal.fromMap(Map<String, Object> map) {
    this.did = map['did'];
    this.disease = map['disease'];
    this.kabSeH = map['kabSeH'];
    this.user = map['user'];
  }

  Map<String, Object> toMap() {
    return {
      "did": this.did,
      "disease": this.disease,
      "kabSeH": this.kabSeH,
      "user": this.user.toMap(),
    };
  }
}
