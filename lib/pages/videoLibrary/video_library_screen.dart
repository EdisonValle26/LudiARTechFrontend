import 'package:LudiArtech/widgets/custom_footer.dart';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import 'widgets/video_library_form.dart';
import 'widgets/video_library_header.dart';

class VideoLibraryScreen extends StatelessWidget {
  const VideoLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final scale = height < 800 ? height / 800 : 1.0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AppBackground(child: SizedBox()),

            Column(
              children: [
                VideoLibraryHeader(scale: scale),
                Expanded(child: VideoLibraryForm(scale: scale)),
              ],
            ),

            const CustomerFooter()
          ],
        ),
      ),
    );
  }
}
