import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';

abstract class Langball extends SpriteComponent
    with HasGameReference<FluttermelonGame> {
  final String spriteName;

  Langball(
      {required this.spriteName,
      required Vector2 startPos,
      required double ballSize}) {
    position = startPos;

    size = Vector2(ballSize, ballSize);
    anchor = Anchor.center;
  }

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(spriteName));

    return super.onLoad();
  }
}
