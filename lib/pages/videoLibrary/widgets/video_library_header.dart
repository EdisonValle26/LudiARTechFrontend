import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../../../widgets/back_button.dart';
import '../../../widgets/search_bar.dart';

class VideoLibraryHeader extends StatelessWidget {
  final double scale;
  const VideoLibraryHeader({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            width * 0.03 * scale,
            width * 0.15 * scale,
            width * 0.06 * scale,
            width * 0.01 * scale,
          ),
          color: Colors.white.withOpacity(0.45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "BIBLIOTECA DE VÍDEOS",
                style: TextStyle(
                  fontSize: width * 0.060 * scale,
                  color: const Color(0xFFBA44FF),
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: width * 0.05 * scale),
              SearchBarWidget(
                scale: scale,
                onChanged: (value) {},
              ),
              SizedBox(height: width * 0.05 * scale),
            ],
          ),
        ),

        BackButtonWidget(scale: scale, routeName: AppRoutes.home),
      ],
    );
  }
}
