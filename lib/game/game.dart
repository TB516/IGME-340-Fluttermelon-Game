import 'dart:collection';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
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

  static final TextStyle _textStyle =
      TextStyle(fontFamily: "Helvetica", fontWeight: FontWeight.w700);
  static final TextPaint _textPaint = TextPaint(style: _textStyle);
  late final TextComponent _scoreTextComponent;
  late final TextComponent _highScoreTextComponent;
  int _score = 0;
  late final int _highScore;
  int _scoreMultiplier = 1;

  static const double _previewSize = 25;
  static const double _previewSpacer = 10;
  static const int _maxPreviewCount = 5;
  int _curPreviewCount = 1;
  final Queue<LangBallPreview> _upcomingBallPreviews = Queue();

  static const double _dropHeight = 50;
  static const int _maxSpawnOffset = 2;

  final List<Langball> _balls = [];
  final Map<Langball, Langball> _fusionPairs = {};

  static const _minBallTypesLoaded = 5;
  static const _maxScoreMultiplier = 6;
  bool _canDrop = true;

  static const int _gameOverLine = 45;

  late final Function _resetGame;

  FluttermelonGame(
      {required VoidCallback resetGameCallback, required int highScore}) {
    _resetGame = resetGameCallback;
    _highScore = highScore;
  }

  @override
  Color backgroundColor() => const Color.fromARGB(255, 25, 25, 25);

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

    await FlameAudio.audioCache.loadAll(['drop.wav', 'labyrinth.mp3']);

    for (int i = 0; i < _curPreviewCount; i++) {
      addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
    }

    _scoreTextComponent =
        TextComponent(text: "Score: $_score", textRenderer: _textPaint);

    _highScoreTextComponent = TextComponent(
        text: "High Score: $_highScore", textRenderer: _textPaint);

    _scoreTextComponent.position = Vector2(
        size.x - _scoreTextComponent.size.x - _previewSpacer,
        _previewSpacer + _scoreTextComponent.size.y);

    _highScoreTextComponent.position = Vector2(
        size.x - _highScoreTextComponent.size.x - _previewSpacer,
        (_previewSpacer * 2) +
            _scoreTextComponent.size.y +
            _highScoreTextComponent.size.y);

    add(_scoreTextComponent);
    add(_highScoreTextComponent);
  }

  @override
  void update(double dt) {
    gameOverCheck();

    movementCheck();

    manageCollisions();

    fusePairs();

    _fusionPairs.clear();

    super.update(dt);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_canDrop) {
      FlameAudio.play('drop.wav');

      spawnNextBall(Vector2(event.canvasPosition.x, _dropHeight));

      addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
      _canDrop = false;
    }

    super.onTapDown(event);
  }

  /// Checks to see if the game is over
  void gameOverCheck() {
    for (int i = 0; i < _balls.length; ++i) {
      if (_balls[i].position.y <= _gameOverLine) {
        pauseEngine();

        showDialog(
          context: buildContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Over', style: _textStyle),
              content: Text('Score: $_score\nHigh Score: $_highScore',
                  style: _textStyle),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Play Again',
                  ),
                ),
              ],
            );
          },
        ).then((_) {
          _resetGame(score: _score);
        });
        return;
      }
    }
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

      addScore(pair.key.getScoreValue().floor() * _scoreMultiplier);

      int curTypeIndex = _ballTypes.indexOf(pair.key.getType());

      if (curTypeIndex + 1 == _ballTypes.length) return;

      Langball newBall = Langball(
          type: _ballTypes[curTypeIndex + 1], startPos: pair.key.position);

      _balls.add(newBall);
      add(newBall);
    }
  }

  /// Adds score and updates the text
  void addScore(int amount) {
    _score += amount;
    _scoreTextComponent.text = 'Score: $_score';
    _scoreTextComponent.position = Vector2(
        size.x - _scoreTextComponent.size.x - _previewSpacer,
        _previewSpacer + _scoreTextComponent.size.y);
  }

  /// Checks if score multiplier can be upgraded
  bool canUpgradeScoreMultiplier() {
    return _scoreMultiplier + 1 <= _maxScoreMultiplier;
  }

  /// Increases score multiplier by 1
  void upgradeScoreMultiplier() {
    _scoreMultiplier++;
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
    Vector2 position = Vector2(_previewSpacer, _previewSize);

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

  /// Checks if purchase can be made
  bool canPurchase(int cost) {
    return _score - cost >= 0;
  }

  /// Reduces score by purchase amount
  void chargePurchase(int amount) {
    addScore(-amount);
  }

  /// Checks if the current preview count can be increased
  bool canIncreasePreviewCount() {
    return _curPreviewCount + 1 <= _maxPreviewCount;
  }

  /// Increases the max number of previews and adds a new preview ball to the screen
  void increasePreviewCount() {
    _curPreviewCount++;

    addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
  }

  /// Checks if the min amount of balls are in the list
  bool canRemoveBallType() {
    return _ballTypes.length - 1 >= _minBallTypesLoaded;
  }

  /// Removes ball type from game and ball pool
  void removeBallType(LangBallTypes type) {
    _ballTypes.remove(type);

    /// Remove any in play balls of the same type
    for (int i = _balls.length - 1; i >= 0; --i) {
      if (_balls[i].getType() == type) {
        remove(_balls.removeAt(i));
      }
    }

    List<LangBallPreview> tempList = [];

    /// Remove all preview balls and either discard or store to add again
    for (int i = 0; i < _curPreviewCount; ++i) {
      if (_upcomingBallPreviews.first.getType() == type) {
        remove(_upcomingBallPreviews.removeFirst());
      } else {
        LangBallPreview prev = _upcomingBallPreviews.removeFirst();
        remove(prev);
        tempList.add(prev);
      }
    }

    /// Add back the removed preview balls
    for (int i = 0; i < tempList.length; ++i) {
      addNewPreviewBall(_ballTypes.indexOf(tempList[i].getType()));
    }

    /// Repopulate preview list with new balls
    while (_upcomingBallPreviews.length != _curPreviewCount) {
      addNewPreviewBall(_rng.nextInt(_ballTypes.length - _maxSpawnOffset));
    }
  }
}
