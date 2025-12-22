import 'package:flutter/material.dart';

class StandarCard extends StatelessWidget {
  final double scale;
  final IconData icon;
  final String title;
  final Color color;
  final List<StandarSection> sections;

  const StandarCard({
    super.key,
    required this.scale,
    required this.icon,
    required this.color,
    required this.title,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16 * scale),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 28 * scale, color: color),
              SizedBox(width: 10 * scale),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14 * scale),

          ...sections.map((section) {
            return Padding(
              padding: EdgeInsets.only(left: 38 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (section.subtitle != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 4 * scale),
                      child: Text(
                        section.subtitle!,
                        style: TextStyle(
                          fontSize: 15 * scale,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                  ...section.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 3 * scale),
                      child: Text(
                        "• $item",
                        style: TextStyle(
                          fontSize: 14 * scale,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10 * scale),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class StandarSection {
  final String? subtitle;
  final List<String> items;

  StandarSection({this.subtitle, required this.items});
}
