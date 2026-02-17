import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/configuration_custom_header.dart';
import 'package:LudiArtech/widgets/no_back_button.dart';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import 'widgets/personal_info_form.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

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
                  ConfigurationCustomHeader(
                    scale: scale,
                    title: "Información Personal",
                    routeName: AppRoutes.configuration,
                  ),
                  Expanded(child: PersonalInfoForm(scale: scale)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
