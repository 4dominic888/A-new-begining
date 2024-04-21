import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class ButtonBackground extends PositionComponent with HasAncestor<MainVNButton>{
  final _paintFill = Paint()..style = PaintingStyle.fill;

  late double cornerRadius;

  ButtonBackground(Color color) {
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

class MainVNButton extends ButtonComponent{
  
  final String text;

  MainVNButton(this.text, {super.size, super.onReleased, super.position}) : super(
    button: ButtonBackground(const Color.fromRGBO(255, 255, 255, 0.85)),
    buttonDown: ButtonBackground(const Color.fromRGBO(226, 226, 226, 0.85)),
    children: [
      TextComponent(
        text: text,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 0.5* size!.y,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            shadows: [
              Shadow(blurRadius: 17, offset: const Offset(0.5, 0.5), color: Colors.grey.shade400)
            ]
          )
        ),
        position: size / 2.0,
        anchor: Anchor.center,
        priority: 1
      )
    ],
    anchor: Anchor.center
  );

  @override
  void onTapDown(TapDownEvent event) {
    onReleased;
    super.onTapDown(event);
  }
}