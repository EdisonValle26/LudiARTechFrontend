import 'package:flutter/material.dart';

import '../widgets/edit_profile_modal.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_edit_button.dart';
import '../widgets/profile_field.dart';

class ProfileForm extends StatelessWidget {
  final double scale;
  const ProfileForm({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final w = width / 390;
    final h = height / 844;

    return Padding(
      padding: EdgeInsets.only(top: height * 0.02),
      child: Align(
        alignment: Alignment.topCenter,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            width: width * 1,
            padding: EdgeInsets.symmetric(
              horizontal: 24 * w,
              vertical: 20 * h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30 * w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 14 * w,
                  offset: Offset(0, 5 * h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(radius: 65 * w),
                SizedBox(height: 22 * h),
                ProfileField(title: "Nombres", value: "María Alexandra", w: w, h: h),
                ProfileField(title: "Apellido", value: "Gómez Suárez", w: w, h: h),
                ProfileField(title: "Edad", value: "17", w: w, h: h),
                ProfileField(title: "Sexo", value: "Femenino", w: w, h: h),
                ProfileField(title: "Curso y Paralelo", value: "3ro Informática A", w: w, h: h),
                ProfileField(title: "Correo Electrónico", value: "maria.gomez@gmail.com", w: w, h: h),
                ProfileField(title: "Ubicación", value: "Guayaquil, Ecuador", w: w, h: h),

                SizedBox(height: 20 * h),

                Center(
                  child: ProfileEditButton(
                    w: w,
                    h: h,
                    onPressed: () => EditProfileModal.show(context),
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
