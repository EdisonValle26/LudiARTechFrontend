import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final double scale;
  final Function(String)? onChanged;

  const SearchBarWidget({
    super.key,
    required this.scale,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04 * scale,
        vertical: width * 0.001 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50 * scale),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: width * 0.055 * scale, color: Colors.grey),
          SizedBox(width: width * 0.03 * scale),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(fontSize: width * 0.045 * scale),
              decoration: const InputDecoration(
                hintText: "Buscar...",
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
