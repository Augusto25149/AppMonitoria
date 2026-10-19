import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoria_dcomp/model/selecao_monitor.dart';
import 'package:monitoria_dcomp/view/componentes/avatar_monitor.dart';
import 'package:monitoria_dcomp/view/tema.dart';

class CartaoMonitor extends StatelessWidget {
  final SelecaoMonitor selecao;

  const CartaoMonitor({super.key, required this.selecao});

  @override
  Widget build(BuildContext context) {
    final monitor = selecao.monitor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
      child: Semantics(
        button: true,
        label: 'Ver horários de ${monitor.nome}',
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: CoresAplicativo.borda),
            borderRadius: BorderRadius.circular(18),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              context.push('/horarios', extra: selecao);
            },
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarMonitor(monitor: monitor, tamanho: 102),
                  const SizedBox(height: 18),
                  Text(
                    monitor.nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      color: CoresAplicativo.texto,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ver horários',
                    style: TextStyle(color: CoresAplicativo.azul, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
