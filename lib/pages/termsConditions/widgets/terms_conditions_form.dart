import 'package:flutter/material.dart';

import '../../../widgets/highlight_card_configuration.dart';
import '../../../widgets/standar_card_configuration.dart';

class TermsConditionsForm extends StatelessWidget {
  final double scale;
  const TermsConditionsForm({super.key, required this.scale});

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
          HighlightCard(
            scale: scale,
            backgroundColor: Colors.blue.shade400,
            icon: Icons.edit_document,
            title: "En pocas palabras",
            description:
                "Estos términos explican cómo usar nuestra app de forma segura y responsable. Es importante que los leas para que sepas tus derechos y responsabilidades.",
          ),
          SizedBox(height: 15 * h),
          StandarCard(
            scale: scale,
            icon: Icons.person,
            color: Colors.redAccent,
            title: "1. Tu cuenta",
            sections: [
              StandarSection(items: [
                "Debes tener al menos 13 años para usar la app.",
                "Tu cuenta es personal e intransferible.",
                "Mantén tu contraseña segura y no la compartas.",
                "Eres responsable de tu cuenta.",
              ])
            ],
          ),
          SizedBox(height: 15 * h),
          StandarCard(
            scale: scale,
            icon: Icons.check_box,
            color: Colors.green,
            title: "2. Uso Correcto",
            sections: [
              StandarSection(items: [
                "Usa la app solo para estudiar y aprender.",
                "Sé respetuoso con otros usuarios.",
                "No compartas contenido inapropiado.",
                "No intentes hackear o dañar la app.",
              ])
            ],
          ),
          SizedBox(height: 15 * h),
          StandarCard(
            scale: scale,
            icon: Icons.lock,
            color: Colors.amberAccent,
            title: "3. Privacidad",
            sections: [
              StandarSection(items: [
                "Protegemos tu información personal.",
                "No vendemos tus datos a terceros.",
                "Lee nuestra Política de Privacidad para más detalles.",
              ])
            ],
          ),
          SizedBox(height: 15 * h),
          StandarCard(
            scale: scale,
            icon: Icons.warning_amber_rounded,
            color: Colors.yellow.shade900,
            title: "4. Cambios en los términos",
            sections: [
              StandarSection(items: [
                "Podemos actualizar estos términos ocasionalmente.",
                "Te avisaremos si hay cambios importantes.",
                "Mantén tu contraseña segura y no la compartas.",
                "Seguir usando la app significa que aceptas los nuevos términos.",
              ])
            ],
          ),
          SizedBox(height: 15 * h),
        ],
      ),
    );
  }
}
