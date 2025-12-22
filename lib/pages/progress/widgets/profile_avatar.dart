import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final String name;
  final String lastName;

  const ProfileAvatar({
    super.key,
    required this.radius,
    this.name = "Maria",
    this.lastName = "Gomez",
  });

  String getInitials() {
    String firstInitial = name.isNotEmpty ? name[0].toUpperCase() : "";
    String lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : "";
    return "$firstInitial$lastInitial";
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.amberAccent,
            child: Text(
              getInitials(),
              style: TextStyle(
                fontSize: radius * 0.6,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
