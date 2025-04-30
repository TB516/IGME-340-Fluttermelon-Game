import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class GoBall extends Langball {
  GoBall({required super.startPos}) : super(diameter: 70, ballMass: 55);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("Go.png"));

    return super.onLoad();
  }
}
