import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../tema.dart';
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
              style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error),
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

  String _frase(int pendentes) {
    if (_tarefas.isEmpty) return 'Vamos começar o dia?';
    if (pendentes == 0) return 'Tudo feito. Pode descansar.';
    if (pendentes == 1) return '1 tarefa pendente';
    return '$pendentes tarefas pendentes';
  }

  @override
  Widget build(BuildContext context) {
    final nome = AuthService.usuarioLogado?.nome ?? '';
    final primeiroNome = nome.split(' ').first;
    final feitas = _tarefas.where((t) => t.concluida).length;
    final pendentes = _tarefas.length - feitas;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 12, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, $primeiroNome',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(_frase(pendentes),
                                style: const TextStyle(color: cinza)),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Sair',
                          onPressed: _sair),
                    ],
                  ),
                ),
                if (_tarefas.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                    child: _resumo(feitas),
                  ),
                const SizedBox(height: 12),
                Expanded(
                  child: _tarefas.isEmpty
                      ? _vazio()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 96),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resumo(int feitas) {
    final total = _tarefas.length;
    final progresso = feitas / total;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: preto,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$feitas de $total concluídas',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              Text(
                '${(progresso * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 8,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vazio() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: cinza),
          SizedBox(height: 12),
          Text(
            'Nada por aqui ainda',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Toque em "Nova tarefa" para começar.',
            style: TextStyle(color: cinza),
          ),
        ],
      ),
    );
  }
}
