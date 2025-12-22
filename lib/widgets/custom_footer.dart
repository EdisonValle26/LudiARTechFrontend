import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

class CustomerFooter extends StatelessWidget {
  const CustomerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final scale = (width / 400).clamp(0.60, 1.0);

    return Positioned(
      bottom: 20 * scale,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _footerBtn(
            icon: Icons.video_collection,
            label: "Videos",
            color: Colors.blueAccent,
            route: AppRoutes.videoLibrary,
            context: context,
            scale: scale,
          ),
          _footerBtn(
            icon: Icons.assignment,
            label: "Actividades",
            color: Colors.orangeAccent,
            route: AppRoutes.activityCenter,
            context: context,
            scale: scale,
          ),
          _footerBtn(
            icon: Icons.play_lesson,
            label: "Lecciones",
            color: Colors.greenAccent,
            route: AppRoutes.learningPaths,
            context: context,
            scale: scale,
          ),
        ],
      ),
    );
  }

  Widget _footerBtn({
    required IconData icon,
    required String label,
    required String route,
    required Color color,
    required BuildContext context,
    required double scale,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(40 * scale),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18 * scale,
          vertical: 12 * scale,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40 * scale),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6 * scale,
              offset: Offset(0, 3 * scale),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22 * scale,
              color: color,
            ),
            SizedBox(width: 8 * scale),
            Text(
              label,
              style: TextStyle(
                fontSize: 14 * scale,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
