import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class CSharpBall extends Langball {
  CSharpBall({required super.startPos}) : super(diameter: 85);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("C#.png"));

    return super.onLoad();
  }
}
