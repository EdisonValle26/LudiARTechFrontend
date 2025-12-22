import 'package:LudiArtech/widgets/main_footer.dart';
import 'package:flutter/material.dart';

import '../../widgets/background.dart';
import 'widgets/ranking_form.dart';
import 'widgets/ranking_header.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

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
                RankingHeader(scale: scale),
                Expanded(child: RankingForm(scale: scale)),
              ],
            ),

            const MainFooter()
          ],
        ),
      ),
    );
  }
}
