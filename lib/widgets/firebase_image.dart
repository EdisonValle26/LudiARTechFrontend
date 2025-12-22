import 'package:LudiArtech/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';

class FirebaseImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? fallbackAsset;

  const FirebaseImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallbackAsset,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FirebaseStorageService.instance.getUrl(path),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: width,
            height: height,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          if (fallbackAsset != null) {
            return Image.asset(
              fallbackAsset!,
              width: width,
              height: height,
              fit: fit,
            );
          }

          return const Icon(Icons.error, color: Colors.red);
        }

        return Image.network(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}
