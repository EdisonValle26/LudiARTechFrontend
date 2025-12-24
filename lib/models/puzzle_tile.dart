class PuzzleTile {
  final int value;
  final bool isEmpty;
  final String label;

  PuzzleTile({
    required this.value,
    this.isEmpty = false,
    this.label = '',
  });
}
