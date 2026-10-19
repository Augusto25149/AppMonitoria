import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:monitoria_dcomp/model/dia_semana.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';
import 'package:monitoria_dcomp/viewmodel/horarios_view_model.dart';

void main() {
  late MonitoresViewModel viewModel;
  setUp(() {
    viewModel = MonitoresViewModel();
    viewModel.definirDados(
      jsonDecode(File('assets/dados/horarios.json').readAsStringSync())
          as Map<String, dynamic>,
    );
  });
  tearDown(() => viewModel.dispose());

  test('Inicial sem filtro não mostra monitores', () {
    expect(viewModel.filtroSelecionado, isFalse);
    expect(viewModel.monitoresVisiveis, isEmpty);
  });

  test('Todos reúne cinco pessoas e não cria perfil para hífen', () {
    viewModel.selecionarFiltro(null);
    expect(viewModel.monitoresVisiveis.map((monitor) => monitor.nome), [
      'João',
      'Gabriel',
      'Vitor',
      'Abdom Levi',
      'Schmal',
    ]);
  });

  test('Cada dia tem exatamente os perfis que constam no enunciado', () {
    final esperados = {
      DiaSemana.segunda: ['João', 'Gabriel', 'Vitor', 'Schmal'],
      DiaSemana.terca: ['Gabriel', 'Vitor', 'Abdom Levi', 'Schmal'],
      DiaSemana.quarta: ['João', 'Gabriel', 'Vitor', 'Abdom Levi', 'Schmal'],
      DiaSemana.quinta: ['João', 'Gabriel', 'Vitor', 'Abdom Levi', 'Schmal'],
      DiaSemana.sexta: ['João', 'Gabriel', 'Vitor'],
    };
    for (final dia in esperados.keys) {
      viewModel.selecionarFiltro(dia);
      expect(
        viewModel.monitoresVisiveis.map((monitor) => monitor.nome),
        esperados[dia],
        reason: dia.nome,
      );
    }
  });

  test('Detalhes de João na segunda só contêm os seis horários da manhã', () {
    viewModel.selecionarFiltro(DiaSemana.segunda);
    final detalhes = HorariosViewModel(
      selecao: viewModel.selecionarMonitor(viewModel.monitoresVisiveis.first),
    );
    expect(detalhes.horarios.map((horario) => horario.texto), [
      '07:30',
      '08:15',
      '09:00',
      '10:00',
      '10:45',
      '11:30',
    ]);
    expect(detalhes.horariosPorDia.keys, [DiaSemana.segunda]);
  });

  test('Todos mantém todos os atendimentos e o sábado do Abdom Levi', () {
    viewModel.selecionarFiltro(null);
    final totais = {
      'João': 16,
      'Gabriel': 16,
      'Vitor': 16,
      'Abdom Levi': 15,
      'Schmal': 19,
    };
    for (final monitor in viewModel.monitoresVisiveis) {
      final detalhes = HorariosViewModel(
        selecao: viewModel.selecionarMonitor(monitor),
      );
      expect(
        detalhes.horarios.length,
        totais[monitor.nome],
        reason: monitor.nome,
      );
      if (monitor.nome == 'Abdom Levi') {
        expect(
          detalhes.horariosPorDia[DiaSemana.sabado]!.map(
            (horario) => horario.texto,
          ),
          ['07:30', '08:15', '09:00', '10:00', '10:45', '11:30'],
        );
        expect(
          detalhes.horariosPorDia[DiaSemana.terca]!.map(
            (horario) => horario.texto,
          ),
          ['13:30', '16:45', '17:30', '18:15', '19:00', '19:45', '20:30'],
        );
      }
    }
  });

  test('A seleção transporta o filtro sem alterar a página do carrossel', () {
    viewModel.selecionarFiltro(DiaSemana.terca);
    viewModel.registrarPagina(2);
    final selecao = viewModel.selecionarMonitor(viewModel.monitoresVisiveis[2]);
    expect(selecao.dia, DiaSemana.terca);
    expect(selecao.monitor.nome, 'Abdom Levi');
    expect(viewModel.paginaAtual, 2);
    viewModel.selecionarFiltro(DiaSemana.terca);
    expect(viewModel.paginaAtual, 2);
    viewModel.selecionarFiltro(DiaSemana.sexta);
    expect(viewModel.paginaAtual, 0);
  });
}
