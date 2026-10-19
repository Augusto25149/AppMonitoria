import 'package:flutter/material.dart';
import 'package:monitoria_dcomp/model/monitor.dart';

class AvatarMonitor extends StatelessWidget {
  final Monitor monitor;
  final double tamanho;
  const AvatarMonitor({super.key, required this.monitor, this.tamanho = 100});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        monitor.caminhoFoto ?? 'assets/icones/monitor.png',
        width: tamanho,
        height: tamanho,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (context, erro, pilha) => Image.asset(
          'assets/icones/monitor.png',
          width: tamanho,
          height: tamanho,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
