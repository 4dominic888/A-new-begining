import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/src/events/messages/tap_down_event.dart';

class ForwardNextButtonComponent extends ButtonComponent{

  final void Function() onLongPressed;

  ForwardNextButtonComponent({
    required super.size,
    required super.onReleased,
    required super.onPressed,
    required this.onLongPressed
  }) : super(button: PositionComponent());

  @override
  void onLongTapDown(TapDownEvent event) {
    onLongPressed.call();
    super.onLongTapDown(event);
  }

}