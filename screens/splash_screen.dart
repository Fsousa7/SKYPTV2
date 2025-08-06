import 'package:flutter/material.dart';
import 'dart:async';
import 'package:window_manager/window_manager.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    windowManager.setSize(const Size(800, 450)); // Tamanho pequeno
    windowManager.setAlignment(Alignment.center);
    windowManager.setResizable(false);

    Timer(const Duration(seconds: 4), () {
      widget.onFinish(); // NÃO chame maximize ou fullscreen aqui!
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Image.asset(
          'assets/intro.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}