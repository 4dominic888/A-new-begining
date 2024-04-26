import 'dart:async';

import 'package:a_new_begin_again_vn/modules/dialog_system/classes/tag_actions.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/choice_button.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/dialog_component.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/forward_next_button_component.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/option_button.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/screens/screen_dialog.dart';
import 'package:a_new_begin_again_vn/modules/main_menu/screens/screen_main_menu.dart';
import 'package:a_new_begin_again_vn/shared/fade_component.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:jenny/jenny.dart';

class SceneViewComponent extends PositionComponent with DialogueView, HasWorldReference<ScreenDialog>{

  late DialogComponent dialog;
  late final ForwardNextButtonComponent forwardNextButtonComponent;
  Completer<void> _forwardCompleter = Completer();
  Completer<int> _choiceCompleter = Completer<int>();
  List<ChoiceButton> optionList = [];

  late DialogueLine publicLine;
  late final TagAction tagAction;
  bool isPress = false;
  int _auxCounter = 0;

  @override
  FutureOr<void> onLoad() {
    tagAction = TagAction(this);

    dialog = DialogComponent(
      boxTextSprite: world.boxTextContainer,
      boxTitleSprite: world.boxTitleContainer,
      continueSvg: world.continueIndicator,
      sizeWorld: world.gameRef.size
    );

    final buttonFastSave = OptionButton(
      world.fastSave,
      position: Vector2(80, 20),
      size: Vector2.all(25),
      onReleased: (){
        world.gameRef.overlays.add('fastLoadSucess');
        Future.delayed(const Duration(seconds: 4, milliseconds: 600)).then((value) => world.gameRef.overlays.remove('fastLoadSucess'));
      }
    );

    final buttonEsc = OptionButton(
      world.exitSvg,
      position: Vector2(20, 20),
      size: Vector2.all(25),
      onReleased: (){
        final camViewPort = world.gameRef.cam.viewport;
        Future.delayed(const Duration(seconds: 1));
        if(forwardNextButtonComponent.parent != null){
          remove(forwardNextButtonComponent);
        }
        final FadeComponent fader = FadeComponent.initTransparentColor(
          size: camViewPort.virtualSize,
          color: Colors.black,
          time: 1.9
        );
        camViewPort.add(fader);
        fader.inEffect(() async{
          final mainMenu = ScreenMainMenu(size: camViewPort.size);
          world.gameRef.remove(world);
          await world.gameRef.add(mainMenu);
          world.gameRef.cam.world = mainMenu;
          camViewPort.remove(fader);
        });
      });

    forwardNextButtonComponent = ForwardNextButtonComponent(
      size: world.game.size,
      onPressed: () async {
        if(!dialog.boxTextContainer.textContainer.finished){
          await _showDialog(true, publicLine);
        }
        else {
          _forwardCompleter.complete();
        }           
      },
      onReleased: () async {
        isPress = false;
        _auxCounter = 0;
      },
      onLongPressed: (){
        isPress = true;
      }
    );

    addAll([
      buttonEsc..priority=6,
      buttonFastSave..priority=6,
      forwardNextButtonComponent,
      dialog..priority = 3
    ]);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if(isPress && _auxCounter % 10 == 0 && !_forwardCompleter.isCompleted){
      _forwardCompleter.complete();
    }
    _auxCounter++;
    super.update(dt);
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    super.onRemove();
  }

  @override
  FutureOr<void> onNodeStart(Node node) async {
    final bg = SpriteComponent(key: ComponentKey.named('bg'), sprite: await world.gameRef.loadSprite('bg/${node.tags["initBg"]}'));
    world.bgCom = bg;

    String? audio = node.tags["initSound"];
    if(audio != "none" && audio != null && !FlameAudio.bgm.isPlaying){
      FlameAudio.bgm.play('songs/$audio');
    }
    bg.size = world.gameRef.size;
    add(bg..priority = -1);
    return super.onNodeStart(node);
  }

  @override
  FutureOr<bool> onLineStart(DialogueLine line) async {
    _forwardCompleter = Completer();
    publicLine = line;
    await _advance(line);
    return super.onLineStart(line);
  }

  @override
  FutureOr<int?> onChoiceStart(DialogueChoice choice) async {
    isPress = false;
    _auxCounter = 0;

    _choiceCompleter = Completer<int>();
    forwardNextButtonComponent.removeFromParent();

    dialog.boxTextContainer.textContainer.text = "...";
    for (int i = 0; i < choice.options.length; i++) {
      optionList.add(ChoiceButton(
        choice.options[i].text,
        size: Vector2(480, 45),
        position: Vector2((world.gameRef.size.x / 2) -230, 60 + (70.0* i)),
        onAction: () {
          if(!_choiceCompleter.isCompleted){
            _choiceCompleter.complete(i);
          } 
        }));
    }
    addAll(optionList);
    await _getChoice(choice);
    return _choiceCompleter.future;
  }

  @override
  FutureOr<void> onChoiceFinish(DialogueOption option) {
    removeAll(optionList);
    optionList = [];
    add(forwardNextButtonComponent);
    return super.onChoiceFinish(option);
  }  

  Future<void> _getChoice(DialogueChoice choice) async {
    return _forwardCompleter.future;
  }

  Future<void> _showDialog(bool skiped, DialogueLine line) async{
    final String? characterName = line.character?.name;
    final bool hasContent = characterName != null && characterName.isNotEmpty;
    await dialog.regenerateTitle(hasContent, characterName);
    await dialog.boxTextContainer.regenerateText(line.text, skiped, 0.05);
  }

  Future<void> _advance(DialogueLine line) async{

    final tags = line.tags;
    if(tags.isNotEmpty){
      tagAction.executeTags(tags, children: children, line: line);
    }
    await _showDialog(false, line);

    return _forwardCompleter.future;
  }
}