import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../../../widgets/back_button.dart';

class RankingHeader extends StatelessWidget {
  final double scale;
  const RankingHeader({super.key, required this.scale});

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
            width * 0.04 * scale,
          ),

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x9F9F5EF0),
                Color(0xD5D512C8),
              ],
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                color: Colors.white,
                size: 46,
              ),
              SizedBox(width: width * 0.02),
              Text(
                "RANKING",
                style: TextStyle(
                  fontSize: width * 0.080 * scale,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: width * 0.05 * scale),

        BackButtonWidget(scale: scale, routeName: AppRoutes.home),
      ],
    );
  }
}
