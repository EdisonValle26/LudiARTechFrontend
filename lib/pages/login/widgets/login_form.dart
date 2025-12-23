import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/auth_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService authService = AuthService(ApiService(ApiConstants.baseUrl));

  bool _loading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final formWidth = width * 0.9;
    final formHeight = height * 0.7;
    final fieldSpacing = height * 0.02;
    final sectionSpacing = height * 0.06;
    final buttonPadding = EdgeInsets.symmetric(vertical: height * 0.02);

    return Positioned(
      bottom: height * 0.045,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: formWidth,
          height: formHeight,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: height * 0.025,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: height * 0.07),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Nombre de usuario',
                    prefixIcon: const Icon(Icons.account_circle_outlined),
                    hintStyle: TextStyle(fontSize: width * 0.035),
                    filled: true,
                    fillColor: const Color(0xFFF7F3FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                      horizontal: width * 0.03,
                    ),
                  ),
                ),
                SizedBox(height: fieldSpacing),
                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    hintStyle: TextStyle(fontSize: width * 0.035),
                    filled: true,
                    fillColor: const Color(0xFFF7F3FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                      horizontal: width * 0.03,
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.forgetPassword);
                    },
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.grey,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: sectionSpacing),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            final username = usernameController.text.trim();
                            final password = passwordController.text.trim();

                            if (username.isEmpty || password.isEmpty) {
                              BannerNotification.show(
                                context,
                                message: "Ingrese usuario y contraseña",
                                isSuccess: false,
                              );
                              return;
                            }

                            setState(() => _loading = true);

                            try {
                              final authResponse = await authService.login(
                                username: username,
                                password: password,
                              );

                              await TokenStorage.saveToken(authResponse.token);
                              await TokenStorage.saveUsername(
                                  authResponse.user.username);
                              await TokenStorage.saveFullname(
                                  authResponse.user.fullname);

                              Future.delayed(const Duration(milliseconds: 600),
                                  () {
                                if (authResponse.firstLogin) {
                                  Navigator.pushNamed(
                                      context, AppRoutes.onboarding);
                                } else {
                                  Navigator.pushNamed(context, AppRoutes.home);
                                }

                                BannerNotification.show(
                                  context,
                                  message: "Ingreso realizado correctamente",
                                  isSuccess: true,
                                );
                              });
                            } catch (e) {
                              BannerNotification.show(
                                context,
                                message: e
                                    .toString()
                                    .replaceAll('Exception:', '')
                                    .trim(),
                                isSuccess: false,
                              );
                            } finally {
                              setState(() => _loading = false);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCE1FD),
                      foregroundColor: const Color(0xFFBA44FF),
                      padding: buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: sectionSpacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xFF464646),
                        thickness: 1,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      'Iniciar con',
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: const Color(0xFF464646),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0xFF464646),
                        thickness: 1,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: height * 0.01,
                    top: height * 0.025,
                  ),
                  child: FirebaseImage(
                    path: "Icono_google.png",
                    width: width * 0.15,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
