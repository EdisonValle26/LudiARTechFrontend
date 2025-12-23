import 'package:LudiArtech/services/token_storage.dart';
import 'package:flutter/material.dart';

import 'notification_icon.dart';

class HomeHeader extends StatelessWidget {
  final double scale;
  const HomeHeader({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FutureBuilder<String?>(
        future: TokenStorage.getUsername(),
        builder: (context, snapshot) {
          final username = snapshot.data ?? "Usuario";

          return Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              width * 0.06 * scale,
              width * 0.06 * scale,
              width * 0.06 * scale,
              width * 0.01 * scale,
            ),
            color: Colors.white.withOpacity(0.45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Buen día 👋",
                        style: TextStyle(
                          fontSize: width * 0.06 * scale,
                          color: const Color(0x6E6E6E6E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    NotificationIcon(
                      size: width * 0.070 * scale,
                      padding: width * 0.026,
                    ),
                  ],
                ),
                SizedBox(height: width * 0.001 * scale),
                Text(
                  username.toUpperCase(),
                  style: TextStyle(
                    fontSize: width * 0.080 * scale,
                    color: const Color(0xFFBA44FF),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: width * 0.020 * scale),
                Text(
                  "¿Listo para tu nueva aventura?",
                  style: TextStyle(
                    fontSize: width * 0.045 * scale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
