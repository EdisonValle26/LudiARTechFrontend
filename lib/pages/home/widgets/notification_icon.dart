import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final double size;
  final double padding;
  final int count;

  const NotificationIcon({
    super.key,
    required this.size,
    required this.padding,
    this.count = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.60),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.notifications,
            size: size * 1.5,
            color: const Color(0xFFBA44FF).withOpacity(0.65),
          ),
        ),

        if (count > 0)
          Positioned(
            top: 8,
            right: 5,
            child: Container(
              width: size * 0.95,
              height: size * 0.95,
              decoration: BoxDecoration(
                color: const Color(0xFFE7B7FF),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                count > 99 ? "99+" : count.toString(),
                style: TextStyle(
                  color:  Colors.white,
                  fontSize: size * 0.40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
