import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoria_dcomp/route/roteador.dart';
import 'package:monitoria_dcomp/view/tema.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

void main() => runApp(const AplicativoMonitoria());

class AplicativoMonitoria extends StatefulWidget {
  const AplicativoMonitoria({super.key});
  @override
  State<AplicativoMonitoria> createState() => _AplicativoMonitoriaState();
}

class _AplicativoMonitoriaState extends State<AplicativoMonitoria> {
  final MonitoresViewModel viewModel = MonitoresViewModel();
  late final GoRouter roteador;

  @override
  void initState() {
    super.initState();
    roteador = criarRoteador(viewModel);
  }

  @override
  void dispose() {
    roteador.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Monitoria DCOMP',
      debugShowCheckedModeBanner: false,
      routerConfig: roteador,
      theme: criarTema(),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],

      localizationsDelegates: GlobalMaterialLocalizations.delegates,
    );
  }
}
