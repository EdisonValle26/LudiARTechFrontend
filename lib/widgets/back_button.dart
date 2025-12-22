import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final double scale;
  final String routeName;

  const BackButtonWidget({
    super.key,
    required this.scale,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15 * scale,
      left: 15 * scale,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 12 * scale,
            vertical: 8 * scale,
          ),
          child: Row(
            children: [
              Icon(
                Icons.arrow_back,
                size: 16 * scale,
                color: Colors.black87,
              ),
              SizedBox(width: 6 * scale),
              Text(
                "Atrás",
                style: TextStyle(
                  fontSize: 14 * scale,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
