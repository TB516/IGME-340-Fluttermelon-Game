import 'package:flame/game.dart';
import 'package:fluttermelon/game/lang_balls/flutter_ball.dart';

class FluttermelonGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load images
    await images.loadAll([
      "Assembly.png",
      "C#.png",
      "C++.png",
      "Dart.png",
      "Flutter.png",
      "Go.png",
      "JavaScript.webp",
      "Rust.png"
    ]);

    add(FlutterBall(startPos: Vector2(canvasSize.x / 2, canvasSize.y / 2)));
  }
}
