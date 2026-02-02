import 'package:LudiArtech/routes/app_routes.dart';
import 'package:LudiArtech/services/api_service.dart';
import 'package:LudiArtech/services/game_service.dart';
import 'package:LudiArtech/services/token_storage.dart';
import 'package:LudiArtech/services/user_service.dart';
import 'package:LudiArtech/utils/api_constants.dart';
import 'package:LudiArtech/widgets/dialogs/app_dialog.dart';
import 'package:LudiArtech/widgets/dialogs/dialog_button.dart';
import 'package:flutter/material.dart';

class RobotBuilderForm extends StatefulWidget {
  final double scale;
  final VoidCallback? onExitGame;

  const RobotBuilderForm({
    super.key,
    required this.scale,
    this.onExitGame,
  });

  @override
  State<RobotBuilderForm> createState() => RobotBuilderFormState();
}

class RobotBuilderFormState extends State<RobotBuilderForm> {
  final GameResultService _gameResultService =
      GameResultService(ApiService(ApiConstants.baseUrl));

  static const int maxErrors = 6;
  static const int totalParts = 6;

  int _currentWordIndex = 0;
  int _errors = 0;
  int _points = 0;
  bool _resultSent = false;

  int? _lastScore;
  bool? _streakGained;

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

  bool get _wordCompleted => _points >= totalParts;

  bool get _isLastWord => _currentWordIndex >= _words.length - 1;

  @override
  void initState() {
    super.initState();
    _initWord();
  }

  void _initWord() {
    _usedLetters.clear();
    _correctLetters.clear();
    _points = 0;
  }

  void _resetGame() {
    setState(() {
      _currentWordIndex = 0;
      _errors = 0;
      _points = 0;
      _resultSent = false;
      _lastScore = null;
      _streakGained = null;
      _initWord();
    });
  }

