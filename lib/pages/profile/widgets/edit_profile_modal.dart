import 'package:LudiArtech/models/user_model.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_input_field.dart';

class EditProfileModal {
  static Future<void> show(BuildContext context, {required UserModel user}) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final w = width / 390;
    final h = height / 844;

    final nameCtrl = TextEditingController(text: user.firstName);
    final lastnameCtrl = TextEditingController(text: user.lastName);
    final edadCtrl = TextEditingController(text: user.age.toString());
    final sexoCtrl = TextEditingController(text: user.gender);
    final cursoCtrl = TextEditingController(text: user.course);
    final correoCtrl = TextEditingController(text: user.email);
    final ubicacionCtrl = TextEditingController(text: user.location);

    return showDialog(
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

class _ModalBody extends StatefulWidget {
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
  State<_ModalBody> createState() => _ModalBodyState();
}

class _ModalBodyState extends State<_ModalBody> {
  bool _loading = false;

  final UserService userService =
      UserService(ApiService(ApiConstants.baseUrl));

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 24 * widget.w,
        vertical: 20 * widget.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30 * widget.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14 * widget.w,
            offset: Offset(0, 5 * widget.h),
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
                  fontSize: 22 * widget.w,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 15 * widget.h),

            ProfileInputField("Nombres", widget.nameCtrl, widget.w, widget.h),
            ProfileInputField("Apellido", widget.lastnameCtrl, widget.w, widget.h),
            ProfileInputField("Edad", widget.edadCtrl, widget.w, widget.h),
            ProfileInputField("Sexo", widget.sexoCtrl, widget.w, widget.h),
            ProfileInputField("Curso y Paralelo", widget.cursoCtrl, widget.w, widget.h),
            ProfileInputField("Correo Electrónico", widget.correoCtrl, widget.w, widget.h),
            ProfileInputField("Ubicación", widget.ubicacionCtrl, widget.w, widget.h),

            SizedBox(height: 15 * widget.h),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 15 * widget.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * widget.w),
                      ),
                    ),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(
                        fontSize: 16 * widget.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10 * widget.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 15 * widget.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * widget.w),
                      ),
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Guardar",
                            style: TextStyle(
                              fontSize: 16 * widget.w,
                              color: Colors.white,
                            ),
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

  Future<void> _saveProfile() async {
    setState(() => _loading = true);

    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token no encontrado");

      await userService.updateProfile(
        token: token,
        firstName: widget.nameCtrl.text.trim(),
        lastName: widget.lastnameCtrl.text.trim(),
        age: int.parse(widget.edadCtrl.text),
        gender: widget.sexoCtrl.text.trim(),
        course: widget.cursoCtrl.text.trim(),
        email: widget.correoCtrl.text.trim(),
        location: widget.ubicacionCtrl.text.trim(),
      );

      Navigator.pop(context);

      BannerNotification.show(
        context,
        message: "Perfil actualizado correctamente",
        isSuccess: true,
      );
    } catch (e) {
      BannerNotification.show(
        context,
        message: e.toString().replaceAll('Exception:', '').trim(),
        isSuccess: false,
      );
    } finally {
      setState(() => _loading = false);
    }
  }
}
