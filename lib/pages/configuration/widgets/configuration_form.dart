import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:flutter/material.dart';

import 'config_card.dart';
import 'config_item.dart';
import 'config_item_language.dart';

class ConfigurationForm extends StatelessWidget {
  final double scale;
  const ConfigurationForm({super.key, required this.scale});

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
        children: [
          ConfigCard(
            title: "Cuenta",
            items: [
              ConfigItem(
                label: "Información Personal",
                icon: Icons.person,
                iconColor: Colors.blueAccent,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.personalInfo);
                },
              ),
              ConfigItem(
                label: "Privacidad y Seguridad",
                icon: Icons.lock,
                iconColor: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.privacySecurity);
                },
              ),
            ],
            w: w,
            h: h,
          ),
          SizedBox(height: 12 * h),
          ConfigCard(
            title: "Aplicación",
            items: [
              const ConfigItem(
                label: "Notificaciones",
                icon: Icons.notifications,
                iconColor: Colors.purple,
                isToggle: true,
                initialValue: true,
              ),
              const ConfigItem(
                label: "Modo Oscuro",
                icon: Icons.dark_mode,
                iconColor: Colors.yellow,
                isToggle: true,
                initialValue: false,
              ),
              ConfigItemLanguage(scale: w)
            ],
            w: w,
            h: h,
          ),
          SizedBox(height: 12 * h),
          ConfigCard(
            title: "Ayuda y Soporte",
            items: [
              ConfigItem(
                label: "Centro de Ayuda",
                icon: Icons.help,
                iconColor: Colors.teal,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.support);
                },
              ),
              ConfigItem(
                label: "Términos y condiciones",
                icon: Icons.article,
                iconColor: Colors.brown,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.termsConditions);
                },
              ),
              ConfigItem(
                label: "Política de Privacidad",
                icon: Icons.privacy_tip,
                iconColor: Colors.orange,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.privacyPolicy);
                },
              ),
            ],
            w: w,
            h: h,
          ),
          SizedBox(height: 20 * h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await TokenStorage.deleteToken();
                Navigator.pushNamed(context, AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14 * h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18 * w),
                ),
              ),
              child: Text(
                "Cerrar Sesión",
                style: TextStyle(
                  fontSize: 16 * w,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
