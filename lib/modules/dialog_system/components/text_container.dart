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
      fontWeight: FontWeight.w300
    )),
    boxConfig: TextBoxConfig(
      growingBox: true,
      maxWidth: game.size.x * 0.7,
      timePerChar: timePerChar,
      margins: const EdgeInsets.all(16.0)
    ),
  );

}
