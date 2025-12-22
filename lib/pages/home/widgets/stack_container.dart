import 'package:flutter/material.dart';

class StackContainer extends StatelessWidget {
  final Color color;
  final Widget content;
  final double scale;

  const StackContainer({
    super.key,
    required this.color,
    required this.content,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final double boxWidth = (w * 0.80) * scale;
    final double boxHeight = (h * 0.13) * scale;
    final double backgroundOffset = 26 * scale;

    return SizedBox(
      width: boxWidth,
      height: boxHeight + backgroundOffset,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: backgroundOffset,
            right: 0,
            child: Container(
              width: boxWidth,
              height: boxHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20 * scale),
              ),
            ),
          ),

          Container(
            width: boxWidth,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04 * scale,
              vertical: h * 0.015 * scale,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20 * scale),
            ),
            child: content,
          ),
        ],
      ),
    );
  }
}
