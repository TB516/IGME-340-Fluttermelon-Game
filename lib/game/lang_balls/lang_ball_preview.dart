import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball_types.dart';

class LangBallPreview extends SpriteComponent
    with HasGameReference<FluttermelonGame> {
  late final LangBallTypes _langBallType;

  LangBallPreview(
      {required LangBallTypes type,
      required Vector2 pos,
      double diameter = 25}) {
    _langBallType = type;

    size = Vector2.all(diameter);
    position = pos;
  }

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(_langBallType.file));

    return super.onLoad();
  }

  void setPosition(Vector2 pos) {
    position = pos;
  }

  LangBallTypes getType() {
    return _langBallType;
  }
}
