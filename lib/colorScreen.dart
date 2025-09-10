import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Colorscreen extends StatefulWidget {
  @override
  _ColorscreenState createState() => _ColorscreenState();
}

class _ColorscreenState extends State<Colorscreen> {
  Color _color = Colors.white;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startColorChange();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startColorChange() {
    _timer = Timer.periodic(Duration(microseconds: 50000), (timer) {
      setState(() {
        _color = _getRandomColor();
      });
    });
  }

  Color _getRandomColor() {
    Random random = Random();
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color,
    );
  }
}
