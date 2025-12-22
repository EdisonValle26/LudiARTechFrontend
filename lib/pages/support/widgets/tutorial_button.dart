import 'package:flutter/material.dart';

class TutorialButton extends StatelessWidget {
  final double scale;
  final String routeName;

  const TutorialButton({
    super.key,
    required this.scale,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 45 * scale, vertical: 25 * scale),
        decoration: BoxDecoration(
          color: const Color(0xFFBA44FF),
          borderRadius: BorderRadius.circular(14 * scale),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline_outlined,
              size: 60 * scale,
              color: Colors.white,
            ),
            SizedBox(width: 12 * scale),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ver tutoriales",
                  style: TextStyle(
                    fontSize: 20 * scale,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Videos cortos y fáciles",
                  style: TextStyle(
                    fontSize: 16 * scale,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
