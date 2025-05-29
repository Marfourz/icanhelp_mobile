import 'package:flutter/material.dart';

class ILogo extends StatelessWidget {
  const ILogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
              'assets/images/logo.png',
              width: 200.0,
              height: 79.09,
              fit: BoxFit.contain,
            );
  }
}