  Future<bool> _checkLives() async {
    final token = await TokenStorage.getToken();
    if (token == null) return false;

    final api = ApiService(ApiConstants.baseUrl);
    final userService = UserService(api);

    try {
      final stats = await userService.getUserStats(token: token);

      if (stats.lives <= 0) {
        _showNoLivesDialog();
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<GameResultResponse?> _sendGameResult(String status) async {
    if (_resultSent) return null;
    _resultSent = true;

    final token = await TokenStorage.getToken();
    if (token == null) return null;

    try {
      final result = await _gameResultService.sendResultOnlyErrors(
        token: token,
        gameId: 2,
        status: status,
        usedErrors: _errors,
        totalErrors: maxErrors,
      );

      _lastScore = result.score;
      _streakGained = result.streakGained;

      return result;
    } catch (e) {
      return null;
    }
  }

  void exitGameAsLose() {
    _sendGameResult("LOSE");
  }

  void _showNoLivesDialog() {
    AppDialog.show(
      context: context,
      title: "💔 Sin vidas",
      content: const Text(
        "Te quedaste sin vidas.\n\nDebes esperar 5 minutos para recuperar una vida.",
      ),
      buttons: [
        DialogButton(
          text: "Volver",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            widget.onExitGame?.call();
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void _showWinDialog() {
    AppDialog.show(
      context: context,
      title: "🎉 ¡Felicidades!",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Completaste todas las palabras correctamente."),
          const SizedBox(height: 8),
          Text("❌ Errores: $_errors / $maxErrors"),
          const SizedBox(height: 6),
          Text("🏆 Puntaje obtenido: ${_lastScore ?? 0}"),
          const SizedBox(height: 6),
          if (_streakGained == true)
            const Text("🔥 ¡Ganaste +1 racha!")
          else
            const Text("❌ No se ganó racha esta vez"),
        ],
      ),
      buttons: [
        DialogButton(
          text: "Reiniciar",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            _resetGame();
          },
        ),
        DialogButton(
          text: "Volver",
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void _showLoseDialog() {
    AppDialog.show(
      context: context,
      title: "❌ Perdiste",
      content: const Text("Alcanzaste el máximo de errores."),
      buttons: [
        DialogButton(
          text: "Reiniciar",
          isPrimary: true,
          onPressed: () {
            Navigator.pop(context);
            _resetGame();
          },
        ),
        DialogButton(
          text: "Volver",
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.activityCenter);
          },
        ),
      ],
    );
  }

  void _onLetterPressed(String letter) async {
    final canPlay = await _checkLives();
    if (!canPlay) return;

    if (_usedLetters.contains(letter)) return;
    if (_wordCompleted) return;

    setState(() {
      _usedLetters.add(letter);

      final isInWord = _currentWord.word.contains(letter);
      final isInitial = _currentWord.revealedLetters.contains(letter);
      final alreadyCorrect = _correctLetters.contains(letter);

      if (isInWord && !isInitial && !alreadyCorrect) {
        _correctLetters.add(letter);
        _points++;

        if (_wordCompleted && _isLastWord) {
          _sendGameResult("WIN").then((_) => _showWinDialog());
        }
      } else {
        _errors++;

        if (_errors >= maxErrors) {
          _sendGameResult("LOSE");
          _showLoseDialog();
        }
      }
    });
  }

  void _nextWord() {
    if (!_wordCompleted) return;
    if (_isLastWord) return;

    setState(() {
      _currentWordIndex++;
      _initWord();
    });
  }

  Widget _animatedPart({required Widget child}) {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.elasticOut,
      child: child,
    );
  }

  Widget _head(double s) {
    return Positioned(
      top: 0,
      child: _animatedPart(
        child: Container(
          width: s * 0.35,
          height: s * 0.35,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 3),
              )
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("•", style: TextStyle(fontSize: 28)),
              SizedBox(width: 8),
              Text("•", style: TextStyle(fontSize: 28)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(double s) {
    return Positioned(
      top: s * 0.35,
      child: _animatedPart(
        child: Container(
          width: s * 0.45,
          height: s * 0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Colors.blueGrey, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 3),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _leftArm(double s) {
    return Positioned(
      top: s * 0.42,
      left: s * 0.02,
      child: _animatedPart(
        child: Container(
          width: s * 0.14,
          height: s * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.grey, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _rightArm(double s) {
    return Positioned(
      top: s * 0.42,
      right: s * 0.02,
      child: _animatedPart(
        child: Container(
          width: s * 0.14,
          height: s * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.grey, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _leftLeg(double s) {
    return Positioned(
      bottom: 0,
      left: s * 0.22,
      child: _animatedPart(
        child: Container(
          width: s * 0.13,
          height: s * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.blueGrey, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _rightLeg(double s) {
    return Positioned(
      bottom: 0,
      right: s * 0.22,
      child: _animatedPart(
        child: Container(
          width: s * 0.13,
          height: s * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.blueGrey, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRobot(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_points >= 1) _body(size),
        if (_points >= 2) _leftArm(size),
        if (_points >= 3) _rightArm(size),
        if (_points >= 4) _leftLeg(size),
        if (_points >= 5) _rightLeg(size),
        if (_points >= 6) _head(size),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16 * widget.scale),
      child: Column(
        children: [
          Text(
            "Procesador de palabras de Microsoft Word",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.05 * widget.scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: w * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: SizedBox(
                width: w * 0.40,
                height: w * 0.40,
                child: _buildRobot(w * 0.40),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
                      "✅ $_points / $totalParts",
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
                Wrap(
                  spacing: 6,
                  children: _currentWord.word.split('').map((letter) {
                    final visible = _correctLetters.contains(letter) ||
                        _currentWord.revealedLetters.contains(letter);

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
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: List.generate(26, (i) {
              final letter = String.fromCharCode(65 + i);
              final used = _usedLetters.contains(letter);
              final correct = _correctLetters.contains(letter);

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
                  onPressed: (used || _wordCompleted)
                      ? null
                      : () => _onLetterPressed(letter),
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
          if (!_isLastWord) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _wordCompleted ? _nextWord : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreen,
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
          ]
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
