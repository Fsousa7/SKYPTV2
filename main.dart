import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/blank_screen.dart';
import 'screens/splash_screen.dart';
// importa o teu theme bonito

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const SkyptApp());
}

class SkyptApp extends StatefulWidget {
  const SkyptApp({super.key});
  @override
  State<SkyptApp> createState() => _SkyptAppState();
}

class _SkyptAppState extends State<SkyptApp> {
  bool _showRegister = false;
  int? _userId;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Torna a janela borderless e fixa no splash
    Future.microtask(() async {
      await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
      windowManager.setSize(const Size(1920, 1080));
      windowManager.setAlignment(Alignment.center);
      windowManager.setResizable(false);
    });
  }

  void _onLoginSuccess(Map<String, dynamic> user) {
    setState(() {
      _userId = user['id'] as int;
    });
  }


  void _finishSplash() async {
  // Só faz ações para a janela DEPOIS da splash
  await windowManager.setResizable(true);
  await windowManager.maximize(); // ou setFullScreen(true), se quiser de fato fullscreen
  setState(() {
    _showSplash = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKYPT Gestão 3D',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: _showSplash
          ? SplashScreen(onFinish: _finishSplash)
          : (_userId != null
              ? BlankScreen(userId: _userId!)
              : (_showRegister
                  ? RegisterScreen(
                      onLoginTap: () => setState(() => _showRegister = false),
                    )
                  : LoginScreen(
                      onRegisterTap: () => setState(() => _showRegister = true),
                      onLoginSuccess: _onLoginSuccess,
                    ))),
    );
  }
}