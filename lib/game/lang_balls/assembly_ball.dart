import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class AssemblyBall extends Langball {
  AssemblyBall({required super.startPos}) : super(diameter: 25);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("Assembly.png"));

    return super.onLoad();
  }
}
