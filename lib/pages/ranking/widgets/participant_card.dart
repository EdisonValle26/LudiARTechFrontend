import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:flutter/material.dart';

class ParticipantCard extends StatelessWidget {
  final double scale;
  final String name;
  final int number;
  final Color color;
  final Color colorNumber;
  final IconData icon2;
  final int points;
  final bool crown;
  final double sizeFactor;

  const ParticipantCard({
    super.key,
    required this.scale,
    required this.name,
    required this.number,
    required this.color,
    required this.colorNumber,
    required this.icon2,
    required this.points,
    required this.crown,
    required this.sizeFactor,
  });

  String _getInitials(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "";

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final initials = _getInitials(name);

    return Column(
      children: [
        if (crown)
          FirebaseImage(
            path: "crown.png",
            width: w * 0.11 * scale * sizeFactor,
            height: w * 0.11 * scale * sizeFactor,
          ),

        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: w * 0.16 * scale * sizeFactor,
              height: w * 0.16 * scale * sizeFactor,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),

              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.06 * scale * sizeFactor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            Positioned(
              top: -(w * 0.02 * scale * sizeFactor),
              right: -(w * 0.02 * scale * sizeFactor),
              child: CircleAvatar(
                backgroundColor: colorNumber,
                radius: w * 0.03 * scale * sizeFactor,
                child: Text(
                  "$number",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w * 0.03 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: w * 0.02),

        Container(
          width: w * 0.20 * scale * sizeFactor,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(14),
            ),
          ),
          child: Column(
            children: [
              Icon(icon2, size: w * 0.07 * scale),
              Text(
                "$points",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.04 * scale,
                ),
              ),
              const Text("pts"),
            ],
          ),
        ),

        SizedBox(height: w * 0.02),

        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: w * 0.035 * scale,
          ),
        ),
      ],
    );
  }
}
