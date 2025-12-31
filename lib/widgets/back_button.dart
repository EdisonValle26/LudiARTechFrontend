import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final double scale;
  final VoidCallback? onTap;
  final String? routeName;

  const BackButtonWidget({
    super.key,
    required this.scale,
    this.routeName,
    this.onTap,
  });

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }

    if (routeName != null) {
      Navigator.pushNamed(context, routeName!);
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15 * scale,
      left: 15 * scale,
      child: GestureDetector(
        onTap: () => _handleTap(context),
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
