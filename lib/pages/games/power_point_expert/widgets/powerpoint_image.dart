import 'package:LudiArtech/widgets/firebase_image.dart';
import 'package:LudiArtech/widgets/no_back_button.dart';
import 'package:flutter/material.dart';

class PowerPointImage extends StatelessWidget {
  final List<Widget> overlays;

  const PowerPointImage({super.key, required this.overlays});

  void _openFullScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoBackWrapper(
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: const Text("Imagen PowerPoint"),
            ),
            body: Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 5,
                child: const FirebaseImage(
                  path: "interfaz_power_point.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFullScreen(context),
      child: Stack(
        children: [
          const FirebaseImage(
            path: "interfaz_power_point.png",
            fit: BoxFit.cover,
          ),
          ...overlays,
        ],
      ),
    );
  }
}
