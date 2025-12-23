import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

import 'info_card.dart';
import 'info_section.dart';

class PersonalInfoForm extends StatelessWidget {
  final double scale;
  const PersonalInfoForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

    return FutureBuilder<String?>(
        future: TokenStorage.getFullname(),
        builder: (context, snapshot) {
          final fullName = snapshot.data ?? "Usuario";
          final parts = fullName.split(" ");

          final name = parts.isNotEmpty ? parts.first : "U";
          final lastName = parts.length > 1 ? parts.last : "";

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 15 * w,
              vertical: 20 * h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20 * h),
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
                        name: name,
                        lastName: lastName,
                      ),
                      SizedBox(height: 20 * h),
                      Text(
                        "María Gómez",
                        style: TextStyle(
                          fontSize: 20 * w,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30 * h),
                InfoCard(
                  w: w,
                  h: h,
                  title: "Información de cuenta",
                  sections: [
                    InfoSection(
                      icon: Icons.date_range_rounded,
                      title: "Miembro desde",
                      subtitle: "Octubre 2025",
                    ),
                    InfoSection(
                      icon: Icons.place_rounded,
                      title: "Ubicación",
                      subtitle: "Guayaquil, Ecuador",
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
                      subtitle: "maria.gomez@mail.com",
                    ),
                    InfoSection(
                      icon: Icons.phone,
                      title: "Teléfono",
                      subtitle: "+593 99 123 4567",
                    ),
                  ],
                ),
                SizedBox(height: 20 * h),
              ],
            ),
          );
        });
  }
}
