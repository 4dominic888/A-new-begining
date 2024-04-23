import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class BoxTitleContainer extends SpriteComponent{

  String? title;
  late final TextComponent _textComponent;

  BoxTitleContainer(this.title, {super.key, required super.sprite, super.position});

  @override
  FutureOr<void> onLoad() {
    _textComponent = TextComponent(
      text: title,
      position: Vector2(100,18),
      anchor: Anchor.topLeft,
      textRenderer: TextPaint(style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        shadows: [Shadow(color: Colors.black, blurRadius: 20.5, offset: Offset(0.1, 0.1))]
      )),      
    );

    add(_textComponent);
    return super.onLoad();
  }

  void setTitle(String text){
    _textComponent.text = text;
  }
}