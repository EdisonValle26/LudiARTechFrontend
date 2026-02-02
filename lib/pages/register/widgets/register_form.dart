import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/auth_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscurePassword = true;
  bool _loading = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthService authService = AuthService(ApiService(ApiConstants.baseUrl));

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
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
    final sectionSpacing = height * 0.05;

    return Positioned(
      bottom: height * 0.045,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: formWidth,
          height: formHeight,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: height * 0.02,
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
              children: [
                SizedBox(height: height * 0.02),
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
                      vertical: height * 0.018,
                      horizontal: width * 0.03,
                    ),
                  ),
                ),
                SizedBox(height: fieldSpacing),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Correo Electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    hintStyle: TextStyle(fontSize: width * 0.035),
                    filled: true,
                    fillColor: const Color(0xFFF7F3FF),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: height * 0.018,
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
                SizedBox(height: sectionSpacing),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            final username = usernameController.text.trim();
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();

                            if (username.isEmpty ||
                                email.isEmpty ||
                                password.isEmpty) {
                              BannerNotification.show(
                                context,
                                message: "Complete todos los campos",
                              );
                              return;
                            }

                            setState(() => _loading = true);

                            try {
                              await authService.register(
                                username: username,
                                email: email,
                                password: password,
                              );

                              BannerNotification.show(
                                context,
                                message: "Usuario registrado correctamente",
                              );

                              // opcional: ir al login
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.pushNamed(context, AppRoutes.login);
                              });
                            } catch (e) {
                              BannerNotification.show(
                                context,
                                message:
                                    e.toString().replaceAll('Exception: ', ''),
                              );
                            } finally {
                              setState(() => _loading = false);
                            }
                          },
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text("Registrarse"),
                  ),
                ),
                SizedBox(height: sectionSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
