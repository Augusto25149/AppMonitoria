import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoria_dcomp/model/selecao_monitor.dart';
import 'package:monitoria_dcomp/view/tela_apresentacao.dart';
import 'package:monitoria_dcomp/view/tela_principal.dart';
import 'package:monitoria_dcomp/view/tela_horarios.dart';
import 'package:monitoria_dcomp/viewmodel/horarios_view_model.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

GoRouter criarRoteador(MonitoresViewModel monitores) {
  return GoRouter(
    initialLocation: '/apresentacao',
    routes: [
      GoRoute(
        path: '/apresentacao',
        builder: (context, estado) => TelaApresentacao(monitores: monitores),
      ),
      GoRoute(
        path: '/',
        builder: (context, estado) => TelaPrincipal(viewModel: monitores),
      ),
      GoRoute(
        path: '/horarios',
        builder: (context, estado) {
          if (estado.extra is! SelecaoMonitor) {
            return Scaffold(
              appBar: AppBar(title: const Text('Horário do monitor')),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Selecione um monitor na tela principal.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.go('/apresentacao'),
                      child: const Text('Ir para a tela principal'),
                    ),
                  ],
                ),
              ),
            );
          }
          final selecao = estado.extra as SelecaoMonitor;
          return TelaHorarios(viewModel: HorariosViewModel(selecao: selecao));
        },
      ),
    ],
  );
}
