class UserModel {
  final String id;
  final String email;
  final String password;
  final String fullName;
  final String role; // 'admin' hoặc 'user'

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.role,
  });
}
