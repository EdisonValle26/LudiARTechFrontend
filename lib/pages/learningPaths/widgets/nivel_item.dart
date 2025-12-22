import 'package:flutter/material.dart';

import 'nivel_model.dart';

class NivelItem extends StatelessWidget {
  final int numero;
  final NivelModel model;
  final double scale;

  const NivelItem({
    super.key,
    required this.numero,
    required this.model,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 48 * scale,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!model.isLast)
                  Positioned.fill(
                    top: 48 * scale,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 3,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),

                Container(
                  width: 48 * scale,
                  height: 48 * scale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: model.completado ? Colors.green : model.numeroColor,
                  ),
                  child: Center(
                    child: model.completado
                        ? Icon(Icons.check, color: Colors.white, size: 26 * scale)
                        : Text(
                            "$numero",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20 * scale,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 18 * scale),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.titulo,
                  style: TextStyle(
                    fontSize: 20 * scale,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4 * scale),
                Text(
                  model.subtitulo,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 6 * scale),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 5 * scale,
                    horizontal: 12 * scale,
                  ),
                  decoration: BoxDecoration(
                    color: model.etiquetaFondo,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    model.etiqueta,
                    style: TextStyle(
                      fontSize: 14 * scale,
                      color: model.etiquetaTexto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
