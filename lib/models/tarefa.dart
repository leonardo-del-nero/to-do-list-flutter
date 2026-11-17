class Tarefa {
  final int? id;
  final int usuarioId;
  final String titulo;
  final String descricao;
  final bool concluida;

  Tarefa({
    this.id,
    required this.usuarioId,
    required this.titulo,
    this.descricao = '',
    this.concluida = false,
  });

  // sqlite nao tem bool
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'titulo': titulo,
      'descricao': descricao,
      'concluida': concluida ? 1 : 0,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      usuarioId: map['usuario_id'],
      titulo: map['titulo'],
      descricao: map['descricao'] ?? '',
      concluida: map['concluida'] == 1,
    );
  }
}
