import 'package:LudiArtech/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/back_button.dart';

class SlidingPuzzleHeader extends StatelessWidget {
  final double scale;
  const SlidingPuzzleHeader({super.key, required this.scale});

  void _showInfoModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Cómo jugar?"),
        content: const Text(
          "Debes ordenar correctamente los pasos para insertar una imagen en Word. "
          "Toca las fichas que estén junto al espacio vacío hasta completar el orden.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            width * 0.04 * scale,
            width * 0.15 * scale,
            width * 0.04 * scale,
            width * 0.03 * scale,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03 * scale,
              vertical: width * 0.035 * scale,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(18 * scale),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.015 * scale),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.extension_rounded,
                    color: Colors.blue,
                    size: width * 0.075 * scale,
                  ),
                ),

                SizedBox(width: width * 0.02 * scale),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rompecabezas",
                        style: TextStyle(
                          fontSize: width * 0.045 * scale,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: width * 0.01 * scale),
                      Text(
                        "Ordena los pasos para insertar imagen en Word",
                        style: TextStyle(
                          fontSize: width * 0.028 * scale,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: width * 0.01 * scale),

                GestureDetector(
                  onTap: () => _showInfoModal(context),
                  child: Container(
                    padding: EdgeInsets.all(width * 0.015 * scale),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: width * 0.05 * scale,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        BackButtonWidget(
          scale: scale,
          routeName: AppRoutes.activityCenter,
        ),
      ],
    );
  }
}
