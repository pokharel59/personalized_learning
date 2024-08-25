import 'dart:async';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const int squaresPerRow = 20;
  static const int squaresPerCol = 40;
  static const double squareSize = 10.0;

  late List<Offset> positions;
  late Offset food;
  Timer? timer;  // Make timer nullable
  Offset direction = Offset(1, 0);

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  @override
  void dispose() {
    timer?.cancel();  // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _initGame() {
    positions = [
      Offset(squaresPerRow / 2, squaresPerCol / 2),
    ];
    _generateFood();
    timer?.cancel();  // Cancel any existing timer before creating a new one
    timer = Timer.periodic(Duration(milliseconds: 200), _updateGame);
  }

  void _generateFood() {
    food = Offset(
      (DateTime.now().millisecondsSinceEpoch % squaresPerRow).toDouble(),
      (DateTime.now().millisecondsSinceEpoch % squaresPerCol).toDouble(),
    );
  }

  void _updateGame(Timer timer) {
    if (!mounted) return;  // Check if the widget is still mounted
    setState(() {
      _move();
      _checkForFood();
      _checkForCollision();
    });
  }

  void _move() {
    positions.insert(0, positions.first + direction);
    positions.removeLast();
  }

  void _checkForFood() {
    if (positions.first == food) {
      positions.add(positions.last);
      _generateFood();
    }
  }

  void _checkForCollision() {
    if (positions.first.dx < 0 ||
        positions.first.dx >= squaresPerRow ||
        positions.first.dy < 0 ||
        positions.first.dy >= squaresPerCol) {
      _gameOver();
    }

    for (int i = 1; i < positions.length; i++) {
      if (positions[i] == positions.first) {
        _gameOver();
        break;
      }
    }
  }

  void _gameOver() {
    timer?.cancel();
    if (!mounted) return;  // Check if the widget is still mounted
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your score: ${positions.length}'),
        actions: [
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              if (mounted) {  // Check if the widget is still mounted
                setState(() {
                  _initGame();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (direction.dx != 0) {
            setState(() {
              direction = Offset(0, details.delta.dy > 0 ? 1 : -1);
            });
          }
        },
        onHorizontalDragUpdate: (details) {
          if (direction.dy != 0) {
            setState(() {
              direction = Offset(details.delta.dx > 0 ? 1 : -1, 0);
            });
          }
        },
        child: Container(
          width: squaresPerRow * squareSize,
          height: squaresPerCol * squareSize,
          child: CustomPaint(
            painter: GamePainter(positions, food),
          ),
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final List<Offset> positions;
  final Offset food;

  GamePainter(this.positions, this.food);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;

    positions.forEach((position) {
      canvas.drawRect(
        Rect.fromLTWH(
          position.dx * _GamePageState.squareSize,
          position.dy * _GamePageState.squareSize,
          _GamePageState.squareSize,
          _GamePageState.squareSize,
        ),
        paint,
      );
    });

    paint.color = Colors.red;
    canvas.drawRect(
      Rect.fromLTWH(
        food.dx * _GamePageState.squareSize,
        food.dy * _GamePageState.squareSize,
        _GamePageState.squareSize,
        _GamePageState.squareSize,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}