import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';

abstract class Langball extends SpriteComponent
    with HasGameReference<FluttermelonGame>, CollisionCallbacks {
  final Vector2 velocity = Vector2(0, 50);

  Langball({required Vector2 startPos, required double ballSize}) {
    position = startPos;

    size = Vector2(ballSize / 2, ballSize / 2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Simple floor collision
    if (position.y + size.y > game.size.y) {
      position.y = game.size.y - size.y;
      velocity.y = 0; // Stop moving down
    }
  }
}
