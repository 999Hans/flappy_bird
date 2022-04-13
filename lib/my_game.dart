import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flappy_bird/game_status.dart';

import 'constants.dart';

class MyGame extends FlameGame with TapDetector {
  SpriteComponent background = SpriteComponent();
  SpriteAnimationComponent bird = SpriteAnimationComponent();
  SpriteComponent floor = SpriteComponent();
  double time = 0.0;
  final int gravity = 900;
  double velocityY = 0.0;
  GameState gameState = GameState.pause;

  SpriteComponent getReadyComponent = SpriteComponent();
  SpriteComponent gameOverComponent = SpriteComponent();

  SpriteComponent pipeUp = SpriteComponent();
  SpriteComponent pipeDown = SpriteComponent();

  double pipeLevel = 1;
  double pipeGap = 4;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(background
      ..sprite = await loadSprite('bg.png')
      ..size = size);
    getReadyComponent
      ..sprite = await loadSprite('sprites.png',
          srcPosition: Vector2(295, 59), srcSize: Vector2(92, 25))
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y / 5)
      ..size = Vector2(92 * 2, 25 * 2);
    add(getReadyComponent);

    gameOverComponent
      ..sprite = await loadSprite('sprites.png',
          srcPosition: Vector2(395, 59), srcSize: Vector2(96, 25))
      ..anchor = Anchor.center
      ..position = Vector2(size.x / 2, size.y / 5)
      ..size = Vector2(92 * 2, 25 * 2);

    var birdSpriteSheet = await images.load('bird.png');
    final spriteSize = Vector2(52, 36.7);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 3, stepTime: 0.1, textureSize: Vector2(17, 12));
    bird = SpriteAnimationComponent.fromFrameData(birdSpriteSheet, spriteData)
      ..anchor = Anchor.center
      ..x = size.x / 2
      ..y = size.y / 2
      ..size = spriteSize;
    add(bird);

    double pipeH = size.y / 12 * 7;
    double pipeW = pipeH / 160 * 26;
    double pipePos = size.x;

    pipeUp
      ..sprite = await loadSprite('pipe_up.png')
      ..position = Vector2(pipePos, pipeH / 7 * (pipeLevel - 7))
      ..size = Vector2(pipeW, pipeH);

    pipeDown
      ..sprite = await loadSprite('pipe_down.png')
      ..position = Vector2(pipePos, pipeH / 7 * (pipeLevel + pipeGap))
      ..size = Vector2(pipeW, pipeH);

    add(pipeUp);
    add(pipeDown);
    add(floor
      ..sprite = await loadSprite('floor.png')
      ..size = Vector2(size.x * 2, size.x * 2 / 168 * 56)
      ..position = Vector2(0, size.y - 56 * 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (gameState) {
      case GameState.pause:
        bird
          ..x = size.x * 0.5
          ..y = size.y * 0.4;
        pipeUp.x = size.x;
        pipeDown.x = size.x;
        break;
      case GameState.play:
        velocityY += (gravity + Game_Speed) * dt;
        bird.y += velocityY * dt / 2;
        floor.x -= (30 + Game_Speed) * dt;
        if (floor.x.abs() > size.x) {
          floor.x = 0;
        }
        if (checkCollison(bird.toRect(), floor.toRect())) {
          gameState = GameState.gameover;
          add(gameOverComponent);
        }

        if (checkCollison(bird.toRect(), pipeUp.toRect())) {
          gameState = GameState.gameover;
          add(gameOverComponent);
        }

        if (checkCollison(bird.toRect(), pipeDown.toRect())) {
          gameState = GameState.gameover;
          add(gameOverComponent);
        }

        pipeUp.x -= dt * (30 + Game_Speed);
        pipeDown.x -= dt * (30 + Game_Speed);
        if (pipeUp.x < -size.y / 12 * 7 / 160 * 26) {
          pipeUp.x = size.x;
          pipeDown.x = size.x;
          pipeLevel = Random().nextInt(5) + 1;
          pipeUp.y = size.y / 12 * (pipeLevel - 7);
          pipeDown.y = size.y / 12 * (pipeLevel + pipeGap);
        }
        break;
      case GameState.gameover:
        break;
    }
  }

  @override
  void onTap() {
    switch (gameState) {
      case GameState.pause:
        gameState = GameState.play;
        velocityY = -500;
        FlameAudio.play('bubble_pop.mp3', volume: 0.5);
        remove(getReadyComponent);
        break;
      case GameState.play:
        velocityY = -500;
        FlameAudio.play('bubble_pop.mp3', volume: 0.5);
        break;
      case GameState.gameover:
        gameState = GameState.pause;
        remove(gameOverComponent);
        add(getReadyComponent);
        break;
    }
  }

  bool checkCollison(Rect Item1, Rect Item2) {
    var intersectedRect = Item1.intersect(Item2);
    return intersectedRect.height > 2 && intersectedRect.width > 2;
  }
}
