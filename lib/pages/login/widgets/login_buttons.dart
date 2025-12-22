import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

class LoginButtons extends StatelessWidget {
  final double bottom;
  const LoginButtons({super.key, required this.bottom});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final robotWidth = width * 0.30;
    final robotHeight = height * 0.15;
    final robotOffset = height >= 500 && height < 740 ? height * 0.105 : height * 0.10;
    return Positioned(
      bottom: size.height * bottom,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFBA44FF),
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 4,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.05,
                  ),
                ),
                child: Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(
                    fontSize: width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Positioned(
                top: -robotOffset,
                child: Image.asset(
                  'assets/images/Robot_inicio.png',
                  width: robotWidth,
                  height: robotHeight,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),

          SizedBox(width: width * 0.04),

          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.register);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xD9D9D9D9),
              foregroundColor: const Color(0xFFBA44FF),
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.05,
                vertical: height * 0.035,
              ),
            ),
            child: Text(
              'REGISTRARSE',
              style: TextStyle(
                fontSize: width * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
