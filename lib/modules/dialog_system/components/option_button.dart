import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';

class OptionButton extends ButtonComponent {

  final Svg svg;

  OptionButton(this.svg, {
    required super.size,
    super.position,
    required super.onReleased
  }) {

    final iconComponent = SvgComponent(
      svg: svg,
      size: size * 1.4,
      anchor: Anchor.center,
      position: size,
    );

    button = CircleComponent(
      radius: size.x,
      paint: Paint()..color = Colors.transparent
    );

    buttonDown = CircleComponent(
      radius: size.x,
      paint: Paint()..color = const Color.fromRGBO(255, 255, 255, 0.30)
    );

    add(iconComponent);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onReleased;
    super.onTapDown(event);
  }

}