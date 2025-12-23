import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/auth_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:flutter/material.dart';

class ForgetPasswordForm extends StatefulWidget {
  final double scale;
  const ForgetPasswordForm({super.key, required this.scale});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  bool isValidEmail = false;
  bool _loading = false;

  bool validateEmail(String value) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(value);
  }


  final emailController = TextEditingController();

  final AuthService authService = AuthService(ApiService(ApiConstants.baseUrl));

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15 * w, vertical: 20 * h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 35 * h),

          Icon(
            Icons.lock_reset_rounded,
            size: 100 * w,
            color: Colors.blueAccent,
          ),

          SizedBox(height: 40 * h),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 18 * w,
              vertical: 28 * h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18 * w),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(
                    fontSize: 18 * w,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 18 * h),

                Text(
                  "Ingresa tu correo y te enviaremos un código de recuperación.",
                  style: TextStyle(
                    fontSize: 13 * w,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 35 * h),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Correo Electrónico",
                    style: TextStyle(
                      fontSize: 14 * w,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                SizedBox(height: 10 * h),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "tu.correo@ejemplo.com",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 20 * h,
                      horizontal: 14 * w,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12 * w),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {
                      isValidEmail = validateEmail(v.trim());
                    });
                  },
                ),

                SizedBox(height: 28 * h),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (!_loading && isValidEmail)
                        ? () async {
                            setState(() => _loading = true);

                            try {
                              await authService.requestPassword(
                                email: emailController.text.trim(),
                              );

                              BannerNotification.show(
                                context,
                                message:
                                    "Te enviamos un código de recuperación a tu correo",
                              );

                              Navigator.pushNamed(
                                context,
                                AppRoutes.recoverPassword,
                              );
                            } catch (e) {
                              BannerNotification.show(
                                context,
                                message: e.toString(),
                                isSuccess: false,
                              );
                            } finally {
                              setState(() => _loading = false);
                            }
                          }
                        : null,
                    icon: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      _loading ? "Enviando..." : "Enviar código",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18 * h),
                      backgroundColor: isValidEmail
                          ? Colors.blueAccent
                          : Colors.blue.shade200,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * w),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 35 * h),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child: const Text(
                    "¿Recordaste tu contraseña?",
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
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