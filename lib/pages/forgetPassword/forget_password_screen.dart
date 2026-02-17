import 'package:LudiArtech/pages/forgetPassword/widgets/forget_password_form.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/no_back_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/back_button.dart';
import '../../widgets/background.dart';

class ForgetPasswordFormScreen extends StatelessWidget {
  const ForgetPasswordFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final scale = height < 800 ? height / 800 : 1.0;

    return NoBackWrapper(
  child: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const AppBackground(child: SizedBox()),
            Column(
              children: [
                Expanded(child: ForgetPasswordForm(scale: scale)),
              ],
            ),
            BackButtonWidget(scale: scale, routeName: AppRoutes.login),
          ],
        ),
      ),
    ),
    );
  }
}
