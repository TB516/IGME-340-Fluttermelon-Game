import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';

final Vector2 gravity = Vector2(0, 100);

abstract class Langball extends SpriteComponent
    with HasGameReference<FluttermelonGame>, HasCollisionDetection {
  Vector2 velocity = Vector2(0, 0);
  double radius = 0;

  Langball({required Vector2 startPos, required double diameter}) {
    position = startPos;

    size = Vector2(diameter, diameter);
    radius = diameter / 2;
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocity += gravity * dt;

    position += velocity * dt;

    if (position.y + radius > game.size.y) {
      position.y = game.size.y - radius;
      velocity.y = 0;
    }
    if (position.x - radius < 0) {
      position.x = 0 + radius;
      velocity.x = 0;
    }
    if (position.x + radius > game.size.x) {
      position.x = game.size.x - radius;
      velocity.x = 0;
    }
  }

  bool isColliding(Langball other) {
    final double distance = (position - other.position).length;
    return distance < (radius + other.radius);
  }

  void resolveCollision(Langball other) {
    final Vector2 delta = position - other.position;

    final double overlap = radius + other.radius - delta.length;
    final Vector2 correction = delta.normalized() * (overlap / 2);

    // Separate the balls to resolve overlap
    position += correction;
    other.position -= correction;

    // Calculate new velocities after collision
    final Vector2 normal = delta.normalized();
    final Vector2 relativeVelocity = velocity - other.velocity;
    final double velocityAlongNormal = relativeVelocity.dot(normal);

    if (velocityAlongNormal < 0) {
      final double restitution = 0.8; // Coefficient of restitution (bounciness)
      final double impulseMagnitude = -(1 + restitution) * velocityAlongNormal;

      final Vector2 impulse = normal * impulseMagnitude;
      velocity += impulse;
      other.velocity -= impulse;
    }
  }
}
