import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final double scale;
  const ProfileHeader({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        width * 0.1 * scale,
        width * 0.06 * scale,
        width * 0.06 * scale,
        width * 0.01 * scale,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PERFIL",
            style: TextStyle(
              fontSize: width * 0.060 * scale,
              color: const Color(0xFFBA44FF),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
