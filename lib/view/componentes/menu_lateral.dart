import 'package:flutter/material.dart';
import 'package:monitoria_dcomp/model/dia_semana.dart';
import 'package:monitoria_dcomp/view/tema.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

class MenuLateral extends StatelessWidget {
  final MonitoresViewModel viewModel;
  const MenuLateral({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 6, 12, 10),
              child: Text(
                'Monitoria DCOMP',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: CoresAplicativo.texto,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 24),
              child: Text(
                'Escolha quando consultar',
                style: TextStyle(
                  color: CoresAplicativo.secundario,
                  fontSize: 15,
                ),
              ),
            ),

            for (final dia in const [
              DiaSemana.segunda,
              DiaSemana.terca,
              DiaSemana.quarta,
              DiaSemana.quinta,
              DiaSemana.sexta,
            ])
              _opcao(context, dia),
            _opcao(context, null),
          ],
        ),
      ),
    );
  }

  Widget _opcao(BuildContext context, DiaSemana? dia) {
    final selecionado =
        viewModel.filtroSelecionado && viewModel.diaSelecionado == dia;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        minTileHeight: 62,
        selected: selecionado,
        selectedColor: CoresAplicativo.azul,
        selectedTileColor: CoresAplicativo.azulClaro,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Image.asset(
          'assets/icones/calendario.png',
          width: 36,
          height: 36,
          color: selecionado
              ? CoresAplicativo.azul
              : CoresAplicativo.secundario,
          excludeFromSemantics: true,
        ),
        title: Text(dia?.nome ?? 'Todos', style: const TextStyle(fontSize: 19)),
        onTap: () {
          viewModel.selecionarFiltro(dia);
          Scaffold.of(context).closeDrawer();
        },
      ),
    );
  }
}
