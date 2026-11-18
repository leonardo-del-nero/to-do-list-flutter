import 'package:flutter/material.dart';

import '../tema.dart';

class Logo extends StatelessWidget {
  final double tamanho;

  const Logo({super.key, this.tamanho = 84});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: tamanho,
        height: tamanho,
        decoration: BoxDecoration(
          color: preto,
          borderRadius: BorderRadius.circular(tamanho * 0.28),
        ),
        child: Icon(Icons.done_all, color: Colors.white, size: tamanho * 0.5),
      ),
    );
  }
}
