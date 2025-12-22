import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/banner_notification.dart';
import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_input_field.dart';

class OnboardingForm extends StatefulWidget {
  const OnboardingForm({super.key});

  @override
  State<OnboardingForm> createState() => _OnboardingFormState();
}

class _OnboardingFormState extends State<OnboardingForm> {
  String? _selectedGender;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final courseController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  bool _loading = false;

  final userService = UserService(ApiService(ApiConstants.baseUrl));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final formWidth = width * 0.9;
    final formHeight = height <= 600 ? height * 0.89 : height * 0.905;
    final fieldSpacing = height <= 600 ? height * 0.01 : height * 0.02;
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
                Text(
                  'COMPLETA TU PERFIL',
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFBA44FF),
                    letterSpacing: 1.1,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1.0, 2.0),
                        blurRadius: 3.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: fieldSpacing),
                CustomInputField(
                  labelText: 'Escribe tus nombres',
                  controller: firstNameController,
                ),
                SizedBox(height: fieldSpacing),
                CustomInputField(
                  labelText: 'Escribe tus apellidos',
                  controller: lastNameController,
                ),
                SizedBox(height: fieldSpacing),
                CustomInputField(
                  labelText: 'Escribe tu edad',
                  controller: ageController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: fieldSpacing),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sexo',
                      style: TextStyle(
                        fontSize: width * 0.040,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGender = "Masculino";
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedGender == "Masculino"
                                        ? Colors.purple
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FirebaseImage(
                                  path: "masculino.png",
                                  width: width * 0.2,
                                  height: height * 0.05,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: height * 0.003),
                              Text(
                                'Masculino',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGender = "Femenino";
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedGender == "Femenino"
                                        ? Colors.purple
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: FirebaseImage(
                                  path: "femenino.png",
                                  width: width * 0.2,
                                  height: height * 0.05,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: height * 0.003),
                              Text(
                                'Femenino',
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: fieldSpacing),
                CustomInputField(
                  labelText: 'Curso y paralelo',
                  controller: courseController,
                ),
                SizedBox(height: fieldSpacing),
                CustomInputField(
                  labelText: 'Teléfono',
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                SizedBox(height: fieldSpacing),
                CustomInputField(
                  labelText: 'Ubicación',
                  controller: locationController,
                ),
                SizedBox(height: fieldSpacing * 1.5),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading
                        ? null
                        : () async {
                            if (firstNameController.text.trim().isEmpty ||
                                lastNameController.text.trim().isEmpty ||
                                ageController.text.trim().isEmpty ||
                                courseController.text.trim().isEmpty ||
                                phoneController.text.trim().isEmpty ||
                                locationController.text.trim().isEmpty) {
                              BannerNotification.show(
                                context,
                                message: "Completa todos los campos",
                                isSuccess: false,
                              );
                              return;
                            }

                            final phone = phoneController.text.trim();

                            if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                              BannerNotification.show(
                                context,
                                message: "El teléfono debe tener 10 números",
                                isSuccess: false,
                              );
                              return;
                            }

                            if (_selectedGender == null) {
                              BannerNotification.show(
                                context,
                                message: "Selecciona tu sexo",
                                isSuccess: false,
                              );
                              return;
                            }

                            final age = int.tryParse(ageController.text.trim());
                            if (age == null || age <= 0) {
                              BannerNotification.show(
                                context,
                                message: "Edad inválida",
                                isSuccess: false,
                              );
                              return;
                            }

                            setState(() => _loading = true);

                            try {
                              final token = await TokenStorage.getToken();

                              if (token == null) {
                                throw Exception("Sesión expirada");
                              }

                              await userService.createProfile(
                                token: token,
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                age: age,
                                gender: _selectedGender!,
                                course: courseController.text.trim(),
                                phone: phoneController.text.trim(),
                                location: locationController.text.trim(),
                              );

                              BannerNotification.show(
                                context,
                                message: "Perfil guardado correctamente",
                              );

                              Navigator.pushNamed(context, AppRoutes.home);
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFCE1FD),
                      foregroundColor: const Color(0xFFBA44FF),
                      padding: buttonPadding,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
