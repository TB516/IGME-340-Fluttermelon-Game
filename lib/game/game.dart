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

  final Queue<Type> upcomingBallTypes = Queue();
  final Map<Langball, Langball> fusionPairs = {};

  final List<Langball> balls = [];
  double score = 0;

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

    for (int i = 0; i < 5; i++) {
      upcomingBallTypes.add(ballTypes[rng.nextInt(ballTypes.length)]);
    }
  }

  @override
  void update(double dt) {
    manageCollisions();

    fusePairs();

    fusionPairs.clear();

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    spawnNextBall(Vector2(event.canvasPosition.x, 50));

    super.onTapDown(event);
  }

  void spawnNextBall(Vector2 pos) {
    Langball ball = ballSpawnMethods[upcomingBallTypes.removeFirst()]!(pos);

    balls.add(ball);
    add(ball);

    upcomingBallTypes.add(ballTypes[rng.nextInt(ballTypes.length)]);
  }

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

  void fusePairs() {
    for (MapEntry<Langball, Langball> pair in fusionPairs.entries) {
      balls.remove(pair.key);
      balls.remove(pair.value);
      remove(pair.key);
      remove(pair.value);

      score += pair.key.mass * 10;

      int curTypeIndex = ballTypes.indexOf(pair.key.runtimeType);

      if (curTypeIndex + 1 == ballTypes.length) return;

      Langball newBall =
          ballSpawnMethods[ballTypes[curTypeIndex + 1]]!(pair.key.position);

      balls.add(newBall);
      add(newBall);
    }
  }
}
