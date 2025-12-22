import 'package:flutter/material.dart';

class ParticipantRow extends StatelessWidget {
  final double scale;
  final int number;
  final String name;
  final int points;
  final bool showDivider;

  const ParticipantRow({
    super.key,
    required this.scale,
    required this.number,
    required this.name,
    required this.points,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: h * 0.012 * scale,
            horizontal: w * 0.04 * scale,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: w * 0.035 * scale,
                backgroundColor: Colors.purple.shade100,
                child: Text(
                  "$number",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: w * 0.035 * scale,
                  ),
                ),
              ),
              SizedBox(width: w * 0.04 * scale),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: w * 0.040 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                "$points pts",
                style: TextStyle(
                  fontSize: w * 0.040 * scale,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.shade300,
          ),
      ],
    );
  }
}
