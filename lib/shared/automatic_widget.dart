import 'package:flutter/material.dart';

class AutomaticWidget extends StatefulWidget {

  final void Function() func;

  const AutomaticWidget({super.key, required this.func});

  @override
  State<AutomaticWidget> createState() => _AutomaticWidgetState();
}

class _AutomaticWidgetState extends State<AutomaticWidget> {

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => widget.func.call());
    return Container(color: Colors.transparent, width: 0, height: 0);
  }
}