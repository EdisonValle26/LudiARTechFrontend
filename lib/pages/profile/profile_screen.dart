import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../widgets/main_footer.dart';
import 'widgets/profile_form.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final scale = height < 800 ? height / 800 : 1.0;

    const double footerHeight = 75;

    return Scaffold(
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
                  ProfileHeader(scale: scale),
                  Expanded(child: ProfileForm(scale: scale)),
                ],
              ),
            ),
            MainFooter(),
          ],
        ),
      ),
    );
  }
}
