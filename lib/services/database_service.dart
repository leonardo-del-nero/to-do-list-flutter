import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/tarefa.dart';

class DatabaseService {
  static Database? _db;

  static void configurar() {
    if (kIsWeb) databaseFactory = databaseFactoryFfiWeb;
  }

  static Future<Database> get banco async {
    _db ??= await openDatabase(
      kIsWeb ? 'agenda.db' : join(await getDatabasesPath(), 'agenda.db'),
      version: 1,
      onCreate: (db, versao) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE tarefas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id INTEGER NOT NULL,
            titulo TEXT NOT NULL,
            descricao TEXT,
            concluida INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
    return _db!;
  }

  // CREATE
  static Future<void> inserirTarefa(Tarefa tarefa) async {
    final db = await banco;
    final dados = tarefa.toMap()..remove('id');
    await db.insert('tarefas', dados);
  }

  // READ
  static Future<List<Tarefa>> listarTarefas(int usuarioId) async {
    final db = await banco;
    final linhas = await db.query(
      'tarefas',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId],
      orderBy: 'concluida, id DESC',
    );
    return linhas.map((linha) => Tarefa.fromMap(linha)).toList();
  }

  // UPDATE
  static Future<void> atualizarTarefa(Tarefa tarefa) async {
    final db = await banco;
    await db.update('tarefas', tarefa.toMap(),
        where: 'id = ?', whereArgs: [tarefa.id]);
  }

  // DELETE
  static Future<void> deletarTarefa(int id) async {
    final db = await banco;
    await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }
}
