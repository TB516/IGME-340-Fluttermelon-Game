import 'dart:math';
import 'package:flame/components.dart';
import 'package:fluttermelon/game/game.dart';

class Language extends SpriteComponent with HasGameReference<FluttermelonGame> {
  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.images.fromCache('Assembly.png'));
    anchor = Anchor.center;
    size = Vector2(100, 100);

    // Testing for flame game state
    Random random = Random();
    double x = random.nextDouble() * (game.size.x - size.x);
    double y = random.nextDouble() * (game.size.y - size.y);

    position = Vector2(x, y);
  }
}
