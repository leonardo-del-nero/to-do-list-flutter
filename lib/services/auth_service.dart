import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../models/usuario.dart';
import 'database_service.dart';

class AuthService {
  static Usuario? usuarioLogado;

  static String _hash(String senha) {
    return sha256.convert(utf8.encode(senha)).toString();
  }

  static Future<String?> cadastrar(
      String nome, String email, String senha) async {
    final db = await DatabaseService.banco;
    email = email.trim().toLowerCase();

    final existe =
        await db.query('usuarios', where: 'email = ?', whereArgs: [email]);
    if (existe.isNotEmpty) return 'Este e-mail já está cadastrado.';

    final usuario =
        Usuario(nome: nome.trim(), email: email, senha: _hash(senha));
    final id = await db.insert('usuarios', usuario.toMap()..remove('id'));

    usuarioLogado =
        Usuario(id: id, nome: usuario.nome, email: email, senha: usuario.senha);
    return null;
  }

  static Future<String?> login(String email, String senha) async {
    final db = await DatabaseService.banco;
    final resultado = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email.trim().toLowerCase(), _hash(senha)],
    );
    if (resultado.isEmpty) return 'E-mail ou senha inválidos.';

    usuarioLogado = Usuario.fromMap(resultado.first);
    return null;
  }

  static void logout() {
    usuarioLogado = null;
  }
}
