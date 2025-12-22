import 'package:flutter/material.dart';

class ProfileEditButton extends StatelessWidget {
  final double w;
  final double h;
  final VoidCallback onPressed;

  const ProfileEditButton({
    super.key,
    required this.w,
    required this.h,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0x636369DB),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15 * h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * w),
          ),
        ),
        child: Text(
          "Editar Perfil",
          style: TextStyle(
            fontSize: 17 * w,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
