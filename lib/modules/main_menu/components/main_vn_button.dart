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
  bool isLocked;
  
  void Function() onAction;

  MainVNButton(this.text, {super.size, required this.onAction, super.position, this.isLocked = false}) : super(
    button: !isLocked ? ButtonBackground(const Color.fromRGBO(255, 255, 255, 0.85)) : ButtonBackground(const Color.fromRGBO(200, 200, 200, 0.85)),
    buttonDown: !isLocked ? ButtonBackground(const Color.fromRGBO(220, 220, 220, 0.85)) : null,
    onReleased: !isLocked ? onAction : null,
    children: [
      TextComponent(
        text: text,
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 0.5* size!.y,
            fontWeight: FontWeight.bold,
            color: !isLocked ? Colors.black : Colors.grey.shade700,
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