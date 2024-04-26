import 'dart:async';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/scene_view_component.dart';
import 'package:a_new_begin_again_vn/shared/fade_component.dart';
import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jenny/jenny.dart';

class ScreenDialog extends World with HasGameRef<VisualNovel>{

  late final Sprite boxTextContainer;
  late final Sprite boxTitleContainer;
  late final Svg exitSvg;
  late final Svg fastSave;
  late final Svg fastLoad;
  late final Svg continueIndicator;
  late final SpriteComponent bgCom;
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
    continueIndicator = await Svg.load('images/dialogs/continue_indicator.svg');
    exitSvg = await Svg.load('images/svg/exit.svg');
    fastSave = await Svg.load('images/svg/fast_save.svg');
    fastLoad = await Svg.load('images/svg/fast_load.svg');
    sceneViewComponent = SceneViewComponent();
    String startDialog = await rootBundle.loadString('assets/yarn/start.yarn');

    yarnProject.parse(startDialog);
    var dialogueRunner = DialogueRunner(yarnProject: yarnProject, dialogueViews: [sceneViewComponent]);
    dialogueRunner.startDialogue('prologo');

    add(sceneViewComponent);

    return super.onLoad();
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    super.onRemove();
  }
  
  void _loadCommands(){
    
    //* characterAppear
    yarnProject.commands.addCommand4("characterAppear", (String chName, String fileName, String ext, String pos) async {
      final SpriteComponent character = SpriteComponent(
        sprite: await gameRef.loadSprite('characters/$fileName.$ext')
      );
      await character.add(Component(key: ComponentKey.named('ch_$chName'),));
      character.size /= character.size.y / gameRef.size.y;
      switch (pos) {
        case "center": character.position.x = (gameRef.size.x *0.5) - 160; break;
        case "left": character.position.x = (gameRef.size.x *0.25) - 160; break;
        case "right": character.position.x = (gameRef.size.x *0.75) - 160; break;
      }
      character.position.y = 50;
      character.priority = 0;
      character.add(OpacityEffect.fadeOut(LinearEffectController(0)));
      sceneViewComponent.add(character);
      character.add(OpacityEffect.fadeIn(LinearEffectController(0.5)));
      character.add(MoveByEffect(Vector2(0, -50), LinearEffectController(0.5)));
    });

    //* characterChangueName
    yarnProject.commands.addCommand2("characterChangueName", (String oldName, String newName) {
      final character = sceneViewComponent.children.query<SpriteComponent>().firstWhere((element) => element.firstChild()?.key == ComponentKey.named('ch_$oldName'));
      character.children.query().first.removeFromParent();
      character.add(Component(key: ComponentKey.named('ch_$newName')));
    });

    //* characterHide
    yarnProject.commands.addCommand1("characterHide", (String chName) {
      final character = sceneViewComponent.children.query<SpriteComponent>().firstWhere((element) => element.firstChild()?.key == ComponentKey.named('ch_$chName'));
      character.add(MoveByEffect(Vector2(0, 50), LinearEffectController(0.5)));
      character.add(OpacityEffect.fadeOut(LinearEffectController(0.5), onComplete: () => character.removeFromParent()));
    });

    //* changeBg
    yarnProject.commands.addCommand3("changueBg", (String transicion, String fileName, double time) async {
      if(transicion == "sliding-curtain"){
        final sizeX = gameRef.cam.viewport.virtualSize.x;
        final RectangleComponent rec = RectangleComponent(
          size: gameRef.cam.viewport.virtualSize,
          paint: Paint()..color = Colors.black,
          position: Vector2(gameRef.cam.viewport.virtualSize.x, 0)
        );
        gameRef.cam.viewport.add(rec);
        rec.add(MoveByEffect(Vector2(-sizeX, 0), LinearEffectController(time), onComplete: () async {
          bgCom.sprite = await gameRef.loadSprite('bg/$fileName');
          rec.add(MoveByEffect(Vector2(-sizeX, 0), LinearEffectController(time), onComplete: (){
            rec.removeFromParent();
          }));
        }));
      }
      if(transicion == "fade"){
        bgCom.add(OpacityEffect.fadeOut(LinearEffectController(time), onComplete: () async {
          bgCom.sprite = await gameRef.loadSprite('bg/$fileName');
          bgCom.add(OpacityEffect.fadeIn(LinearEffectController(time)));
        }));
      }
    });

    //* changeSound
    yarnProject.commands.addCommand1("changueSound", (String fileName) {
      FlameAudio.bgm.play('songs/$fileName');
    });

    //* zoomBg
    yarnProject.commands.addCommand1("zoomBg", (double zoom) {
      bgCom.add(ScaleEffect.by(Vector2.all(zoom), LinearEffectController(1.5)));
    });

    //* returnZoomBg
    yarnProject.commands.addCommand1("returnZoomBg", (double zoom) {
      bgCom.add(ScaleEffect.by(Vector2.all(1/zoom), LinearEffectController(1.5)));
    });    

    //* moveBg
    yarnProject.commands.addCommand2("moveBg", (double x, double y) {
      bgCom.add(MoveByEffect(Vector2(x,y), LinearEffectController(1.5)));
    });    
  }
}