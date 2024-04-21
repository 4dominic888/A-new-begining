import 'package:a_new_begin_again_vn/visual_novel.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

final naviKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  final game = VisualNovel();
  runApp(MaterialApp(
    home: Scaffold(
      body: Stack(
        children: [
          GameWidget(game: game)
        ],
      ),
    ),
  ));
}
