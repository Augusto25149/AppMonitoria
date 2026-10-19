import 'package:flutter/material.dart';
import 'package:monitoria_dcomp/view/componentes/carrossel_monitores.dart';
import 'package:monitoria_dcomp/view/componentes/menu_lateral.dart';
import 'package:monitoria_dcomp/view/tema.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

class TelaPrincipal extends StatelessWidget {
  final MonitoresViewModel viewModel;

  const TelaPrincipal({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Monitoria DCOMP')),
          drawer: MenuLateral(viewModel: viewModel),
          body: Builder(
            builder: (context) {
              if (!viewModel.filtroSelecionado) {
                return _estadoInicial(context);
              }
              return _listaMonitores();
            },
          ),
        );
      },
    );
  }

  Widget _estadoInicial(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icones/monitoria.png',
              width: 135,
              height: 120,
              excludeFromSemantics: true,
            ),
            const SizedBox(height: 28),
            const Text(
              'Nenhum filtro selecionado',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CoresAplicativo.texto,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Abra o menu para escolher um dia\nou ver todos os monitores',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                color: CoresAplicativo.secundario,
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              child: const Text('Escolher um dia'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listaMonitores() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: CoresAplicativo.azulClaro,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icones/calendario.png',
                        width: 26,
                        height: 26,
                        color: CoresAplicativo.azul,
                        excludeFromSemantics: true,
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          'Filtro: ${viewModel.nomeFiltro}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: CoresAplicativo.azul,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 34),
            if (viewModel.monitoresVisiveis.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Nenhum monitor atende neste dia.',
                  textAlign: TextAlign.center,
                ),
              )
            else
              LayoutBuilder(
                builder: (context, largura) {
                  final fracao = largura.maxWidth >= 720 ? 0.34 : 0.78;
                  return CarrosselMonitores(
                    key: ValueKey('${viewModel.nomeFiltro}-$fracao'),
                    viewModel: viewModel,
                    fracaoVisivel: fracao,
                  );
                },
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Text(
                viewModel.orientacao,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: CoresAplicativo.secundario,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Deslize os cards ou use as setas',
              textAlign: TextAlign.center,
              style: TextStyle(color: CoresAplicativo.secundario, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
