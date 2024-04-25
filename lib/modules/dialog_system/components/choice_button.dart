import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

//? When codigo repetido
//TODO: Aplicar herencia o algo asi.
class ChoiceButton extends ButtonComponent{

  final String text;
  void Function() onAction;

  ChoiceButton(this.text, {
    super.size,
    required this.onAction, super.position,
  }) : super(
    button: BorderedButtonBackground(const Color.fromRGBO(0, 0, 0, 0.4))..decorator.replaceLast(PaintDecorator.blur(3.0)),
    buttonDown: BorderedButtonBackground(const Color.fromRGBO(255, 255, 255, 0.1))..decorator.replaceLast(PaintDecorator.blur(3.0)),
    onReleased: onAction,
    children: [
      TextComponent(
        text: text,
        textRenderer: TextPaint(style: TextStyle(
          fontSize: 0.44* size!.y,
          fontWeight: FontWeight.w400,
          color:  Colors.white,
          shadows: const [
            Shadow(blurRadius: 20, offset: Offset.zero, color: Colors.black)
          ])),
        position: size / 2.0,
        anchor: Anchor.center,
        priority: 1
      )
    ]
  );

  @override
  void onTapDown(TapDownEvent event) {
    onReleased;
    super.onTapDown(event);
  }
}


class BorderedButtonBackground extends PositionComponent with HasAncestor<ChoiceButton>{
  final _paintFill = Paint()..style = PaintingStyle.fill;
  late double cornerRadius;

  BorderedButtonBackground(Color color) {
    _paintFill.color = color;
  }

  @override
  void onMount() {
    super.onMount();
    size = ancestor.size;
    cornerRadius = 0.6 * size.y;
    
    _paintFill.strokeWidth = 0.05 * size.y;
  }

  late final _background = RRect.fromRectAndRadius(
    size.toRect(),
    Radius.circular(cornerRadius),
  );

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(_background, _paintFill);
  }
}