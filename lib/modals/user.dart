class User {
  int pid;
  String name;
  String phoneNumber;
  String email;
  String password;
  int age;
  bool isPatient;
  String gender;
  User();
  User.parameterized(
      {this.pid,
      this.name,
      this.phoneNumber,
      this.email,
      this.password,
      this.isPatient,
      this.age,
      this.gender});

  Map<String, Object> toMap() {
    return {
      "name": this.name,
      "phoneNumber": this.phoneNumber,
      "email": this.email,
      "password": this.password,
      "isPatient": this.isPatient,
      "age": this.age,
      "gender": this.gender,
    };
  }
}
