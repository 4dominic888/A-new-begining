import 'package:flame/components.dart';
import 'package:flame/events.dart';

class BlockLayer extends PositionComponent with TapCallbacks{

  BlockLayer(Vector2 size): super(size: size);
}