import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import 'widgets/back_button.dart';
import 'widgets/onboarding_form.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                const OnboardingForm(),
              ],
            );
          },
        ),
      ),
    );
  }
}
