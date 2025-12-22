import 'package:flutter/material.dart';

class VideoCardItem extends StatelessWidget {
  final double scale;
  final String title;
  final Widget video;

  const VideoCardItem({
    super.key,
    required this.scale,
    required this.title,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: width * 0.06 * scale),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20 * scale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            height: width * 0.40 * scale,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20 * scale),
              ),
              color: Colors.white,
            ),
            clipBehavior: Clip.hardEdge,
            child: video,
          ),

          Padding(
            padding: EdgeInsets.all(width * 0.04 * scale),
            child: Text(
              title,
              style: TextStyle(
                fontSize: width * 0.045 * scale,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
