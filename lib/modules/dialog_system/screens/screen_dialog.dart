import 'dart:async';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/scene_view_component.dart';
import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:jenny/jenny.dart';

class ScreenDialog extends World with HasGameRef<VisualNovel>{

  late final Sprite bg;
  late final Sprite character1;
  late final Sprite boxTextContainer;
  YarnProject yarnProject = YarnProject();
  late final SceneViewComponent sceneViewComponent;

  @override
  FutureOr<void> onLoad() async {

    bg = await gameRef.loadSprite('bg/city-bg.jpg');
    character1 = await gameRef.loadSprite('characters/character_A.png');
    boxTextContainer = await gameRef.loadSprite('dialogs/default_dialog_container.png');

    sceneViewComponent = SceneViewComponent();

    String startDialog = await rootBundle.loadString('assets/yarn/start.yarn');
    yarnProject.parse(startDialog);
    var dialogueRunner = DialogueRunner(yarnProject: yarnProject, dialogueViews: [sceneViewComponent]);
    dialogueRunner.startDialogue('Test');

    add(sceneViewComponent);

    return super.onLoad();
  }
}