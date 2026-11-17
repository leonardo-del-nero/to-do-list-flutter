import 'package:flutter/material.dart';

import '../models/tarefa.dart';

class TarefaTile extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback onMarcar;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  const TarefaTile({
    super.key,
    required this.tarefa,
    required this.onMarcar,
    required this.onEditar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: tarefa.concluida, onChanged: (_) => onMarcar()),
      title: Text(
        tarefa.titulo,
        style: TextStyle(
          decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: tarefa.descricao.isEmpty ? null : Text(tarefa.descricao),
      onTap: onEditar,
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        tooltip: 'Excluir',
        onPressed: onExcluir,
      ),
    );
  }
}
