import 'package:flutter/material.dart';

class HighlightCard extends StatelessWidget {
  final double scale;
  final Color backgroundColor;
  final IconData icon;
  final String title;
  final String description;

  const HighlightCard({
    super.key,
    required this.scale,
    required this.backgroundColor,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20 * scale),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18 * scale),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 34 * scale, color: Colors.white),
              SizedBox(width: 12 * scale),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20 * scale,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12 * scale),
          Text(
            description,
            style: TextStyle(
              fontSize: 16 * scale,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
