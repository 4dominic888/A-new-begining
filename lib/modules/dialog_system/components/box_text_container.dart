import 'dart:async';

import 'package:a_new_begin_again_vn/modules/dialog_system/components/text_container.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_svg/svg.dart';
import 'package:flame_svg/svg_component.dart';

class BoxTextContainer extends PositionComponent{
  late SpriteComponent box;
  late DialoguePerCharText textContainer;
  late SvgComponent continueIndicator;
  
  BoxTextContainer({
    required Sprite sprite,
    required Svg svg,
    required super.size
  }) {
    box = SpriteComponent(sprite: sprite);

    continueIndicator = SvgComponent(
      svg: svg,
      size: Vector2.all(25),
      position: Vector2(570,85),
    );

    continueIndicator.add(OpacityEffect.by(0.4, InfiniteEffectController(ZigzagEffectController(period: 0.9))));

    textContainer = DialoguePerCharText(
      text: '',
      sizeWorld: size,
      timePerChar: 0.05,
      onComplete: (){
        textContainer.add(continueIndicator);
      },
    );

  }

  @override
  FutureOr<void> onLoad() {
    addAll([box, textContainer..priority = 1, continueIndicator..priority = 2]);
    return super.onLoad();
  }

  Future<void> regenerateText(String text, bool skiped, double timePerChar) async{
    textContainer.removeFromParent();
    if(skiped){
      textContainer = DialoguePerCharText(
        text: text,
        sizeWorld: size,
        timePerChar: 0,
        onComplete: () => textContainer.add(continueIndicator)
      )..priority = 1;
    }
    else{
      textContainer = DialoguePerCharText(
        text: text,
        sizeWorld: size,
        timePerChar: timePerChar,
        onComplete: () => textContainer.add(continueIndicator)
      )..priority = 1;      
    }
    await add(textContainer);
  }

}