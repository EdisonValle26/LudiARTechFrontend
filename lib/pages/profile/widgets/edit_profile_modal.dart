import 'package:flutter/material.dart';

import '../widgets/profile_input_field.dart';

class EditProfileModal {
  static void show(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final w = width / 390;
    final h = height / 844;

    final nameCtrl = TextEditingController(text: "María Alexandra");
    final lastnameCtrl = TextEditingController(text: "Gómez Suárez");
    final edadCtrl = TextEditingController(text: "17");
    final sexoCtrl = TextEditingController(text: "Femenino");
    final cursoCtrl = TextEditingController(text: "3ro Informática A");
    final correoCtrl = TextEditingController(text: "maria.gomez@gmail.com");
    final ubicacionCtrl = TextEditingController(text: "Guayaquil, Ecuador");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: 10 * w,
          vertical: 40 * h,
        ),
        child: _ModalBody(
          w: w,
          h: h,
          nameCtrl: nameCtrl,
          lastnameCtrl: lastnameCtrl,
          edadCtrl: edadCtrl,
          sexoCtrl: sexoCtrl,
          cursoCtrl: cursoCtrl,
          correoCtrl: correoCtrl,
          ubicacionCtrl: ubicacionCtrl,
        ),
      ),
    );
  }
}

class _ModalBody extends StatelessWidget {
  final double w;
  final double h;

  final TextEditingController nameCtrl;
  final TextEditingController lastnameCtrl;
  final TextEditingController edadCtrl;
  final TextEditingController sexoCtrl;
  final TextEditingController cursoCtrl;
  final TextEditingController correoCtrl;
  final TextEditingController ubicacionCtrl;

  const _ModalBody({
    super.key,
    required this.w,
    required this.h,
    required this.nameCtrl,
    required this.lastnameCtrl,
    required this.edadCtrl,
    required this.sexoCtrl,
    required this.cursoCtrl,
    required this.correoCtrl,
    required this.ubicacionCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24 * w,
        vertical: 20 * h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30 * w),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14 * w,
            offset: Offset(0, 5 * h),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Editar Perfil",
                style: TextStyle(
                  fontSize: 22 * w,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 15 * h),

            ProfileInputField("Nombres", nameCtrl, w, h),
            ProfileInputField("Apellido", lastnameCtrl, w, h),
            ProfileInputField("Edad", edadCtrl, w, h),
            ProfileInputField("Sexo", sexoCtrl, w, h),
            ProfileInputField("Curso y Paralelo", cursoCtrl, w, h),
            ProfileInputField("Correo Electrónico", correoCtrl, w, h),
            ProfileInputField("Ubicación", ubicacionCtrl, w, h),

            SizedBox(height: 15 * h),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 15 * h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * w),
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(fontSize: 16 * w, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 10 * w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Aquí guardarás
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 15 * h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * w),
                      ),
                    ),
                    child: Text(
                      "Guardar",
                      style: TextStyle(fontSize: 16 * w, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
