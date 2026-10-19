import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitoria_dcomp/route/roteador.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

class MonitoresDeTeste extends MonitoresViewModel {
  @override
  Future<void> carregarDados() async {
    String texto = File('assets/dados/horarios.json').readAsStringSync();
    Map<String, dynamic> dados = jsonDecode(texto);
    definirDados(dados);
  }
}

void main() {
  testWidgets('Apresentação aguarda dois segundos e abre o estado inicial', (
    tester,
  ) async {
    final viewModel = MonitoresDeTeste();
    final roteador = criarRoteador(viewModel);
    addTearDown(viewModel.dispose);
    addTearDown(roteador.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: roteador));
    await tester.pump();
    expect(
      find.text('Encontre o melhor horário para aprender'),
      findsOneWidget,
    );
    expect(find.text('Nenhum filtro selecionado'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Nenhum filtro selecionado'), findsNothing);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum filtro selecionado'), findsOneWidget);
    expect(viewModel.monitoresVisiveis, isEmpty);
    expect(roteador.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Fechar a apresentação cancela seu temporizador', (tester) async {
    final viewModel = MonitoresDeTeste();
    final roteador = criarRoteador(viewModel);
    addTearDown(viewModel.dispose);
    addTearDown(roteador.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: roteador));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
  });
}
