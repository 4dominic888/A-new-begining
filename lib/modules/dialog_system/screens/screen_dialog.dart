import 'dart:async';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/scene_view_component.dart';
import 'package:a_new_begin_again_vn/shared/fade_component.dart';
import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jenny/jenny.dart';

class ScreenDialog extends World with HasGameRef<VisualNovel>{

  late final Sprite boxTextContainer;
  late final Sprite boxTitleContainer;
  YarnProject yarnProject = YarnProject();
  late final SceneViewComponent sceneViewComponent;

  @override
  FutureOr<void> onLoad() async {

    final fader = FadeComponent(
      size: gameRef.cam.viewport.virtualSize,
      color: Colors.black,
      time: 1.7
    );
    gameRef.cam.viewport.add(fader);
    fader.outEffect(() {});

    _loadCommands();

    boxTextContainer = await gameRef.loadSprite('dialogs/default_dialog_container.png');
    boxTitleContainer = await gameRef.loadSprite('dialogs/default_dialog_title.png');
    sceneViewComponent = SceneViewComponent();
    String startDialog = await rootBundle.loadString('assets/yarn/start.yarn');

    yarnProject.parse(startDialog);
    var dialogueRunner = DialogueRunner(yarnProject: yarnProject, dialogueViews: [sceneViewComponent]);
    dialogueRunner.startDialogue('mini_historia_fulbo');

    add(sceneViewComponent);

    return super.onLoad();
  }
  
  void _loadCommands(){
    
    //* characterAppear
    yarnProject.commands.addCommand4("characterAppear", (String chName, String fileName, String ext, String pos) async {
      final SpriteComponent character1 = SpriteComponent(
        key: ComponentKey.named('ch_$chName'),
        sprite: await gameRef.loadSprite('characters/$fileName.$ext')
      );
      character1.size /= character1.size.y / gameRef.size.y;
      switch (pos) {
        case "center": character1.position.x = (gameRef.size.x *0.5) - 160; break;
        case "left": character1.position.x = (gameRef.size.x *0.25) - 160; break;
        case "right": character1.position.x = (gameRef.size.x *0.75) - 160; break;
      }

      sceneViewComponent.add(character1);
      character1.priority = 0;
    });

  }
}