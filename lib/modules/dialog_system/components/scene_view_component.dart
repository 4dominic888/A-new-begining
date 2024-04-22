import 'dart:async';

import 'package:a_new_begin_again_vn/modules/dialog_system/components/text_container.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/screens/screen_dialog.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:jenny/jenny.dart';

class SceneViewComponent extends PositionComponent with DialogueView, HasWorldReference<ScreenDialog>{
  late SpriteComponent boxTextContainer;
  late final ButtonComponent forwardNextButtonComponent;
  Completer<void> _forwardCompleter = Completer();
  late DialoguePerCharText textContainer;
  late DialogueLine publicLine;

  @override
  FutureOr<void> onLoad() {
    boxTextContainer = SpriteComponent(sprite: world.boxTextContainer)
      ..position.y = 285;

    textContainer = DialoguePerCharText(
      text: '',
      game: world.game,
      timePerChar: 0.05,
    );

    forwardNextButtonComponent = ButtonComponent(
      button: PositionComponent(),
      size: world.game.size,
      onPressed: () async {
        if(!textContainer.finished){
          remove(textContainer);
          textContainer = DialoguePerCharText(
            text: '${publicLine.character?.name ?? ''}: ${publicLine.text}', 
            game: world.game,
            timePerChar: 0
          );
          await add(textContainer);
        }
        else {
          _forwardCompleter.complete();
        }
    });

    addAll([forwardNextButtonComponent, boxTextContainer..priority = 2, textContainer..priority = 4]);

    return super.onLoad();
  }

  @override
  FutureOr<void> onNodeStart(Node node) async {
    final bg = SpriteComponent(key: ComponentKey.named('bg'), sprite: await world.gameRef.loadSprite('bg/${node.tags["initBg"]}'));
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

  Future<void> _advance(DialogueLine line) async{

    if(line.tags.contains("#scream")){
      final shake = MoveEffect.by(Vector2(0,-3), InfiniteEffectController(ZigzagEffectController(period: 0.2)));
      final chSpr = children.query<SpriteComponent>().firstWhere((element) => element.key == ComponentKey.named('ch_${line.character?.name}'));
      chSpr.add(shake);
      Future.delayed(const Duration(seconds: 3)).then((value) => shake.pause());
    }

    final characterName = line.character?.name ?? '';
    final dialogueLine = '$characterName: ${line.text}';
    remove(textContainer);
    textContainer = DialoguePerCharText(
      text: dialogueLine,
      game: world.game,
      timePerChar: 0.05,
    );
    await add(textContainer);
    return _forwardCompleter.future;
  }
}