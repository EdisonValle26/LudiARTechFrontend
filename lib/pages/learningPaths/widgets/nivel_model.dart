import 'package:flutter/material.dart';

class NivelModel {
  final bool completado;
  final String titulo;
  final String subtitulo;
  final String etiqueta;
  final Color etiquetaFondo;
  final Color etiquetaTexto;
  final Color numeroColor;
  bool isLast;

  NivelModel({
    required this.completado,
    required this.titulo,
    required this.subtitulo,
    required this.etiqueta,
    required this.etiquetaFondo,
    required this.etiquetaTexto,
    required this.numeroColor,
    required this.isLast,
  });
}
