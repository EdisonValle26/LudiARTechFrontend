import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:flutter/material.dart';

class RecoverPasswordForm extends StatefulWidget {
  final double scale;
  const RecoverPasswordForm({super.key, required this.scale});

  @override
  State<RecoverPasswordForm> createState() => _RecoverPasswordFormState();
}

class _RecoverPasswordFormState extends State<RecoverPasswordForm> {
  final List<TextEditingController> codeControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> codeFocus = List.generate(4, (_) => FocusNode());

  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool showNew = false;
  bool showConfirm = false;

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasNumber = false;

  void validatePassword(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasUppercase = value.contains(RegExp(r"[A-Z]"));
      hasNumber = value.contains(RegExp(r"[0-9]"));
    });
  }

  bool get isFormValid {
    final codeFilled =
        codeControllers.every((c) => c.text.isNotEmpty && c.text.length == 1);

    return codeFilled &&
        hasMinLength &&
        hasUppercase &&
        hasNumber &&
        confirmPassword.text == newPassword.text;
  }

  Widget codeBox(int index, double w, double h) {
    return SizedBox(
      width: 60 * w,
      height: 60 * w,
      child: TextField(
        controller: codeControllers[index],
        focusNode: codeFocus[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(fontSize: 22 * w, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12 * w),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            codeFocus[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            codeFocus[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }

  Widget bullet(String text, bool valid) {
    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: valid ? Colors.green : Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: valid ? Colors.green : Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget passwordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
    Function(String)? onChanged,
    required String placeholder,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          onChanged: (value) {
            if (onChanged != null) onChanged(value);
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: InkWell(
              onTap: toggle,
              child: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15 * w, vertical: 20 * h),
      child: Column(
        children: [
          SizedBox(height: 40 * h),

          Text(
            "Ingresa el código de verificación",
            style: TextStyle(
              fontSize: 22 * w,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8 * h),
          Text(
            "Hemos enviado un código a tu correo.",
            style: TextStyle(
              fontSize: 14 * w,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20 * h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8 * w),
                child: codeBox(i, w, h),
              ),
            ),
          ),

          SizedBox(height: 20 * h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20 * w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20 * w),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Recuperación de contraseña",
                  style: TextStyle(
                    fontSize: 20 * w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8 * h),
                Text(
                  "Asegúrate de que sea segura y fácil de recordar.",
                  style: TextStyle(
                    fontSize: 14 * w,
                    color: Colors.black54,
                  ),
                ),

                SizedBox(height: 20 * h),

                passwordField(
                  label: "Nueva contraseña",
                  placeholder: "Ingresa tu nueva contraseña",
                  controller: newPassword,
                  obscure: !showNew,
                  toggle: () => setState(() => showNew = !showNew),
                  onChanged: validatePassword,
                  validator: (value) {
                    if (!hasMinLength || !hasUppercase || !hasNumber) {
                      return "La contraseña no cumple los requisitos";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 10 * h),

                bullet("Mínimo 8 caracteres", hasMinLength),
                SizedBox(height: 4),
                bullet("Una letra mayúscula", hasUppercase),
                SizedBox(height: 4),
                bullet("Un número", hasNumber),

                SizedBox(height: 20 * h),

                passwordField(
                  label: "Confirmar contraseña",
                  placeholder: "Repite tu nueva contraseña",
                  controller: confirmPassword,
                  obscure: !showConfirm,
                  toggle: () => setState(() => showConfirm = !showConfirm),
                  validator: (value) {
                    if (value != newPassword.text) {
                      return "Las contraseñas no coinciden";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 30 * h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            BannerNotification.show(
                              context,
                              message: "Contraseña restablecida correctamente",
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFormValid
                          ? Colors.blueAccent
                          : Colors.grey.shade400,
                      padding: EdgeInsets.symmetric(vertical: 16 * h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14 * w),
                      ),
                    ),
                    child: Text(
                      "Restablecer contraseña",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17 * w,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 15 * h),

          Container(
            padding: EdgeInsets.all(15 * w),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(14 * w),
            ),
            child: Row(
              children: [
                Icon(Icons.emoji_objects_outlined,
                    color: Colors.amber, size: 35 * w),
                SizedBox(width: 10 * w),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: const [
                        TextSpan(
                          text: "Tip: ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              "Revisa también tu carpeta de spam si no ves el correo en unos minutos.",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
