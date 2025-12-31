import 'package:LudiArtech/models/puzzle_tile.dart';
import 'package:flutter/material.dart';

import 'puzzle_tile_widget.dart';

class PuzzleGrid extends StatelessWidget {
  final List<PuzzleTile> tiles;
  final int gridSize;
  final Function(int) onTileTap;

  const PuzzleGrid({
    super.key,
    required this.tiles,
    required this.gridSize,
    required this.onTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.50),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tiles.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridSize,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return PuzzleTileWidget(
            tile: tiles[index],
            onTap: () => onTileTap(index),
          );
        },
      ),
    );
  }
}
