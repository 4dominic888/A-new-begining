import 'dart:async';

import 'package:a_new_begin_again_vn/modules/dialog_system/components/text_container.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/screens/screen_dialog.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:jenny/jenny.dart';

class SceneViewComponent extends PositionComponent with DialogueView, HasWorldReference<ScreenDialog>{
  late SpriteComponent bg;
  late SpriteComponent character1;
  late SpriteComponent boxTextContainer;
  late final ButtonComponent forwardNextButtonComponent;
  Completer<void> _forwardCompleter = Completer();
  late DialoguePerCharText textContainer;
  late DialogueLine publicLine;

  @override
  FutureOr<void> onLoad() {
    bg = SpriteComponent(sprite: world.bg);
    character1 = SpriteComponent(sprite: world.character1)
      ..size /=2
      ..position.y = -38;

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

    addAll([bg, character1, boxTextContainer, forwardNextButtonComponent, textContainer]);

    return super.onLoad();
  }


  @override
  FutureOr<bool> onLineStart(DialogueLine line) async {
    _forwardCompleter = Completer();
    publicLine = line;
    await _advance(line);
    return super.onLineStart(line);
  }

  Future<void> _advance(DialogueLine line) async{
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