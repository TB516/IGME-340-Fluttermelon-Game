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

  final List<Langball Function(Vector2)> ballSpawnMethods = [
    (Vector2 pos) {
      return AssemblyBall(startPos: pos);
    },
    (Vector2 pos) {
      return CppBall(startPos: pos);
    },
    (Vector2 pos) {
      return RustBall(startPos: pos);
    },
    (Vector2 pos) {
      return GoBall(startPos: pos);
    },
    (Vector2 pos) {
      return CSharpBall(startPos: pos);
    },
    (Vector2 pos) {
      return JavascriptBall(startPos: pos);
    },
    (Vector2 pos) {
      return FlutterBall(startPos: pos);
    },
  ];
  final Queue<Langball Function(Vector2)> upcomingBallFunctions = Queue();

  final List<Langball> balls = [];

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
      upcomingBallFunctions
          .add(ballSpawnMethods[rng.nextInt(ballSpawnMethods.length)]);
    }
  }

  @override
  void update(double dt) {
    for (int i = 0; i < balls.length; ++i) {
      for (int j = i + 1; j < balls.length; ++j) {
        bool colliding = balls[i].isColliding(balls[j]);

        if (colliding && balls[i].runtimeType == balls[j].runtimeType) {
          print("Combine langballs!");
        } else if (colliding) {
          balls[i].resolveCollision(balls[j]);
        }
      }
    }

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    spawnRandomBall(event.canvasPosition);

    super.onTapDown(event);
  }

  void spawnRandomBall(Vector2 pos) {
    Langball ball = upcomingBallFunctions.removeFirst()(pos);

    balls.add(ball);
    add(ball);

    upcomingBallFunctions
        .add(ballSpawnMethods[rng.nextInt(ballSpawnMethods.length)]);
  }
}
