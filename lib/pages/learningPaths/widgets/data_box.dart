import 'package:flutter/material.dart';

class DataBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final double scale;
  final bool small;
  final IconData? icon;

  const DataBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.scale,
    this.small = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon == null
            ? Text(
                title,
                style: TextStyle(
                  fontSize: (small ? 20 : 26) * scale,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              )
            : Row(
                children: [
                  Icon(icon, color: color, size: (small ? 20 : 26) * scale),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: (small ? 18 : 24) * scale,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
        SizedBox(height: 3 * scale),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: (small ? 12 : 14) * scale,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
