import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/search_button_configuration.dart';
import 'package:flutter/material.dart';

import 'faq_item.dart';
import 'tutorial_button.dart';

class SupportForm extends StatelessWidget {
  final double scale;
  const SupportForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: 15 * w,
        vertical: 20 * h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20 * h),

          SearchButton(scale: scale),
          SizedBox(height: 30 * h),

          TutorialButton(
            scale: scale,
            routeName: AppRoutes.videoLibrary,
          ),

          SizedBox(height: 30 * h),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Preguntas más comunes",
              style: TextStyle(
                fontSize: 20 * w,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          SizedBox(height: 6 * h),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Toca cualquiera para ver la respuesta",
              style: TextStyle(
                fontSize: 14 * w,
                color: Colors.black38,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: 25 * h),

          FAQItem(
            icon: Icons.lock_outline,
            question: "¿Olvidé mi contraseña?",
            answer:
                "Ve a iniciar sesión y toca ‘Olvidé mi contraseña’. Te enviaremos un enlace a tu correo.",
            scale: scale,
          ),

          SizedBox(height: 15 * h),

          FAQItem(
            icon: Icons.mobile_off_outlined,
            question: "¿Puedo usar la app sin internet?",
            answer:
                "Algunas funciones sí funcionan sin conexión, pero necesitas internet para sincronizar datos.",
            scale: scale,
          ),

          SizedBox(height: 15 * h),

          FAQItem(
            icon: Icons.person,
            question: "¿Cómo cambio mi foto de perfil?",
            answer:
                "Ve a tu perfil, toca la foto actual y selecciona una nueva desde tu galería.",
            scale: scale,
          ),

          SizedBox(height: 40 * h),
        ],
      ),
    );
  }
}
