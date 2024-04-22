import 'dart:async';
import 'package:a_new_begin_again_vn/modules/main_menu/screens/screen_main_menu.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class VisualNovel extends FlameGame{

  late final CameraComponent cam;
  late final ScreenMainMenu mainMenu;

  @override
  Future<void> onLoad() async {
    mainMenu = ScreenMainMenu(size: size);

    cam = CameraComponent.withFixedResolution(
      world: mainMenu,
      width: size.x, height: size.y,
    )..viewfinder.anchor = Anchor.topLeft;
    await addAll([cam, mainMenu]);
    return super.onLoad();
  }


  @override
  Color backgroundColor() {
    return Colors.black;
  }
}
