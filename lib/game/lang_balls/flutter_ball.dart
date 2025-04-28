import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class FlutterBall extends Langball {
  FlutterBall({required super.startPos}) : super(ballSize: 260);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("Flutter.png"));

    return super.onLoad();
  }
}
