import 'package:flutter/material.dart';

class ConfigItemLanguage extends StatefulWidget {
  final double scale;

  const ConfigItemLanguage({super.key, required this.scale});

  @override
  State<ConfigItemLanguage> createState() => _ConfigItemLanguageState();
}

class _ConfigItemLanguageState extends State<ConfigItemLanguage> {
  bool isExpanded = false;
  String selected = "Español";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Row(
            children: [
              Icon(Icons.language, color: Colors.lightBlue, size: 28 * widget.scale),
              SizedBox(width: 12 * widget.scale),
              Expanded(
                child: Text(
                  "Idioma",
                  style: TextStyle(fontSize: 15 * widget.scale),
                ),
              ),

              Text(
                selected,
                style: TextStyle(
                  fontSize: 14 * widget.scale,
                  color: Colors.grey.shade600,
                ),
              ),

              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: isExpanded ? 0.5 : 0,
                child: Icon(Icons.keyboard_arrow_down, size: 28 * widget.scale),
              ),
            ],
          ),
        ),

        if (isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 40 * widget.scale, top: 10 * widget.scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _langOption("Español"),
                // _langOption("Inglés"),
                // _langOption("Portugués"),
              ],
            ),
          ),
      ],
    );
  }

  Widget _langOption(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = text;
          isExpanded = false;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6 * widget.scale),
        child: Row(
          children: [
            Icon(
              selected == text ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20 * widget.scale,
              color: Colors.blue,
            ),
            SizedBox(width: 8 * widget.scale),
            Text(text, style: TextStyle(fontSize: 14 * widget.scale)),
          ],
        ),
      ),
    );
  }
}
