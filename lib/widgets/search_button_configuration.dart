import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final double scale;

  const SearchButton({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 90 * scale, vertical: 12 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12 * scale),
        border: Border.all(color: Colors.white, width: 1.4),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.help_outline, size: 24 * scale, color: Colors.black45),
          SizedBox(width: 10 * scale),
          Text(
            "¿Qué necesitas?",
            style: TextStyle(
              fontSize: 16 * scale,
              fontWeight: FontWeight.w600,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
