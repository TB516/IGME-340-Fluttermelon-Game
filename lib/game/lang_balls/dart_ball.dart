import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class DartBall extends Langball {
  DartBall({required super.startPos}) : super(ballSize: 230);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("Dart.png"));

    return super.onLoad();
  }
}
