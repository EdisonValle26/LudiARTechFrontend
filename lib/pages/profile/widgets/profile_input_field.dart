import 'package:flutter/material.dart';

class ProfileInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double w;
  final double h;

  const ProfileInputField(
    this.label,
    this.controller,
    this.w,
    this.h, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16 * h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18 * w,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextField(
            controller: controller,
            style: TextStyle(fontSize: 16 * w),
            decoration: const InputDecoration(
              isDense: true,
              border: UnderlineInputBorder(),
            ),
          )
        ],
      ),
    );
  }
}
