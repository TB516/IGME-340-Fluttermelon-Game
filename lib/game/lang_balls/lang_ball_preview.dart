import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/lang_balls/assembly_ball.dart';
import 'package:fluttermelon/game/lang_balls/c_sharp_ball.dart';
import 'package:fluttermelon/game/lang_balls/cpp_ball.dart';
import 'package:fluttermelon/game/lang_balls/flutter_ball.dart';
import 'package:fluttermelon/game/lang_balls/go_ball.dart';
import 'package:fluttermelon/game/lang_balls/javascript_ball.dart';
import 'package:fluttermelon/game/lang_balls/rust_ball.dart';

class LangBallPreview extends SpriteComponent
    with HasGameReference<FluttermelonGame> {
  late final Type _langBallType;
  late final String _spriteName;

  static const spriteMap = {
    AssemblyBall: "Assembly.png",
    CppBall: "C++.png",
    RustBall: "Rust.png",
    GoBall: "Go.png",
    CSharpBall: "C#.png",
    JavascriptBall: "Javascript.png",
    FlutterBall: "Fluter.png",
  };

  LangBallPreview(
      {required Type type, required Vector2 pos, double diameter = 25}) {
    _langBallType = type;

    size = Vector2.all(diameter);
    position = pos;

    _spriteName = spriteMap[_langBallType]!;
  }

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(_spriteName));

    return super.onLoad();
  }

  void setPosition(Vector2 pos) {
    position = pos;
  }

  Type getType() {
    return _langBallType;
  }
}
