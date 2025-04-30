import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';

final Vector2 gravity = Vector2(0, 100);

abstract class Langball extends SpriteComponent
    with HasGameReference<FluttermelonGame>, HasCollisionDetection {
  Vector2 velocity = Vector2(0, 0);

  Langball({required Vector2 startPos, required double diameter}) {
    position = startPos;

    size = Vector2(diameter, diameter);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gravity * dt;

    position += velocity * dt;

    if (position.y + size.y / 2 > game.size.y) {
      position.y = game.size.y - size.y / 2;
      velocity.y = 0;
    }
  }
}
