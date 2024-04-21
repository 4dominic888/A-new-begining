import 'dart:async';
import 'package:a_new_begin_again_vn/modules/dialog_system/screens/screen_dialog.dart';
import 'package:a_new_begin_again_vn/modules/main_menu/components/main_vn_button.dart';
import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class ScreenMainMenu extends World with HasGameRef<VisualNovel>{

  final TextComponent totalElements = TextComponent(position: Vector2(15, 0));
  final FpsTextComponent fps = FpsTextComponent(position: Vector2(15, 30));
  final Background bg = Background('bg/background.jpeg');

  final Vector2 size;

  ScreenMainMenu({required this.size});

  @override
  FutureOr<void> onLoad() async {

    final Vector2 buttonSize = Vector2(227,33);
    final Vector2 buttonPos = Vector2(size.x/2, 180);
    const double spacing = 45;

    final play = MainVNButton(
      "COMENZAR",
      size: buttonSize,
      position: buttonPos,
      onReleased: () async {
        final screenDialog = ScreenDialog();
        gameRef.cam.world = screenDialog;
        
        gameRef.remove(this);
        game.add(screenDialog);
      },
    );

    final loadSaved = MainVNButton(
      "CARGAR PARTIDA",
      size: buttonSize,
      position: Vector2(buttonPos.x, play.position.y + spacing),
      onReleased: () {
        print("cargando partida");
      },
    );

    final scenas = MainVNButton(
      "ESCENAS",
      size: buttonSize,
      position: Vector2(buttonPos.x, loadSaved.position.y + spacing),
      onReleased: () {
        print("mostrando escenas");
      },
    );

    final settings = MainVNButton(
      "CONFIGURACIONES",
      size: buttonSize,
      position: Vector2(buttonPos.x, scenas.position.y + spacing),
      onReleased: () {
        print("configurando");
      },
    );


    final login = MainVNButton(
      "LOGIN",
      size: Vector2(100,30),
      position: Vector2(size.x - 80, size.y - 30),
      onReleased: () {
        print("logear");
      },
    );

    add(bg);
    addAll([play, loadSaved, scenas, settings, login]);
    
    return super.onLoad();
  }
}

class Background extends ParallaxComponent<VisualNovel>{

  final String path;

  Background(this.path);

  @override
  FutureOr<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData(path),
      ],
      alignment: Alignment.center,
      fill: LayerFill.width,
      repeat: ImageRepeat.noRepeat,
    );
    return super.onLoad();
  }
}