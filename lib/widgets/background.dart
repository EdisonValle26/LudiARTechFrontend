import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFFA7AEF9),
                Color(0xFFCEBBFA),
                Color(0xFFC9E9F9),
                Color(0xFFC2BDF9),
                Color(0xFFCEBBE9),
              ],
            ),
          ),
        ),

        SafeArea(child: child),
      ],
    );
  }
}
