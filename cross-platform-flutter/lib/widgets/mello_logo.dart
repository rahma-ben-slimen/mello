import 'package:flutter/material.dart';

class MelloLogo extends StatelessWidget {
  final double iconSize;

  const MelloLogo({
    super.key,
    this.iconSize = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/mello_logo.png',
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
    );
  }
}