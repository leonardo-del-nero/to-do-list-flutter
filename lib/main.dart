import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/tarefa_form_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

void main() {
  DatabaseService.configurar();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget protegida(Widget tela) {
    return AuthService.usuarioLogado == null ? const LoginScreen() : tela;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do Nero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      // rotas
      routes: {
        '/': (context) => const LoginScreen(),
        '/cadastro': (context) => const RegisterScreen(),
        '/home': (context) => protegida(const HomeScreen()),
        '/tarefa': (context) => protegida(const TarefaFormScreen()),
      },
    );
  }
}
