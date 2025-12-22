import 'package:flutter/material.dart';

import 'info_card.dart';
import 'info_section.dart';
import 'profile_avatar.dart';

class PersonalInfoForm extends StatelessWidget {
  final double scale;
  const PersonalInfoForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width / 390;
    final h = size.height / 844;

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
                  name: "María",
                  lastName: "Gómez",
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
  }
}
