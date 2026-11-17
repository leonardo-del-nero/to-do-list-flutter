import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../widgets/tarefa_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final usuario = AuthService.usuarioLogado;
    if (usuario == null) return;

    final lista = await DatabaseService.listarTarefas(usuario.id!);
    if (!mounted) return;
    setState(() => _tarefas = lista);
  }

  Future<void> _abrirFormulario([Tarefa? tarefa]) async {
    await Navigator.pushNamed(context, '/tarefa', arguments: tarefa);
    _carregar();
  }

  Future<void> _marcar(Tarefa t) async {
    await DatabaseService.atualizarTarefa(Tarefa(
      id: t.id,
      usuarioId: t.usuarioId,
      titulo: t.titulo,
      descricao: t.descricao,
      concluida: !t.concluida,
    ));
    _carregar();
  }

  Future<void> _excluir(Tarefa t) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja excluir "${t.titulo}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmou == true) {
      await DatabaseService.deletarTarefa(t.id!);
      _carregar();
    }
  }

  void _sair() {
    AuthService.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (rota) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, ${AuthService.usuarioLogado?.nome ?? ''}'),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
              onPressed: _sair),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: _tarefas.isEmpty
          ? const Center(child: Text('Nenhuma tarefa. Toque no + para criar.'))
          : ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, i) {
                final t = _tarefas[i];
                return TarefaTile(
                  tarefa: t,
                  onMarcar: () => _marcar(t),
                  onEditar: () => _abrirFormulario(t),
                  onExcluir: () => _excluir(t),
                );
              },
            ),
    );
  }
}
