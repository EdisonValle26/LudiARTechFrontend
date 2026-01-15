import 'package:flutter/material.dart';

class MemoryGrid<T> extends StatelessWidget {
  final List<T> cards;
  final Future<void> Function(T) onTap;

  const MemoryGrid({
    super.key,
    required this.cards,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (_, i) {
          final card = cards[i] as dynamic;

          return GestureDetector(
            onTap: () => onTap(cards[i]),
            child: Container(
              decoration: BoxDecoration(
                color: card.isFlipped || card.isMatched
                    ? card.color
                    : Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: card.isFlipped || card.isMatched
                    ? Padding(
                        padding: const EdgeInsets.all(1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(card.icon, color: Colors.white, size: 26),
                            const SizedBox(height: 6),
                            Text(
                              card.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Icon(
                        Icons.question_mark,
                        color: Colors.white,
                        size: 40,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
