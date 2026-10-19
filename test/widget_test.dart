import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitoria_dcomp/route/roteador.dart';
import 'package:monitoria_dcomp/view/tema.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

void main() {
  testWidgets('Menu, carrossel, detalhes e retorno preservam a seleção', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final viewModel = MonitoresViewModel();
    viewModel.definirDados(
      jsonDecode(File('assets/dados/horarios.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    final roteador = criarRoteador(viewModel);

    roteador.go('/');
    addTearDown(roteador.dispose);
    addTearDown(viewModel.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: roteador,
        theme: criarTema(),
        locale: const Locale('pt', 'BR'),
        supportedLocales: const [Locale('pt', 'BR')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Nenhum filtro selecionado'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terça'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro: Terça'), findsOneWidget);
    await tester.tap(find.byTooltip('Próximo monitor'));
    await tester.pumpAndSettle();
    expect(viewModel.paginaAtual, 1);
    await tester.tap(find.text('Vitor'));
    await tester.pumpAndSettle();
    expect(find.text('Origem: Terça'), findsOneWidget);
    expect(find.text('07:30'), findsOneWidget);
    expect(find.text('08:15'), findsNothing);
    expect(find.byIcon(Icons.menu), findsNothing);
    await tester.tap(find.byTooltip('Voltar ao carrossel'));
    await tester.pumpAndSettle();
    expect(find.text('Filtro: Terça'), findsOneWidget);
    expect(find.text('2 de 4 monitores'), findsOneWidget);
    expect(viewModel.paginaAtual, 1);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sexta'));
    await tester.pumpAndSettle();
    expect(find.text('1 de 3 monitores'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();
    PageView carrossel = tester.widget(find.byType(PageView));
    expect(carrossel.controller!.viewportFraction, 0.34);
    expect(find.text('1 de 3 monitores'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(320, 568);
    await tester.pumpAndSettle();
    carrossel = tester.widget(find.byType(PageView));
    expect(carrossel.controller!.viewportFraction, 0.78);
    expect(tester.takeException(), isNull);
  });
}
