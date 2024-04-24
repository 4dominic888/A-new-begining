import 'dart:async';

import 'package:a_new_begin_again_vn/modules/dialog_system/classes/tag_actions.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/box_title_container.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/text_container.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/screens/screen_dialog.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flame_svg/flame_svg.dart';
import 'package:jenny/jenny.dart';

class SceneViewComponent extends PositionComponent with DialogueView, HasWorldReference<ScreenDialog>{
  late SpriteComponent boxTextContainer;
  late BoxTitleContainer boxTitleContainer;
  late SvgComponent continueIndicator;
  late final ButtonComponent forwardNextButtonComponent;
  Completer<void> _forwardCompleter = Completer();
  late DialoguePerCharText textContainer;
  late DialogueLine publicLine;
  late final TagAction tagAction;

  @override
  FutureOr<void> onLoad() {

    tagAction = TagAction(this);
    boxTextContainer = SpriteComponent(sprite: world.boxTextContainer)
      ..position.y = 285;

    boxTitleContainer = BoxTitleContainer(key: ComponentKey.named("boxTitle"), "", sprite: world.boxTitleContainer)
      ..position.y = boxTextContainer.position.y - 35
      ..position.x = -5;

    continueIndicator = SvgComponent(
      svg: world.continueIndicator,
      size: Vector2(25, 25),
      position: Vector2(570,85),
    );

    continueIndicator.add(OpacityEffect.by(0.4, InfiniteEffectController(ZigzagEffectController(period: 0.9))));

    textContainer = DialoguePerCharText(
      text: '',
      game: world.game,
      timePerChar: 0.05,
      onComplete: (){
        textContainer.add(continueIndicator);
      },
    );

    forwardNextButtonComponent = ButtonComponent(
      button: PositionComponent(),
      size: world.game.size,
      onPressed: () async {
        if(!textContainer.finished){
          await _showDialog(true, publicLine);
        }
        else {
          _forwardCompleter.complete();
        }
    });

    addAll([forwardNextButtonComponent, continueIndicator, boxTextContainer..priority = 2, textContainer]);

    return super.onLoad();
  }

  @override
  FutureOr<void> onNodeStart(Node node) async {
    final bg = SpriteComponent(key: ComponentKey.named('bg'), sprite: await world.gameRef.loadSprite('bg/${node.tags["initBg"]}'));
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

  Future<void> _showDialog(bool skiped, DialogueLine line) async{
    final String? characterName = line.character?.name;
    final bool hasParent = boxTitleContainer.parent != null;

    if(characterName != null && characterName.isNotEmpty){
      boxTitleContainer.title = characterName;
      if(!hasParent){
        await add(boxTitleContainer..priority = 3);
      }
      else{
        boxTitleContainer.setTitle(characterName);
      }
    }
    else{
      if(hasParent){
        remove(boxTitleContainer);
      }
    }

    remove(textContainer);
    if(skiped){
      textContainer = DialoguePerCharText(
        text: line.text, 
        game: world.game,
        timePerChar: 0,
        onComplete: (){
          textContainer.add(continueIndicator);
        },
      )..priority = 3;
    }
    else{
      textContainer = DialoguePerCharText(
        text: line.text,
        game: world.game,
        timePerChar: 0.05,
        onComplete: (){
          textContainer.add(continueIndicator);
        },
      )..priority = 3;
    }
    await add(textContainer);
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