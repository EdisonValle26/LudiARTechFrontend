import 'package:LudiArtech/widgets/background.dart';
import 'package:flutter/material.dart';

import 'widgets/sliding_puzzle_form.dart';
import 'widgets/sliding_puzzle_header.dart';

class SlidingPuzzleScreen extends StatelessWidget {
  const SlidingPuzzleScreen({super.key});

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
                SlidingPuzzleHeader(scale: scale),
                Expanded(child: SlidingPuzzleForm(scale: scale)),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
