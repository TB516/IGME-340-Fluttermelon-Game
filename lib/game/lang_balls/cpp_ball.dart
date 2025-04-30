import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class CppBall extends Langball {
  CppBall({required super.startPos}) : super(diameter: 40, ballMass: 25);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("C++.png"));

    return super.onLoad();
  }
}
