import 'dart:async';
import 'package:flutter/material.dart';
import 'package:q_movie_app/modules/bottomNavigationBar/screens/bottom_navigation_bar.dart';
import 'package:q_movie_app/modules/start/components/splash_screen_image.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    startTimeout();

    super.initState();
  }

  startTimeout() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, _startApp);
  }

  _startApp() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                const BottomNavigationBarScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SplashScreenImage(),
      ),
    );
  }
}
