import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/blank_screen.dart';
// importa o teu theme bonito

void main() {
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

  void _onLoginSuccess(Map<String, dynamic> user) {
    setState(() {
      _userId = user['id'] as int;
    });
  }

  void _logout() {
    setState(() {
      _userId = null;
      _showRegister = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SKYPT Gestão 3D',
      theme: appTheme, // usa o theme bonito do blank_screen.dart
      debugShowCheckedModeBanner: false,
      home: _userId != null
          ? BlankScreen(userId: _userId!)
          : (_showRegister
              ? RegisterScreen(
                  onLoginTap: () => setState(() => _showRegister = false),
                )
              : LoginScreen(
                  onRegisterTap: () => setState(() => _showRegister = true),
                  onLoginSuccess: _onLoginSuccess,
                )),
    );
  }
}