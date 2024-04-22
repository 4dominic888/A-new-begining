import 'package:a_new_begin_again_vn/modules/main_menu/components/block_layer.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class FadeComponent extends RectangleComponent implements OpacityProvider{
  
  double time;
  late final BlockLayer blockLayer;
  final Color color;

  FadeComponent.initTransparentColor({required super.size, required this.color, required this.time}){
    paint = Paint()..color = color.withOpacity(0);
    blockLayer = BlockLayer(size);
  }
  
  FadeComponent({required super.size, required this.color, required this.time}){
    paint = Paint()..color = color;
    blockLayer = BlockLayer(size);
    add(blockLayer);
  }

  Future<void> inEffect (void Function() afterFunc) async {
    if(blockLayer.parent == null){
      add(blockLayer);
    }
    add(OpacityEffect.fadeIn(LinearEffectController(time)));
    Future.delayed(Duration(milliseconds: (time * 1000).toInt())).then((value) => afterFunc() );
  }

  Future<void> outEffect (void Function() afterFunc) async {
    add(OpacityEffect.fadeOut(LinearEffectController(time)));
    Future.delayed(Duration(milliseconds: (time * 1000).toInt())).then((value) {
    if(blockLayer.parent != null){
      remove(blockLayer);
    }
      afterFunc();
      removeWhere((component) => component is OpacityEffect);
    });
  }
}