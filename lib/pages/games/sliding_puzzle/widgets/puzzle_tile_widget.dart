import 'package:LudiArtech/models/puzzle_tile.dart';
import 'package:flutter/material.dart';


class PuzzleTileWidget extends StatelessWidget {
  final PuzzleTile tile;
  final VoidCallback onTap;

  const PuzzleTileWidget({
    super.key,
    required this.tile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tile.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tile.value.toString(),
              style: const TextStyle(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              tile.label,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
