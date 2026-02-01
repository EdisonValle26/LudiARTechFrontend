import 'package:flutter/material.dart';

import '../../../widgets/firebase_video_player.dart';
import 'video_card_item.dart';
class VideoLibraryForm extends StatelessWidget {
  final double scale;
  const VideoLibraryForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    final sectionSpacing = h * 0.025 * scale;

    return Container(
      width: w,
      padding: EdgeInsets.fromLTRB(
        w * 0.09 * scale,
        h * 0.02 * scale,
        w * 0.09 * scale,
        h * 0.02 * scale,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Videos por ver",
                style: TextStyle(
                  fontSize: w * 0.060 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              Text(
                "Ver todos",
                style: TextStyle(
                  fontSize: w * 0.040 * scale,
                  fontWeight: FontWeight.w800,
                  color: Colors.purpleAccent,
                ),
              ),
            ],
          ),
          SizedBox(height: sectionSpacing),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  VideoCardItem(
                    scale: scale,
                    title: "Procesador Microsoft Word",
                    video: const FirebaseVideoPlayer(
                      path: "Procesador_MW.mp4",
                      placeholderColor: Colors.lightBlueAccent,
                    ),
                  ),
                  VideoCardItem(
                    scale: scale,
                    title: "Proceso de inserción de imagenes en Microsoft Word",
                    video: const FirebaseVideoPlayer(
                      path: "Insercion_imagenes_MW.mp4",
                      placeholderColor: Colors.deepOrangeAccent,
                    ),
                  ),
                  VideoCardItem(
                    scale: scale,
                    title: "Tablas Dinámicas",
                    video: const FirebaseVideoPlayer(
                      path: "Tablas_dinamicas.mp4",
                      placeholderColor: Colors.lightGreen,
                    ),
                  ),
                  VideoCardItem(
                    scale: scale,
                    title: "Tipos de Datos",
                    video: const FirebaseVideoPlayer(
                      path: "Tipos_datos.mp4",
                      placeholderColor: Colors.redAccent,
                    ),
                  ),
                  VideoCardItem(
                    scale: scale,
                    title: "Elementos de una diapositiva",
                    video: const FirebaseVideoPlayer(
                      path: "Elementos_diapositiva.mp4",
                      placeholderColor: Colors.yellowAccent,
                    ),
                  ),
                  VideoCardItem(
                    scale: scale,
                    title: "Interfaz Power Point",
                    video: const FirebaseVideoPlayer(
                      path: "Interfaz_PP.mp4",
                      placeholderColor: Colors.purpleAccent,
                    ),
                  ),
                  SizedBox(height: sectionSpacing),
                ],
              ),
            ),
          ),
          SizedBox(height: sectionSpacing),
        ],
      ),
    );
  }
}
