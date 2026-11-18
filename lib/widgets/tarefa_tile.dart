import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../tema.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cinzaClaro),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
        leading:
            Checkbox(value: tarefa.concluida, onChanged: (_) => onMarcar()),
        title: Text(
          tarefa.titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: tarefa.concluida ? cinza : preto,
            decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: tarefa.descricao.isEmpty
            ? null
            : Text(tarefa.descricao, style: const TextStyle(color: cinza)),
        onTap: onEditar,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: cinza),
          tooltip: 'Excluir',
          onPressed: onExcluir,
        ),
      ),
    );
  }
}
