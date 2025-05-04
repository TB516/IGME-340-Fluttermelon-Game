import 'dart:async';

import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball_types.dart';

final Vector2 gravity = Vector2(0, 100);
final double rotationAmount = .1;

class Langball extends SpriteComponent
    with HasGameReference<FluttermelonGame>, HasCollisionDetection {
  Vector2 _velocity = Vector2(0, 0);
  late final LangBallTypes _type;
  late final double _radius;
  late final double _mass;

  Langball({required LangBallTypes type, required Vector2 startPos}) {
    _type = type;

    position = startPos;

    size = Vector2(type.diameter, type.diameter);
    anchor = Anchor.center;

    _radius = type.diameter / 2;
    _mass = type.mass;
  }

  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache(_type.file));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _velocity += gravity * dt;

    position += _velocity * dt;

    if (_velocity.x != 0) {
      angle += _velocity.x * rotationAmount * dt;
    }

    if (position.y + _radius > game.size.y) {
      position.y = game.size.y - _radius;
      _velocity.y = 0;
    }
    if (position.x - _radius < 0) {
      position.x = 0 + _radius;
      _velocity.x = 0;
    }
    if (position.x + _radius > game.size.x) {
      position.x = game.size.x - _radius;
      _velocity.x = 0;
    }
  }

  LangBallTypes getType() {
    return _type;
  }

  bool isFalling() {
    /// Offset value to account for collision resolution
    return _velocity.y > 25;
  }

  double getScoreValue() {
    return _mass;
  }

  bool isColliding(Langball other) {
    final double distance = (position - other.position).length;
    return distance < (_radius + other._radius);
  }

  void resolveCollision(Langball other) {
    final Vector2 delta = position - other.position;

    final double overlap = _radius + other._radius - delta.length;
    final Vector2 correction = delta.normalized() * (overlap / 2);

    // Separate the balls to resolve overlap, considering mass
    position += correction * (other._mass / (_mass + other._mass));
    other.position -= correction * (_mass / (_mass + other._mass));

    // Calculate new velocities after collision
    final Vector2 normal = delta.normalized();
    final Vector2 relativeVelocity = _velocity - other._velocity;
    final double velocityAlongNormal = relativeVelocity.dot(normal);

    if (velocityAlongNormal < 0) {
      final double restitution = 0.8; // Coefficient of restitution (bounciness)
      final double impulseMagnitude = -(1 + restitution) *
          velocityAlongNormal /
          (1 / _mass + 1 / other._mass);

      final Vector2 impulse = normal * impulseMagnitude;
      _velocity += impulse / _mass;
      other._velocity -= impulse / other._mass;
    }
  }
}
