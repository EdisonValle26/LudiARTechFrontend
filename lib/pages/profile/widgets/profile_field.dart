import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final String title;
  final String value;
  final double w;
  final double h;

  const ProfileField({
    super.key,
    required this.title,
    required this.value,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14 * h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20 * w,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16 * w,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
