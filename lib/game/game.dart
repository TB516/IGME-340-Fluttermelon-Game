import 'package:flame/game.dart';
import 'package:fluttermelon/game/language.dart';

class FluttermelonGame extends FlameGame {
  late Language fruit;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    print("Loading images...");

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

    fruit = Language();
    add(fruit);
  }
}
