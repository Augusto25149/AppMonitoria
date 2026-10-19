import 'package:flutter/material.dart';
import 'package:monitoria_dcomp/model/dia_semana.dart';
import 'package:monitoria_dcomp/model/horario.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoria_dcomp/view/componentes/avatar_monitor.dart';
import 'package:monitoria_dcomp/view/tema.dart';
import 'package:monitoria_dcomp/viewmodel/horarios_view_model.dart';

class TelaHorarios extends StatelessWidget {
  final HorariosViewModel viewModel;
  const TelaHorarios({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final grupos = viewModel.horariosPorDia;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Voltar ao carrossel',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Horário do monitor'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            children: [
              _cabecalho(),
              const SizedBox(height: 44),
              Text(
                viewModel.titulo,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: CoresAplicativo.texto,
                ),
              ),
              const SizedBox(height: 18),
              if (grupos.isEmpty) const Text('Nenhum atendimento cadastrado.'),

              for (final dia in grupos.keys) _cartaoDia(dia, grupos[dia]!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return Row(
      children: [
        AvatarMonitor(monitor: viewModel.monitor, tamanho: 82),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.monitor.nome,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: CoresAplicativo.texto,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Origem: ${viewModel.origem}',
                style: const TextStyle(
                  fontSize: 17,
                  color: CoresAplicativo.secundario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _cartaoDia(DiaSemana dia, List<Horario> horarios) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FBFF),
          border: Border.all(color: CoresAplicativo.borda),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icones/calendario.png',
              width: 38,
              height: 38,
              color: CoresAplicativo.azul,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dia.nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: CoresAplicativo.texto,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final horario in horarios)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: CoresAplicativo.azulClaro,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            horario.texto,
                            style: const TextStyle(
                              fontSize: 16,
                              color: CoresAplicativo.secundario,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
