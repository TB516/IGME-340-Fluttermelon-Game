import 'package:flame/game.dart';
import 'package:fluttermelon/game/lang_balls/assembly_ball.dart';
import 'package:fluttermelon/game/lang_balls/c_sharp_ball.dart';
import 'package:fluttermelon/game/lang_balls/cpp_ball.dart';
import 'package:fluttermelon/game/lang_balls/flutter_ball.dart';
import 'package:fluttermelon/game/lang_balls/go_ball.dart';
import 'package:fluttermelon/game/lang_balls/javascript_ball.dart';
import 'package:fluttermelon/game/lang_balls/rust_ball.dart';

class FluttermelonGame extends FlameGame {
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

    add(FlutterBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
    // add(JavascriptBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
    // add(CSharpBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
    add(GoBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
    // add(RustBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
    // add(CppBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
    // add(AssemblyBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
  }
}
