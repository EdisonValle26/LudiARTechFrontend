import 'package:LudiArtech/pages/privacySecutity/widgets/privacy_security_form.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/configuration_custom_header.dart';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final scale = height < 800 ? height / 800 : 1.0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AppBackground(child: SizedBox()),
            Column(
              children: [
                ConfigurationCustomHeader(
                  scale: scale,
                  title: "Privacidad y Seguridad",
                  routeName: AppRoutes.configuration,
                ),
                Expanded(child: PrivacySecurityForm(scale: scale)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
