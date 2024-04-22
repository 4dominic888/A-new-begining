import 'dart:async';
import 'package:a_new_begin_again_vn/modules/dialog_system/screens/screen_dialog.dart';
import 'package:a_new_begin_again_vn/modules/main_menu/components/main_vn_button.dart';
import 'package:a_new_begin_again_vn/shared/fade_component.dart';
import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class ScreenMainMenu extends World with HasGameRef<VisualNovel>{

  final TextComponent totalElements = TextComponent(position: Vector2(15, 0));
  final FpsTextComponent fps = FpsTextComponent(position: Vector2(15, 30));
  final Background bg = Background('bg/background.jpeg');
  late final FadeComponent _fader;

  final Vector2 size;

  ScreenMainMenu({required this.size});

  @override
  FutureOr<void> onLoad() async {

    final Vector2 buttonSize = Vector2(227,33);
    final Vector2 buttonPos = Vector2(size.x/2, 180);
    const double spacing = 45;
    
    _fader = FadeComponent(
      size: gameRef.cam.viewport.virtualSize,
      color: Colors.black,
      time: 1.7
    );
    gameRef.cam.viewport.add(_fader);
    _fader.outEffect(() { });

    final play = MainVNButton(
      "COMENZAR",
      size: buttonSize,
      position: buttonPos,
      onReleased: () {
        final screenDialog = ScreenDialog();
        _fader.inEffect(() async {
          gameRef.remove(this);
          await gameRef.add(screenDialog);
          gameRef.cam.world = screenDialog;
          gameRef.cam.viewport.remove(_fader);
        });
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