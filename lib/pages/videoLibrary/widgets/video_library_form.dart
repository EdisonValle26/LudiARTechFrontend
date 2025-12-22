import 'package:flutter/material.dart';

import 'video_card_item.dart';

class VideoLibraryForm extends StatelessWidget {
  final double scale;
  const VideoLibraryForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final sectionSpacing = h * 0.025 * scale;

    return Container(
      width: w,
      padding: EdgeInsets.fromLTRB(
        w * 0.09 * scale,
        h * 0.02 * scale,
        w * 0.09 * scale,
        h * 0.02 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Videos por ver",
                style: TextStyle(
                  fontSize: w * 0.060 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Text(
                "Ver todos",
                style: TextStyle(
                  fontSize: w * 0.040 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.purpleAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  VideoCardItem(
                    scale: scale,
                    title: "Tema 1 – Word",
                    video: Container(
                      color: Colors.lightBlue.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle,
                          color: Colors.blue,
                          size: 55,
                        ),
                      ),
                    ),
                  ),
                  VideoCardItem(
                    scale: scale,
                    title: "Tema 2 – Excel",
                    video: Container(
                      color: Colors.deepOrange.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle,
                          color: Colors.blue,
                          size: 55,
                        ),
                      ),
                    ),
                  ),
                  VideoCardItem(
                    scale: scale,
                    title: "Tema 3 – Power Point",
                    video: Container(
                      color: Colors.lightGreen.shade100,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle,
                          color: Colors.blue,
                          size: 55,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                ],
              ),
            ),
          ),
          SizedBox(height: sectionSpacing),
        ],
      ),
    );
  }
}
