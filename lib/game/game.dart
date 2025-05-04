import 'dart:collection';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball_preview.dart';
import 'package:fluttermelon/game/lang_balls/lang_ball_types.dart';

class FluttermelonGame extends FlameGame with TapCallbacks {
  final Random _rng = Random();

  final List<LangBallTypes> _ballTypes = [
    LangBallTypes.assembly,
    LangBallTypes.cpp,
    LangBallTypes.rust,
    LangBallTypes.go,
    LangBallTypes.csharp,
    LangBallTypes.javascript,
    LangBallTypes.flutter
  ];

  static final TextPaint _textPaint = TextPaint(
      style: TextStyle(fontFamily: "Helvetica", fontWeight: FontWeight.w700));
  late final TextComponent _scoreTextComponent;
  double _score = 0;

  static const double _previewSize = 25;
  static const double _previewSpacer = 10;
  static const int _maxPreviewCount = 5;
  int _curPreviewCount = 5;
  final Queue<LangBallPreview> _upcomingBallPreviews = Queue();

  static const double _dropHeight = 50;
  static const int _maxSpawnOffset = 2;

  final List<Langball> _balls = [];
  final Map<Langball, Langball> _fusionPairs = {};

  bool _canDrop = true;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load images
    await images.loadAll([
      "Assembly.png",
      "C#.png",
      "C++.png",
      "Flutter.png",
      "Go.png",
      "Javascript.png",
      "Rust.png",
    ]);

    for (int i = 0; i < _curPreviewCount; i++) {
      addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
    }

    _scoreTextComponent =
        TextComponent(text: "Score: $_score", textRenderer: _textPaint);

    _scoreTextComponent.position = Vector2(
        size.x - _scoreTextComponent.size.x - _previewSpacer,
        _scoreTextComponent.size.y);

    add(_scoreTextComponent);
  }

  @override
  void update(double dt) {
    movementCheck();

    manageCollisions();

    fusePairs();

    _fusionPairs.clear();

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_canDrop) {
      spawnNextBall(Vector2(event.canvasPosition.x, _dropHeight));

      addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
      _canDrop = false;
    }

    super.onTapDown(event);
  }

  /// Adds score and updates the text
  void addScore(double amount) {
    _score += amount;
    _scoreTextComponent.text = 'Score: $_score';
    _scoreTextComponent.position = Vector2(
        size.x - _scoreTextComponent.size.x - _previewSpacer,
        _scoreTextComponent.size.y);
  }

  /// Adds new preview ball to the screen and shifts all current previews over
  void addNewPreviewBall(int spriteIndex) {
    /// Move over all current previews
    int curNumPreviews = _upcomingBallPreviews.length;

    for (int i = 0; i < curNumPreviews; ++i) {
      LangBallPreview prev = _upcomingBallPreviews.removeFirst();

      prev.position.x += _previewSize + _previewSpacer;

      _upcomingBallPreviews.add(prev);
    }

    /// Add in a new preview
    Vector2 position = Vector2(_previewSpacer, _previewSize / 2);

    LangBallPreview preview = LangBallPreview(
        type: _ballTypes[spriteIndex], pos: position, diameter: _previewSize);

    _upcomingBallPreviews.add(preview);
    add(preview);
  }

  /// Dequeues the next preview and instantiates a new ball of the same type
  void spawnNextBall(Vector2 pos) {
    LangBallPreview nextBallPrev = _upcomingBallPreviews.removeFirst();
    remove(nextBallPrev);

    Langball ball = Langball(type: nextBallPrev.getType(), startPos: pos);

    _balls.add(ball);
    add(ball);
  }

  /// Check if any balls are considered falling and manage if dropping is allowed
  void movementCheck() {
    for (int i = 0; i < _balls.length; ++i) {
      if (_balls[i].isFalling()) {
        _canDrop = false;
        return;
      }
    }

    _canDrop = true;
  }

  /// Handle collisions between balls and mark ball pairs for fusion if needed
  void manageCollisions() {
    for (int i = 0; i < _balls.length; ++i) {
      for (int j = i + 1; j < _balls.length; ++j) {
        bool colliding = _balls[i].isColliding(_balls[j]);

        if (colliding &&
            _balls[i].getType() == _balls[j].getType() &&
            !_fusionPairs.containsKey(_balls[i]) &&
            !_fusionPairs.containsValue(_balls[j]) &&
            !_fusionPairs.containsKey(_balls[j])) {
          _fusionPairs[_balls[i]] = _balls[j];
        } else if (colliding) {
          _balls[i].resolveCollision(_balls[j]);
        }
      }
    }
  }

  /// Fuses a pair of balls into a higher level ball
  void fusePairs() {
    for (MapEntry<Langball, Langball> pair in _fusionPairs.entries) {
      _balls.remove(pair.key);
      _balls.remove(pair.value);
      remove(pair.key);
      remove(pair.value);

      addScore(pair.key.getScoreValue());

      int curTypeIndex = _ballTypes.indexOf(pair.key.getType());

      if (curTypeIndex + 1 == _ballTypes.length) return;

      Langball newBall = Langball(
          type: _ballTypes[curTypeIndex + 1], startPos: pair.key.position);

      _balls.add(newBall);
      add(newBall);
    }
  }

  /// Checks if purchase can be made
  bool canPurchase(double cost) {
    return _score - cost >= 0;
  }

  /// Reduces score by purchase amount
  void chargePurchase(double amount) {
    _score -= amount;
  }

  /// Checks if the current preview count can be increased
  bool canIncreasePreviewCount() {
    return _curPreviewCount + 1 == _maxPreviewCount;
  }

  /// Increases the max number of previews and adds a new preview ball to the screen
  void increasePreviewCount() {
    _curPreviewCount++;

    addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
  }

  /// Removes ball type from game and ball pool
  void removeBallType(LangBallTypes type) {
    _ballTypes.remove(type);

    for (int i = _balls.length; i >= 0; --i) {
      if (_balls[i].getType() == type) {
        remove(_balls.removeAt(i));
      }
    }
  }
}
