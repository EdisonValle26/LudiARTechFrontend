import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:flutter/material.dart';

class ImageContent extends StatelessWidget {
  final String imagePath;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final double progress;
  final Color progressColor;
  final double scale;

  const ImageContent({
    super.key,
    required this.imagePath,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressColor,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(w * 0.018 * scale),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.circular(14 * scale),
          ),
          child: FirebaseImage(
            path: imagePath,
            width: w * 0.12 * scale,
          ),
        ),
        SizedBox(width: w * 0.035 * scale),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: w * 0.038 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: h * 0.006 * scale),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      color: progressColor,
                      backgroundColor: progressColor.withOpacity(0.2),
                      minHeight: h * 0.010 * scale,
                      borderRadius: BorderRadius.circular(4 * scale),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      fontSize: w * 0.030 * scale,
                      fontWeight: FontWeight.bold,
                      color: progressColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.006 * scale),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: w * 0.032 * scale,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
