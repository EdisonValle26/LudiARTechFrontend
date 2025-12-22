import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

import 'data_box.dart';
import 'nivel_item.dart';
import 'nivel_model.dart';

class LearningPathsCard extends StatelessWidget {
  final double scale;

  final String tituloGeneral;
  final int porcentaje;
  final int leccionesCompletadas;
  final int leccionesTotales;
  final double calificacion;

  final List<NivelModel> niveles;

  const LearningPathsCard({
    super.key,
    required this.scale,
    required this.tituloGeneral,
    required this.porcentaje,
    required this.leccionesCompletadas,
    required this.leccionesTotales,
    required this.calificacion,
    required this.niveles,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final sectionSpacing = h * 0.02 * scale;

    return Container(
      width: w,
      decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: Colors.white,
      width: 2 * scale,
    ),
  ),
      padding: EdgeInsets.fromLTRB(
        w * 0.08 * scale,
        h * 0.03 * scale,
        w * 0.08 * scale,
        h * 0.02 * scale,
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16 * scale),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    Icons.desktop_mac_outlined,
                    size: 45 * scale,
                    color: Colors.blueAccent,
                  ),
                ),

                SizedBox(height: 12 * scale),

                Text(
                  tituloGeneral,
                  style: TextStyle(
                    fontSize: 22 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: sectionSpacing * 1.2),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DataBox(
                      scale: scale,
                      title: "$porcentaje%",
                      subtitle: "Completado",
                      color: Colors.purple,
                      small: true,
                    ),
                    DataBox(
                      scale: scale,
                      title: "$leccionesCompletadas/$leccionesTotales",
                      subtitle: "Lecciones",
                      color: Colors.green,
                      small: true,
                    ),
                    DataBox(
                      scale: scale,
                      title: "$calificacion",
                      subtitle: "Calificación",
                      color: Colors.amber,
                      icon: Icons.star,
                      small: true,
                    ),
                  ],
                ),

                SizedBox(height: sectionSpacing * 2),

                Column(
                  children: List.generate(
                    niveles.length,
                    (i) => Padding(
                      padding: EdgeInsets.only(bottom: 5 * scale),
                      child: NivelItem(
                        numero: i + 1,
                        model: niveles[i]..isLast = (i == niveles.length - 1),
                        scale: scale * 0.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: sectionSpacing * 2),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16 * scale),
                backgroundColor: Colors.deepPurple.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.bar_chart, color: Colors.white),
              label: Text(
                "Continúa lección actual",
                style: TextStyle(
                  fontSize: 17 * scale,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.home);
              },
            ),
          ),

          SizedBox(height: sectionSpacing * 4),
        ],
      ),
    );
  }
}
