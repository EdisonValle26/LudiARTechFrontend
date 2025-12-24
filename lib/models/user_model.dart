class UserModel {
  final String id;
  final String username;
  final String fullname;
  final String email;
  final String firstName;
  final String lastName;
  final int age;
  final String gender;
  final String course;
  final String location;
  final String createdAt;
  final String phone;

  UserModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    required this.course,
    required this.location,
    required this.phone,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      course: json['course'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
