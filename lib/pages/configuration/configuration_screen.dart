import 'package:LudiArtech/widgets/no_back_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../widgets/main_footer.dart';
import 'widgets/configuration_form.dart';
import 'widgets/configuration_header.dart';

class ConfigurationScreen extends StatelessWidget {
  const ConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final scale = height < 800 ? height / 800 : 1.0;

    const double footerHeight = 75;

    return NoBackWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              const AppBackground(child: SizedBox()),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: footerHeight * 1.5,
                ),
                child: Column(
                  children: [
                    ConfigurationHeader(scale: scale),
                    Expanded(child: ConfigurationForm(scale: scale)),
                  ],
                ),
              ),
              MainFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
