import 'package:flutter/material.dart';

import '../../../widgets/back_button.dart';

class ConfigurationCustomHeader extends StatelessWidget {
  final double scale;
  final String title;
  final String routeName;

  const ConfigurationCustomHeader({
    super.key,
    required this.scale,
    required this.title,
    required this.routeName,
  });

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
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: width * 0.060 * scale,
                  color: const Color(0xFFBA44FF),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        BackButtonWidget(
          scale: scale,
          routeName: routeName,
        ),
      ],
    );
  }
}
