import 'package:flutter/material.dart';

class SplashScreenImage extends StatelessWidget {
  const SplashScreenImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/q-logo.png',
      height: 80.0,
      width: 80.0,
    );
  }
}
