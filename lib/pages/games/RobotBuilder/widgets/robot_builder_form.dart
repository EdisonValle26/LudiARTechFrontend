import 'package:flutter/material.dart';

class RobotBuilderForm extends StatefulWidget {
  final double scale;

  const RobotBuilderForm({
    super.key,
    required this.scale,
  });

  @override
  State<RobotBuilderForm> createState() => RobotBuilderFormState();
}

class RobotBuilderFormState extends State<RobotBuilderForm> {
  static const int maxErrors = 6;
  static const int totalPoints = 6;

  int _currentWordIndex = 0;
  int _errors = 0;
  int _points = 0;

  final List<_WordData> _words = [
    _WordData(
      word: "MARGENES",
      hint: "Pista: Espacios alrededor de una hoja en Excel",
      revealedLetters: ["G"],
    ),
    _WordData(
      word: "ORIENTACION",
      hint: "Pista: Puede ser vertical y horizontal",
      revealedLetters: ["R", "T"],
    ),
    _WordData(
      word: "ENCABEZADO",
      hint: "Pista: Texto superior de cada página",
      revealedLetters: ["C", "Z"],
    ),
    _WordData(
      word: "HIPERVINCULO",
      hint: "Pista: Enlace a otra pagina",
      revealedLetters: ["H", "P", "V", "N", "L"],
    ),
  ];

  final Set<String> _usedLetters = {};
  final Set<String> _correctLetters = {};

  _WordData get _currentWord => _words[_currentWordIndex];

  @override
  void initState() {
    super.initState();
    _initWord();
  }

  void _initWord() {
    _usedLetters.clear();
    _correctLetters
      ..clear()
      ..addAll(_currentWord.revealedLetters);
    _points = _calculatePoints();
  }

  void _onLetterPressed(String letter) {
    if (_usedLetters.contains(letter)) return;

    setState(() {
      _usedLetters.add(letter);

      if (_currentWord.word.contains(letter)) {
        _correctLetters.add(letter);
        _points = _calculatePoints();
      } else {
        _errors++;
      }
    });
  }

  int _calculatePoints() {
    final uniqueLetters = _currentWord.word.split('').toSet();
    int count = 0;

    for (final l in uniqueLetters) {
      if (_correctLetters.contains(l)) {
        count++;
      }
    }

    return count.clamp(0, totalPoints);
  }

  void _nextWord() {
    if (_currentWordIndex >= _words.length - 1) return;

    setState(() {
      _currentWordIndex++;
      _initWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16 * widget.scale),
      child: Column(
        children: [
          // TÍTULO
          Text(
            "Procesador de palabras de Microsoft Word",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.05 * widget.scale,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // ROBOT
          Container(
            height: w * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                "🤖 Robot: $_points / 6",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // PISTA + STATS
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "❌ $_errors / $maxErrors",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "✅ $_points / $totalPoints",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  _currentWord.hint,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 14),

                // PALABRA
                Wrap(
                  spacing:6,
                  children: _currentWord.word.split('').map((letter) {
                    final visible = _correctLetters.contains(letter);

                    return Container(
                      width: 30,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: Colors.black),
                        ),
                      ),
                      child: Text(
                        visible ? letter : "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // TECLADO
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(26, (i) {
              final letter = String.fromCharCode(65 + i);
              final used = _usedLetters.contains(letter);
              final correct = _currentWord.word.contains(letter);

              Color bgColor = Colors.white;
              Color textColor = Colors.black;
              Color borderColor = Colors.grey;

              if (used && correct) {
                bgColor = Colors.green;
                textColor = Colors.white;
                borderColor = Colors.green;
              } else if (used && !correct) {
                bgColor = Colors.red;
                textColor = Colors.white;
                borderColor = Colors.red;
              }

              return SizedBox(
                width: 38,
                height: 38,
                child: OutlinedButton(
                  onPressed: used ? null : () => _onLetterPressed(letter),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: textColor,
                    side: BorderSide(color: borderColor, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 14),

          // NUEVA PALABRA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  _currentWordIndex >= _words.length - 1 ? null : _nextWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Nueva palabra",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WordData {
  final String word;
  final String hint;
  final List<String> revealedLetters;

  _WordData({
    required this.word,
    required this.hint,
    required this.revealedLetters,
  });
}
