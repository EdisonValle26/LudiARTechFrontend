import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/auth_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:flutter/material.dart';

class PrivacySecurityForm extends StatefulWidget {
  final double scale;
  const PrivacySecurityForm({super.key, required this.scale});

  @override
  State<PrivacySecurityForm> createState() => _PrivacySecurityFormState();
}

class _PrivacySecurityFormState extends State<PrivacySecurityForm> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  final AuthService authService = AuthService(ApiService(ApiConstants.baseUrl));

  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool showCurrent = false;
  bool showNew = false;
  bool showConfirm = false;

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasNumber = false;

  void validatePassword(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasNumber = value.contains(RegExp(r'[0-9]'));
    });
  }

  bool get isFormValid {
    return currentPassword.text.isNotEmpty &&
        hasMinLength &&
        hasUppercase &&
        hasNumber &&
        confirmPassword.text == newPassword.text;
  }

  Widget passwordField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback toggle,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            if (onChanged != null) onChanged(value);
            setState(() {});
          },
          validator: validator,
          decoration: InputDecoration(
            hintText: placeholder,
            suffixIcon: InkWell(
              onTap: toggle,
              child: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15 * w, vertical: 20 * h),
      child: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.lock, color: Color(0xFFBA44FF), size: 28),
                  SizedBox(width: 10),
                  Text(
                    "Cambiar Contraseña",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBA44FF),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              passwordField(
                label: "Contraseña actual",
                placeholder: "Ingresa tu contraseña actual",
                controller: currentPassword,
                obscure: !showCurrent,
                toggle: () => setState(() => showCurrent = !showCurrent),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La contraseña actual es obligatoria";
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              passwordField(
                label: "Contraseña nueva",
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
              SizedBox(height: 15),
              bullet("Mínimo 8 caracteres", hasMinLength),
              SizedBox(height: 4),
              bullet("Una letra mayúscula", hasUppercase),
              SizedBox(height: 4),
              bullet("Un número", hasNumber),
              SizedBox(height: 25),
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
              const SizedBox(height: 60),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid && !_loading
                      ? () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => _loading = true);

                          try {
                            final token = await TokenStorage.getToken();

                            if (token == null) {
                              throw Exception("Sesión expirada");
                            }

                            await authService.changePassword(
                              token: token,
                              currentPassword: currentPassword.text.trim(),
                              newPassword: newPassword.text.trim(),
                            );

                            BannerNotification.show(
                              context,
                              message: "Contraseña actualizada correctamente",
                            );

                            currentPassword.clear();
                            newPassword.clear();
                            confirmPassword.clear();

                            Navigator.pushNamed(context, AppRoutes.configuration);
                          } catch (e) {
                            BannerNotification.show(
                              context,
                              message:
                                  e.toString().replaceAll('Exception: ', ''),
                              isSuccess: false,
                            );
                          } finally {
                            setState(() => _loading = false);
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFormValid ? const Color(0xFFBA44FF) : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Guardar nueva contraseña",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
