class SignupData {
  String email;
  String password;
  String username;
  DateTime? dob;
  String? gender;
  int height;
  int weight;

  SignupData({
    required this.email,
    required this.password,
    required this.username,
    required this.dob,
    required this.gender,
    required this.height,
    required this.weight,
  });
}
