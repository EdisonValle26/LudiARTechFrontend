import 'package:LudiArtech/models/user_model.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';

import '../widgets/edit_profile_modal.dart';
import '../widgets/profile_edit_button.dart';
import '../widgets/profile_field.dart';

class ProfileForm extends StatefulWidget {
  final double scale;
  const ProfileForm({super.key, required this.scale});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late Future<UserModel> _userFuture;

  final UserService userService = UserService(ApiService(ApiConstants.baseUrl));

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      setState(() {
        _userFuture = userService.getMe(token: token);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final w = width / 390;
    final h = height / 844;


    return FutureBuilder<String?>(
      future: TokenStorage.getToken(),
      builder: (context, tokenSnapshot) {
        if (!tokenSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            final user = snapshot.data!;

            return Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    width: width,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// AVATAR CENTRADO
                        Center(
                          child: ProfileAvatar(
                            radius: 65 * w,
                            name: user.firstName,
                            lastName: user.lastName,
                          ),
                        ),

                        SizedBox(height: 22 * h),

                        /// CAMPOS
                        ProfileField(
                          title: "Nombres",
                          value: user.firstName,
                          w: w,
                          h: h,
                        ),
                        ProfileField(
                          title: "Apellido",
                          value: user.lastName,
                          w: w,
                          h: h,
                        ),
                        ProfileField(
                          title: "Edad",
                          value: user.age.toString(),
                          w: w,
                          h: h,
                        ),
                        ProfileField(
                          title: "Sexo",
                          value: user.gender,
                          w: w,
                          h: h,
                        ),
                        ProfileField(
                          title: "Curso",
                          value: user.course,
                          w: w,
                          h: h,
                        ),
                        ProfileField(
                          title: "Correo Electrónico",
                          value: user.email,
                          w: w,
                          h: h,
                        ),
                        ProfileField(
                          title: "Ubicación",
                          value: user.location,
                          w: w,
                          h: h,
                        ),

                        SizedBox(height: 20 * h),

                        Center(
                          child: ProfileEditButton(
                            w: w,
                            h: h,
                            onPressed: () async {
                              await EditProfileModal.show(context, user: user);
                              _loadUser();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
