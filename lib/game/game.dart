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
  final Random rng = Random();

  final List<Type> ballTypes = [
    AssemblyBall,
    CppBall,
    RustBall,
    GoBall,
    CSharpBall,
    JavascriptBall,
    FlutterBall
  ];
  final Map<Type, Langball Function(Vector2)> ballSpawnMethods = {
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

  static const double previewSize = 25;
  static const double previewSpacer = 10;
  int curPreviewCount = 5;
  final Queue<LangBallPreview> upcomingBallPreviews = Queue();

  static const double dropHeight = 50;
  static const int maxSpawnOffset = 2;

  final List<Langball> balls = [];
  final Map<Langball, Langball> fusionPairs = {};

  double score = 0;

  bool canDrop = true;

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

    for (int i = 0; i < curPreviewCount; i++) {
      addNewPreviewBall(rng.nextInt(ballTypes.length - maxSpawnOffset));
    }
  }

  @override
  void update(double dt) {
    movementCheck();

    manageCollisions();

    fusePairs();

    fusionPairs.clear();

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (canDrop) {
      spawnNextBall(Vector2(event.canvasPosition.x, dropHeight));

      addNewPreviewBall(rng.nextInt(ballTypes.length - maxSpawnOffset));
      canDrop = false;
    }

    super.onTapDown(event);
  }

  /// Adds new preview ball to the screen and shifts all current previews over
  void addNewPreviewBall(int spriteIndex) {
    /// Move over all current previews
    int curNumPreviews = upcomingBallPreviews.length;

    for (int i = 0; i < curNumPreviews; ++i) {
      LangBallPreview prev = upcomingBallPreviews.removeFirst();

      prev.position.x += previewSize + previewSpacer;

      upcomingBallPreviews.add(prev);
    }

    /// Add in a new preview
    Vector2 position = Vector2(0, previewSize / 2);

    LangBallPreview preview = LangBallPreview(
        type: ballTypes[spriteIndex], pos: position, diameter: previewSize);

    upcomingBallPreviews.add(preview);
    add(preview);
  }

  /// Increases the max number of previews and adds a new preview ball to the screen
  void increasePreviewCount() {
    curPreviewCount++;

    addNewPreviewBall(rng.nextInt(ballTypes.length - maxSpawnOffset));
  }

  /// Dequeues the next preview and instantiates a new ball of the same type
  void spawnNextBall(Vector2 pos) {
    LangBallPreview nextBallPrev = upcomingBallPreviews.removeFirst();
    remove(nextBallPrev);

    Langball ball = ballSpawnMethods[nextBallPrev.getType()]!(pos);

    balls.add(ball);
    add(ball);
  }

  /// Check if any balls are considered falling and manage if dropping is allowed
  void movementCheck() {
    for (int i = 0; i < balls.length; ++i) {
      if (balls[i].isFalling()) {
        canDrop = false;
        return;
      }
    }

    canDrop = true;
  }

  /// Handle collisions between balls and mark ball pairs for fusion if needed
  void manageCollisions() {
    for (int i = 0; i < balls.length; ++i) {
      for (int j = i + 1; j < balls.length; ++j) {
        bool colliding = balls[i].isColliding(balls[j]);

        if (colliding &&
            balls[i].runtimeType == balls[j].runtimeType &&
            !fusionPairs.containsKey(balls[i]) &&
            !fusionPairs.containsValue(balls[j]) &&
            !fusionPairs.containsKey(balls[j])) {
          fusionPairs[balls[i]] = balls[j];
        } else if (colliding) {
          balls[i].resolveCollision(balls[j]);
        }
      }
    }
  }

  /// Fuses a pair of balls into a higher level ball
  void fusePairs() {
    for (MapEntry<Langball, Langball> pair in fusionPairs.entries) {
      balls.remove(pair.key);
      balls.remove(pair.value);
      remove(pair.key);
      remove(pair.value);

      score += pair.key.getScoreValue();

      int curTypeIndex = ballTypes.indexOf(pair.key.runtimeType);

      if (curTypeIndex + 1 == ballTypes.length) return;

      Langball newBall =
          ballSpawnMethods[ballTypes[curTypeIndex + 1]]!(pair.key.position);

      balls.add(newBall);
      add(newBall);
    }
  }
}
