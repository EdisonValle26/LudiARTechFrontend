import 'package:LudiArtech/pages/providers/routes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderMenuButtons extends StatelessWidget {
  final double scale;
  const HeaderMenuButtons({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        btn(context, "word", "Word", Icons.description),
        btn(context, "excel", "Excel", Icons.table_chart),
        btn(context, "power_point", "PowerPoint", Icons.slideshow),
      ],
    );
  }

  Widget btn(BuildContext context, String key, String label, IconData icon) {
    final selected = context.watch<RoutesProvider>().selected;
    final isSelected = selected == key;

    return InkWell(
      onTap: () => context.read<RoutesProvider>().changeTo(key),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 14 * scale,
          vertical: 8 * scale,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFBA44FF) : Colors.white,
          borderRadius: BorderRadius.circular(24 * scale),
          border: Border.all(
            color: const Color(0xFFBA44FF),
            width: 1.8 * scale,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16 * scale,
              color: isSelected ? Colors.white : const Color(0xFFBA44FF),
            ),
            SizedBox(width: 6 * scale),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5 * scale,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFFBA44FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
