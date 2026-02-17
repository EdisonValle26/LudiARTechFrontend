import 'package:LudiArtech/widgets/custom_footer.dart';
import 'package:LudiArtech/widgets/no_back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/background.dart';
import '../providers/routes_provider.dart';
import 'widgets/learning_paths_form.dart';
import 'widgets/learning_paths_header.dart';

class LearnignPathsScreen extends StatelessWidget {
  const LearnignPathsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final scale = height < 800 ? height / 800 : 1.0;

    return ChangeNotifierProvider(
      create: (_) => RoutesProvider(),
      child: NoBackWrapper(
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                const AppBackground(child: SizedBox()),
                Column(
                  children: [
                    LearningPathsHeader(scale: scale),
                    Expanded(child: LearnignPathsForm(scale: scale)),
                  ],
                ),
                const CustomerFooter()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
