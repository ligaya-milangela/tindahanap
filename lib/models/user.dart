class TindahanapUser {
  String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  TindahanapUser({
    this.userId = '',
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}