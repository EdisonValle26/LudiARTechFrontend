import 'package:LudiArtech/pages/activityCenter/widgets/activity_card.dart';
import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

class PowerPointForm extends StatelessWidget {
  final double scale;
  const PowerPointForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final sectionSpacing = h * 0.05 * scale;

    return Container(
      width: w,
      padding: EdgeInsets.fromLTRB(
        w * 0.09 * scale,
        h * 0,
        w * 0.09 * scale,
        h * 0.02 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            "🏆 Desafío del PP día",
            style: TextStyle(
              fontSize: w * 0.060 * scale,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ActivityCardWidget(
                    scale: scale,
                    leftSquareColor: Colors.greenAccent.shade100,
                    title: "Experto en PowerPoint",
                    subtitle: "Resuelve la actividad en menos de 5 minutos",
                    leftValue: "85%",
                    leftCaption: "Completado",
                    rightValue: "8/10",
                    rightCaption: "Actividades",
                    leftButtonIcon: Icons.assignment,
                    leftButtonText: "Continuar",
                    onLeftTap: () {
                      Navigator.pushNamed(context, AppRoutes.powerPointExpert);
                    },
                    
                    rightButtonIcon: Icons.restart_alt,
                    rightButtonText: "Reiniciar",
                    onRightTap: () {},
                  ),
                  ActivityCardWidget(
                    scale: scale,
                    leftSquareColor: Colors.purpleAccent.shade100,
                    title: "Elementos de diapositivas",
                    subtitle: "Empareja las cartas usando 4 aciertos",
                    leftValue: "100%",
                    leftCaption: "Completado",
                    rightValue: "3:45",
                    rightCaption: "Mejor Tiempo",
                    leftButtonIcon: Icons.assessment,
                    leftButtonText: "Ver resultados",
                    onLeftTap: () {},
                    rightButtonIcon: Icons.restore,
                    rightButtonText: "Repetir",
                    onRightTap: () {},
                  ),
                  SizedBox(height: sectionSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
