import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:flutter/material.dart';

class ForgetPasswordForm extends StatefulWidget {
  final double scale;
  const ForgetPasswordForm({super.key, required this.scale});

  @override
  State<ForgetPasswordForm> createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final emailCtrl = TextEditingController();
  bool isValidEmail = false;

  bool validateEmail(String value) {
    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return regex.hasMatch(value);
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
                  controller: emailCtrl,
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
                    onPressed: isValidEmail
                        ? () {
                            BannerNotification.show(
                              context,
                              message: "Te enviamos un código de recuperación a tu correo",
                            );
                            Navigator.pushNamed(context, AppRoutes.recoverPassword);
                          }
                        : null,
                    icon: const Icon(Icons.send),
                    label: Text(
                      "Enviar código",
                      style: TextStyle(
                        fontSize: 15 * w,
                        fontWeight: FontWeight.bold,
                      ),
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

                SizedBox(height: 40 * h),

                Container(
                  padding: EdgeInsets.all(14 * w),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(12 * w),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_objects_outlined,
                        color: Colors.amber,
                        size: 40 * w,
                      ),
                      SizedBox(width: 10 * w),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14 * w,
                            ),
                            children: [
                              TextSpan(
                                text: "Tip: ",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15 * w,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    "Revisa también tu carpeta de spam si no ves el correo en unos minutos.",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 35 * h),

                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child: Text(
                    "¿Recordaste tu contraseña?",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14 * w,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20 * h),
        ],
      ),
    );
  }
}
