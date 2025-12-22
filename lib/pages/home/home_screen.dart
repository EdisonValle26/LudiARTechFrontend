import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import '../../widgets/main_footer.dart';
import 'widgets/home_form.dart';
import 'widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                HomeHeader(scale: scale),
                Expanded(child: HomeForm(scale: scale)),
              ],
            ),

            const MainFooter(),
          ],
        ),
      ),
    );
  }
}
