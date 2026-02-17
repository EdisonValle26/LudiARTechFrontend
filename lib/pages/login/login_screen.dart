import 'package:LudiArtech/widgets/no_back_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import 'widgets/back_button.dart';
import 'widgets/login_buttons.dart';
import 'widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NoBackWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = MediaQuery.of(context).size;

              return Stack(
                alignment: Alignment.center,
                children: [
                  const AppBackground(child: SizedBox()),
                  BackButtonWidget(top: size.height * 0.001),
                  const LoginButtons(bottom: 0.72),
                  const LoginForm(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
