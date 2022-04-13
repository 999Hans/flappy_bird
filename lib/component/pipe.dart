import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flappy_bird/my_game.dart';

class PipeSet extends Component {
  Vector2 size = MyGame().size;
  double pipeH = MyGame().size.y / 12 * 7;
  double pipeW = MyGame().size.y / 12 * 7 / 160 * 7;

  SpriteComponent pipeUp = SpriteComponent();
  SpriteComponent pipeDown = SpriteComponent();

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    double pipeGap = 4;

    // final pipeUpImage = await Flame.images.load('pipeUp.png');

    pipeUp
      ..sprite = Sprite(pipeUpImage)
      ..position = Vector2(size[1] / 2, pipeH / 7 * -6)
      ..size = Vector2(pipeW, pipeH);

    // // final pipeDownImage = await Flame.images.load('pipeDown.png');
    pipeDown.sprite = Sprite(pipeDownImage);

    pipeDown
      ..sprite = Sprite(pipeDownImage)
      ..position = Vector2(size[1] / 2, pipeH / 7 * 5)
      ..size = Vector2(pipeW, pipeH);
  }
}
