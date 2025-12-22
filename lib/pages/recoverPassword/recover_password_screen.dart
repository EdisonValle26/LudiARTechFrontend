import 'package:LudiArtech/pages/recoverPassword/widgets/recover_password_form.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/back_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

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
                Expanded(child: RecoverPasswordForm(scale: scale)),
              ],
            ),
            BackButtonWidget(scale: scale, routeName: AppRoutes.forgetPassword),
          ],
        ),
      ),
    );
  }
}
