import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DialoguePerCharText extends TextBoxComponent{

  final Vector2 sizeWorld;
  final double timePerChar;

  DialoguePerCharText({required String text, required this.sizeWorld, required this.timePerChar, required super.onComplete}) : super(
    text: text,
    position: Vector2(100, 10),
    textRenderer: TextPaint(style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w300,
      shadows: [Shadow(color: Colors.black, blurRadius: 20.5, offset: Offset(0.1, 0.1))]
    )),
    boxConfig: TextBoxConfig(
      growingBox: true,
      maxWidth: sizeWorld.x * 0.7,
      timePerChar: timePerChar,
      margins: const EdgeInsets.all(16.0)
    ),
  );

}
