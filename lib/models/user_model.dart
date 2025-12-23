class UserModel {
  final String id;
  final String username;
  final String fullname;
  final String email;

  UserModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
