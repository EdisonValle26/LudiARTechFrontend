import 'package:flutter/material.dart';

class MemoryPairsGuideDialog extends StatelessWidget {
  const MemoryPairsGuideDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TÍTULO
                Text(
                  "Guía",
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: width * 0.02),

                // TARJETAS
                Row(
                  children: [
                    const Expanded(
                      child: _GuideCard(
                        color: Colors.pinkAccent,
                        icon: Icons.search,
                        title: "Componente",
                        subtitle: "Nombres de los componentes.",
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    const Expanded(
                      child: _GuideCard(
                        color: Colors.deepPurple,
                        icon: Icons.lightbulb_outline,
                        title: "Definición",
                        subtitle: "Explicación de cada componente.",
                      ),
                    ),
                  ],
                ),

                SizedBox(height: width * 0.03),

                // BOTÓN CERRAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: width * 0.035,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      "Entendido",
                      style: TextStyle(color: Colors.white),
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

class _GuideCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _GuideCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(width * 0.045),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: width * 0.1,
          ),
          SizedBox(height: width * 0.03),
          Text(
            title,
            style: TextStyle(
              fontSize: width * 0.045,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: width * 0.02),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.035,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}