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
    SpriteAnimationComponent bird = SpriteAnimationComponent();;
    

    add(background
    ..sprite = await loadSprite('bg.png')
    ..size = size);
    
    add(bird
    ..sprite = await loadSpriteAnimation("bir")
    );

  }
}