import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/flame_audio.dart';

class MyGame extends FlameGame with TapDetector {
  SpriteComponent background = SpriteComponent();
  SpriteAnimationComponent bird = SpriteAnimationComponent();
  SpriteComponent floor = SpriteComponent();
  double time = 0.0;
  final int gravity = 900;
  double velocityY = 0.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(background
      ..sprite = await loadSprite('bg.png')
      ..size = size);

    var spriteSheet = await images.load('bird.png');
    final spriteSize = Vector2(52, 36.7);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 3, stepTime: 0.1, textureSize: Vector2(17, 12));
    bird = SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
      ..anchor = Anchor.center
      ..x = size.x / 2
      ..y = size.y / 2
      ..size = spriteSize;
    add(bird);

    add(floor
      ..sprite = await loadSprite('floor.png')
      ..size = Vector2(size.x * 2, size.x * 2 / 168 * 56)
      ..position = Vector2(0, size.y - 56 * 2));
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocityY += gravity * dt;
    bird.y += velocityY * dt / 2;
    floor.x -= 100 * dt;
    if (floor.x.abs() > size.x) {
      floor.x = 0;
    }

    print(checkCollison(bird.toRect(), floor.toRect()));
  }

  @override
  void onTap() {
    velocityY = -500;
    FlameAudio.play('bubble_pop.mp3', volume: 0.5);
  }

  bool checkCollison(Rect Item1, Rect Item2) {
    var intersectedRect = Item1.intersect(Item2);
    return intersectedRect.height > 0 && intersectedRect.width > 0;
  }
}
