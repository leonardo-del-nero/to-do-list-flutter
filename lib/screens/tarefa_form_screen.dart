import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class TarefaFormScreen extends StatefulWidget {
  const TarefaFormScreen({super.key});

  @override
  State<TarefaFormScreen> createState() => _TarefaFormScreenState();
}

class _TarefaFormScreenState extends State<TarefaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _descricao = TextEditingController();
  Tarefa? _tarefa;
  bool _concluida = false;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_iniciado) return;
    _iniciado = true;
    _tarefa = ModalRoute.of(context)!.settings.arguments as Tarefa?;
    if (_tarefa != null) {
      _titulo.text = _tarefa!.titulo;
      _descricao.text = _tarefa!.descricao;
      _concluida = _tarefa!.concluida;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final tarefa = Tarefa(
      id: _tarefa?.id,
      usuarioId: AuthService.usuarioLogado!.id!,
      titulo: _titulo.text.trim(),
      descricao: _descricao.text.trim(),
      concluida: _concluida,
    );

    if (_tarefa == null) {
      await DatabaseService.inserirTarefa(tarefa);
    } else {
      await DatabaseService.atualizarTarefa(tarefa);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_tarefa == null ? 'Nova tarefa' : 'Editar tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titulo,
                decoration: const InputDecoration(
                    labelText: 'Título', border: OutlineInputBorder()),
                validator: (valor) => (valor == null || valor.trim().isEmpty)
                    ? 'Informe o título'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricao,
                decoration: const InputDecoration(
                    labelText: 'Descrição', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              if (_tarefa != null)
                SwitchListTile(
                  title: const Text('Concluída'),
                  value: _concluida,
                  onChanged: (v) => setState(() => _concluida = v),
                ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: const Text('Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
