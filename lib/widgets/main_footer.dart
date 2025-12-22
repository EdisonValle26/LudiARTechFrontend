import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

class MainFooter extends StatelessWidget {
  const MainFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: width * 0.23,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              painter: FooterCurvePainter(),
              child: SizedBox(
                height: width * 0.23,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _footerBtn(
                              icon: Icons.bar_chart,
                              context: context,
                              route: AppRoutes.progress,
                              label: "Progreso",
                            ),
                            SizedBox(width: width * 0.05),
                            _footerBtn(
                              icon: Icons.emoji_events,
                              context: context,
                              route: AppRoutes.ranking,
                              label: "Ranking",
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            _footerBtn(
                              icon: Icons.person,
                              context: context,
                              route: AppRoutes.profile,
                              label: "Perfil",
                            ),
                            SizedBox(width: width * 0.05),
                            _footerBtn(
                              icon: Icons.settings,
                              context: context,
                              route: AppRoutes.configuration,
                              label: "Ajustes",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: -width * 0.06,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                  child: Container(
                    width: width * 0.15,
                    height: width * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent.withOpacity(0.7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerBtn({
    required IconData icon,
    required BuildContext context,
    required String route,
    required String label,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 45,
            child: Icon(
              icon,
              color: Colors.black,
              size: 26,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class FooterCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x9A9A92FF).withOpacity(0.95)
      ..style = PaintingStyle.fill;

    final path = Path();

    double buttonRadius = size.width * 0.1 / 2;

    double curveWidth = buttonRadius * 2.5;
    double curveDepth = buttonRadius * 3;

    double sideLift = buttonRadius * 1.0;

    path.moveTo(0, sideLift);

    path.cubicTo(
      size.width * 0.10, 0,
      size.width * 0.25, 0,
      (size.width / 2) - curveWidth, 0,
    );

    path.cubicTo(
      (size.width / 2) - curveWidth / 2, curveDepth,
      (size.width / 2) + curveWidth / 2, curveDepth,
      (size.width / 2) + curveWidth, 0,
    );

    path.cubicTo(
      size.width * 0.75, 0,
      size.width * 0.90, 0,
      size.width, sideLift,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.black.withOpacity(0.18), 12, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
