import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final double top;
  const BackButtonWidget({super.key, required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 15,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context, AppRoutes.login);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        icon: const Icon(Icons.arrow_back, size: 18),
        label: const Text(
          'Atrás',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
