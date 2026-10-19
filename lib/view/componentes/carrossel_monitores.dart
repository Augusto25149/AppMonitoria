import 'package:flutter/material.dart';
import 'package:monitoria_dcomp/view/componentes/cartao_monitor.dart';
import 'package:monitoria_dcomp/view/tema.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

class CarrosselMonitores extends StatefulWidget {
  final MonitoresViewModel viewModel;
  final double fracaoVisivel;
  const CarrosselMonitores({
    super.key,
    required this.viewModel,
    required this.fracaoVisivel,
  });

  @override
  State<CarrosselMonitores> createState() => _CarrosselMonitoresState();
}

class _CarrosselMonitoresState extends State<CarrosselMonitores> {
  late final PageController controlador;

  @override
  void initState() {
    super.initState();
    controlador = PageController(
      initialPage: widget.viewModel.paginaAtual,
      viewportFraction: widget.fracaoVisivel,
    );
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  void _mover(int pagina) {
    if (!controlador.hasClients) {
      return;
    }
    controlador.animateToPage(
      pagina,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    final escala = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0);
    return Column(
      children: [
        SizedBox(
          height: 290 * escala,
          child: PageView.builder(
            key: const Key('carrossel-monitores'),
            controller: controlador,
            itemCount: viewModel.monitoresVisiveis.length,
            onPageChanged: viewModel.registrarPagina,
            itemBuilder: (context, indice) {
              final monitor = viewModel.monitoresVisiveis[indice];
              return CartaoMonitor(
                selecao: viewModel.selecionarMonitor(monitor),
              );
            },
          ),
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Monitor anterior',
              onPressed: viewModel.podeVoltarPagina
                  ? () => _mover(viewModel.paginaAtual - 1)
                  : null,
              icon: const Icon(Icons.chevron_left),
            ),
            for (
              int indice = 0;
              indice < viewModel.monitoresVisiveis.length;
              indice++
            )
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: indice == viewModel.paginaAtual ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: indice == viewModel.paginaAtual
                        ? CoresAplicativo.azul
                        : CoresAplicativo.borda,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            IconButton(
              tooltip: 'Próximo monitor',
              onPressed: viewModel.podeAvancarPagina
                  ? () => _mover(viewModel.paginaAtual + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        Text(
          '${viewModel.paginaAtual + 1} de ${viewModel.monitoresVisiveis.length} monitores',
          style: const TextStyle(
            color: CoresAplicativo.secundario,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
