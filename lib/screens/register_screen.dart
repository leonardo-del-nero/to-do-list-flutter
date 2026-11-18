import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../tema.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    final erro =
        await AuthService.cadastrar(_nome.text, _email.text, _senha.text);
    if (!mounted) return;

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (rota) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              children: [
                const Text(
                  'Criar conta',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Leva menos de um minuto.',
                  style: TextStyle(color: cinza),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _nome,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (valor) => (valor == null || valor.trim().isEmpty)
                      ? 'Informe o nome'
                      : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe o e-mail';
                    }
                    if (!valor.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _senha,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: Icon(Icons.lock_outline),
                    helperText: 'Mínimo de 6 caracteres',
                  ),
                  obscureText: true,
                  validator: (valor) => (valor == null || valor.length < 6)
                      ? 'A senha precisa de pelo menos 6 caracteres'
                      : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                    onPressed: _cadastrar, child: const Text('Cadastrar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
