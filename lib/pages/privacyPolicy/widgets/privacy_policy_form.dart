import 'package:flutter/material.dart';

import '../../../widgets/highlight_card_configuration.dart';
import '../../../widgets/standar_card_configuration.dart';

class PrivacyPolicyForm extends StatelessWidget {
  final double scale;
  const PrivacyPolicyForm({super.key, required this.scale});

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
            backgroundColor: Colors.deepOrange.shade400,
            icon: Icons.vpn_key_off_sharp,
            title: "Tu privacidad es importante",
            description:
                "Aquí te explicamos qué información recopilamos, cómo la usamos y cómo la protegemos. Todo de forma simple y clara.",
          ),
          SizedBox(height: 15 * h),
                    StandarCard(
            scale: scale,
            icon: Icons.list_alt_sharp,
            color: Colors.orangeAccent,
            title: "Datos que recopilamos",
            sections: [
              StandarSection(
                subtitle: "Datos personales:",
                items: [
                  "Nombre y correo electrónico.",
                  "Foto de perfil (opcional).",
                  "Información de tu escuela o universidad.",
                  "Fecha de nacimiento (para verificar edad).",
                ],
              ),
              StandarSection(
                subtitle: "Datos de uso:",
                items: [
                  "Cómo usas la app.",
                  "Páginas que visitas.",
                  "Tiempo que pasas en la app.",
                ],
              ),
            ],
          ),

          SizedBox(height: 15 * h),
          StandarCard(
            scale: scale,
            icon: Icons.track_changes,
            color: Colors.purpleAccent,
            title: "Cómo usamos tu información",
            sections: [
              StandarSection(items: [
                "Para que puedas usar la app correctamente.",
                "Mejorar tu experiencia de aprendizaje.",
                "Enviarte notificaciones importantes.",
                "Mantener tu cuenta segura.",
                "Arreglar problemas técnicos.",
              ])
            ],
          ),
          SizedBox(height: 15 * h),
          StandarCard(
            scale: scale,
            icon: Icons.security,
            color: Colors.blue,
            title: "Cómo protegemos tus datos",
            sections: [
              StandarSection(items: [
                "Usamos encriptación de alto nivel.",
                "Servidores seguros protegidos 24/7.",
                "Solo personal autorizado puede acceder.",
                "Hacemos copias de seguridad regularmente.",
              ])
            ],
          ),
          SizedBox(height: 15 * h),
        ],
      ),
    );
  }
}
