import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async{
    super.onLoad();
    SpriteComponent background = SpriteComponent();
    SpriteAnimationComponent bird = SpriteAnimationComponent();
    

    add(background
    ..sprite = await loadSprite('bg.png')
    ..size = size);

    var spriteSheet = await images.load('bird.png');
    final spriteSize = Vector2(52, 36.7);
    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(amount: 3 , stepTime: 0.1, textureSize: Vector2(17, 12));
    bird = SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
    ..x = 100
    ..y = 100
    ..size = spriteSize;

    add(bird);

  }
}