import 'dart:collection';
import 'dart:math';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:fluttermelon/game/lang_balls/assembly_ball.dart';
import 'package:fluttermelon/game/lang_balls/c_sharp_ball.dart';
import 'package:fluttermelon/game/lang_balls/cpp_ball.dart';
import 'package:fluttermelon/game/lang_balls/flutter_ball.dart';
import 'package:fluttermelon/game/lang_balls/go_ball.dart';
import 'package:fluttermelon/game/lang_balls/javascript_ball.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball_preview.dart';
import 'package:fluttermelon/game/lang_balls/rust_ball.dart';

class FluttermelonGame extends FlameGame with TapCallbacks {
  final Random _rng = Random();

  final List<Type> _ballTypes = [
    AssemblyBall,
    CppBall,
    RustBall,
    GoBall,
    CSharpBall,
    JavascriptBall,
    FlutterBall
  ];
  final Map<Type, Langball Function(Vector2)> _ballSpawnMethods = {
    AssemblyBall: (Vector2 pos) {
      return AssemblyBall(startPos: pos);
    },
    CppBall: (Vector2 pos) {
      return CppBall(startPos: pos);
    },
    RustBall: (Vector2 pos) {
      return RustBall(startPos: pos);
    },
    GoBall: (Vector2 pos) {
      return GoBall(startPos: pos);
    },
    CSharpBall: (Vector2 pos) {
      return CSharpBall(startPos: pos);
    },
    JavascriptBall: (Vector2 pos) {
      return JavascriptBall(startPos: pos);
    },
    FlutterBall: (Vector2 pos) {
      return FlutterBall(startPos: pos);
    },
  };

  static const double _previewSize = 25;
  static const double _previewSpacer = 10;
  static const int _maxPreviewCount = 5;
  int _curPreviewCount = 1;
  final Queue<LangBallPreview> _upcomingBallPreviews = Queue();

  static const double _dropHeight = 50;
  static const int _maxSpawnOffset = 2;

  final List<Langball> _balls = [];
  final Map<Langball, Langball> _fusionPairs = {};

  double _score = 0;

  bool _canDrop = true;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load images
    await images.loadAll([
      "Assembly.png",
      "C#.png",
      "C++.png",
      "Flutter.png",
      "Go.png",
      "Javascript.png",
      "Rust.png",
    ]);

    for (int i = 0; i < _curPreviewCount; i++) {
      addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
    }
  }

  @override
  void update(double dt) {
    movementCheck();

    manageCollisions();

    fusePairs();

    _fusionPairs.clear();

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_canDrop) {
      spawnNextBall(Vector2(event.canvasPosition.x, _dropHeight));

      addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
      _canDrop = false;
    }

    super.onTapDown(event);
  }

  /// Adds new preview ball to the screen and shifts all current previews over
  void addNewPreviewBall(int spriteIndex) {
    /// Move over all current previews
    int curNumPreviews = _upcomingBallPreviews.length;

    for (int i = 0; i < curNumPreviews; ++i) {
      LangBallPreview prev = _upcomingBallPreviews.removeFirst();

      prev.position.x += _previewSize + _previewSpacer;

      _upcomingBallPreviews.add(prev);
    }

    /// Add in a new preview
    Vector2 position = Vector2(0, _previewSize / 2);

    LangBallPreview preview = LangBallPreview(
        type: _ballTypes[spriteIndex], pos: position, diameter: _previewSize);

    _upcomingBallPreviews.add(preview);
    add(preview);
  }

  /// Increases the max number of previews and adds a new preview ball to the screen
  void increasePreviewCount() {
    _curPreviewCount++;

    addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
  }

  /// Checks if the current preview count can be increased
  bool canIncreasePreviewCount() {
    return _curPreviewCount + 1 == _maxPreviewCount;
  }

  /// Dequeues the next preview and instantiates a new ball of the same type
  void spawnNextBall(Vector2 pos) {
    LangBallPreview nextBallPrev = _upcomingBallPreviews.removeFirst();
    remove(nextBallPrev);

    Langball ball = _ballSpawnMethods[nextBallPrev.getType()]!(pos);

    _balls.add(ball);
    add(ball);
  }

  /// Check if any balls are considered falling and manage if dropping is allowed
  void movementCheck() {
    for (int i = 0; i < _balls.length; ++i) {
      if (_balls[i].isFalling()) {
        _canDrop = false;
        return;
      }
    }

    _canDrop = true;
  }

  /// Handle collisions between balls and mark ball pairs for fusion if needed
  void manageCollisions() {
    for (int i = 0; i < _balls.length; ++i) {
      for (int j = i + 1; j < _balls.length; ++j) {
        bool colliding = _balls[i].isColliding(_balls[j]);

        if (colliding &&
            _balls[i].runtimeType == _balls[j].runtimeType &&
            !_fusionPairs.containsKey(_balls[i]) &&
            !_fusionPairs.containsValue(_balls[j]) &&
            !_fusionPairs.containsKey(_balls[j])) {
          _fusionPairs[_balls[i]] = _balls[j];
        } else if (colliding) {
          _balls[i].resolveCollision(_balls[j]);
        }
      }
    }
  }

  /// Fuses a pair of balls into a higher level ball
  void fusePairs() {
    for (MapEntry<Langball, Langball> pair in _fusionPairs.entries) {
      _balls.remove(pair.key);
      _balls.remove(pair.value);
      remove(pair.key);
      remove(pair.value);

      _score += pair.key.getScoreValue();

      int curTypeIndex = _ballTypes.indexOf(pair.key.runtimeType);

      if (curTypeIndex + 1 == _ballTypes.length) return;

      Langball newBall =
          _ballSpawnMethods[_ballTypes[curTypeIndex + 1]]!(pair.key.position);

      _balls.add(newBall);
      add(newBall);
    }
  }
}
