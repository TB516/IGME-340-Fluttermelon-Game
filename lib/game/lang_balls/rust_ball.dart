import 'dart:async';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';

class RustBall extends Langball {
  RustBall({required super.startPos}) : super(ballSize: 110);

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache("Rust.png"));

    return super.onLoad();
  }
}
