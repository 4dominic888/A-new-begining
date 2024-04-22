import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DialoguePerCharText extends TextBoxComponent{

  final VisualNovel game;
  final double timePerChar;

  DialoguePerCharText({required String text, required this.game, required this.timePerChar}) : super(
    text: text,
    position: Vector2(100, game.size.y -115),
    textRenderer: TextPaint(style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      shadows: [Shadow(color: Colors.black, blurRadius: 20.5, offset: Offset(0.1, 0.1))]
    )),
    boxConfig: TextBoxConfig(
      growingBox: true,
      maxWidth: game.size.x * 0.7,
      timePerChar: timePerChar,
      margins: const EdgeInsets.all(16.0)
    ),
  );

}
