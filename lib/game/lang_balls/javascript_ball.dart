import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class JavascriptBall extends Langball {
  JavascriptBall({required super.startPos}) : super(ballSize: 200);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("JavaScript.webp"));

    return super.onLoad();
  }
}
