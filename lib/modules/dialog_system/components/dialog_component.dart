import 'dart:async';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/box_text_container.dart';
import 'package:a_new_begin_again_vn/modules/dialog_system/components/box_title_container.dart';
import 'package:flame/components.dart';
import 'package:flame_svg/flame_svg.dart';

class DialogComponent extends PositionComponent{
  late BoxTextContainer boxTextContainer;
  late BoxTitleContainer boxTitleContainer;

  DialogComponent({
    required Sprite boxTextSprite,
    required Sprite boxTitleSprite,
    required Svg continueSvg,
    required Vector2 sizeWorld,
  }){

    boxTextContainer = BoxTextContainer(
      sprite: boxTextSprite,
      size: sizeWorld,
      svg: continueSvg
    )..position.y = 285;

    boxTitleContainer = BoxTitleContainer(key: ComponentKey.named("boxTitle"), "", sprite: boxTitleSprite)
      ..position.y = boxTextContainer.position.y - 35
      ..position.x = -5;
  }

  @override
  FutureOr<void> onLoad() async{
    await addAll([
      boxTextContainer,
    ]);

    return super.onLoad();
  }

  Future<void> regenerateTitle(bool hasContent, String? title) async{
    final bool hasParent = boxTitleContainer.parent != null;
    if(hasContent){
      if(!hasParent){
        await add(boxTitleContainer..priority = 1);
      }
      boxTitleContainer.setTitle(title!);
    }
    else{
      if(hasParent) {
        boxTitleContainer.removeFromParent();
      }
    }
  }
}