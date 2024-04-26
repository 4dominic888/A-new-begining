import 'package:a_new_begin_again_vn/shared/automatic_widget.dart';
import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

final naviKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  final game = VisualNovel();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: Stack(
        children: [GameWidget(
          game: game,
          overlayBuilderMap: {'fastLoadSucess': (BuildContext context, VisualNovel game) {
            return AutomaticWidget(func: (){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Guardado rápido exitoso")));
            });
          }}
        )],
      ),
    ),
  ));
}
