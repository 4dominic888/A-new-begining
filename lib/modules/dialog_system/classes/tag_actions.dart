import 'package:a_new_begin_again_vn/modules/dialog_system/components/scene_view_component.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:jenny/jenny.dart';

class TagAction{

  final SceneViewComponent _sceneViewComponent;

  TagAction(this._sceneViewComponent);

  final _dic = {
    //* Esta etiqueta proporciona un movimiento de arriba y abajo por 3 segundos al personaje de la linea colocada
    "#scream": (ComponentSet children, DialogueLine line){
      FlameAudio.play('sfx/surprise.mp3');
      final shake = MoveEffect.by(Vector2(0,-3), InfiniteEffectController(ZigzagEffectController(period: 0.2)));
      final chSpr = children.query<SpriteComponent>().firstWhere((element) => element.key == ComponentKey.named('ch_${line.character?.name}'));
      chSpr.add(shake);
      Future.delayed(const Duration(seconds: 1, milliseconds: 500)).then((value) => shake.pause());
    },

    "#pause": (ComponentSet children, DialogueLine line){
      FlameAudio.bgm.pause();
    },

    "#organizing": (ComponentSet children, DialogueLine line){
      FlameAudio.play('sfx/organizing.mp3');
    }
  };

  void executeTags(List<String> tags, 
  {
    required ComponentSet children,
    required DialogueLine line,
    //? Cualquier otro objeto util para modificar el entorno
  }){
    for (String t in tags) {
      _dic[t]?.call(children, line);
    }
  }
}