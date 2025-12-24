import 'package:LudiArtech/models/user_model.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

import 'info_card.dart';
import 'info_section.dart';

class PersonalInfoForm extends StatelessWidget {
  final double scale;

  const PersonalInfoForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final UserService userService =
        UserService(ApiService(ApiConstants.baseUrl));
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

    return FutureBuilder<String?>(
      future: TokenStorage.getToken(),
      builder: (context, tokenSnapshot) {
        if (!tokenSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<UserModel>(
          future: userService.getMe(token: tokenSnapshot.data!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text("Error al cargar perfil"));
            }

            final user = snapshot.data!;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 15 * w,
                vertical: 20 * h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20 * h),

                  /// ===== TARJETA PRINCIPAL =====
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 30 * h,
                      bottom: 30 * h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16 * w),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ProfileAvatar(
                          radius: 60 * w,
                          name: user.firstName,
                          lastName: user.lastName,
                        ),
                        SizedBox(height: 20 * h),
                        Text(
                          "${user.firstName} ${user.lastName}",
                          style: TextStyle(
                            fontSize: 20 * w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30 * h),

                  /// ===== INFO CUENTA =====
                  InfoCard(
                    w: w,
                    h: h,
                    title: "Información de cuenta",
                    sections: [
                      InfoSection(
                        icon: Icons.date_range_rounded,
                        title: "Miembro desde",
                        subtitle: user.createdAt,
                      ),
                      InfoSection(
                        icon: Icons.place_rounded,
                        title: "Ubicación",
                        subtitle: user.location,
                      ),
                    ],
                  ),

                  SizedBox(height: 25 * h),

                  InfoCard(
                    w: w,
                    h: h,
                    title: "Información de contacto",
                    sections: [
                      InfoSection(
                        icon: Icons.email,
                        title: "Correo",
                        subtitle: user.email,
                      ),
                      InfoSection(
                        icon: Icons.phone,
                        title: "Teléfono",
                        subtitle: user.phone,
                      ),
                    ],
                  ),

                  SizedBox(height: 20 * h),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
