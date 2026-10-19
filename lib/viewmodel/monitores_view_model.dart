import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monitoria_dcomp/model/dia_semana.dart';
import 'package:monitoria_dcomp/model/horario.dart';
import 'package:monitoria_dcomp/model/monitor.dart';
import 'package:monitoria_dcomp/model/selecao_monitor.dart';

class MonitoresViewModel extends ChangeNotifier {
  List<Monitor> _monitores = [];
  List<Monitor> _monitoresVisiveis = [];
  bool _filtroSelecionado = false;
  DiaSemana? _diaSelecionado;
  int _paginaAtual = 0;
  String? _erro;

  List<Monitor> get monitoresVisiveis => _monitoresVisiveis;
  bool get filtroSelecionado => _filtroSelecionado;
  DiaSemana? get diaSelecionado => _diaSelecionado;
  int get paginaAtual => _paginaAtual;
  String? get erro => _erro;
  String get nomeFiltro => _diaSelecionado?.nome ?? 'Todos';
  String get orientacao => _diaSelecionado == null
      ? 'Toque em um monitor para ver todos os horários'
      : 'Toque em um monitor para ver o horário deste dia';
  bool get podeVoltarPagina => _paginaAtual > 0;
  bool get podeAvancarPagina => _paginaAtual < _monitoresVisiveis.length - 1;

  Future<void> carregarDados() async {
    _erro = null;
    notifyListeners();

    try {
      String texto = await rootBundle.loadString('assets/dados/horarios.json');
      Map<String, dynamic> dados = jsonDecode(texto);
      definirDados(dados);
    } catch (_) {
      _erro = 'Não foi possível carregar os horários. Tente novamente.';
      notifyListeners();
    }
  }

  void definirDados(Map<String, dynamic> dados) {
    List<dynamic> linhas = dados['horarios'];
    Map<String, Monitor> monitoresPorNome = {};

    for (var linha in linhas) {
      for (DiaSemana dia in DiaSemana.values) {
        String participantes = linha[dia.chave];

        if (participantes != '-') {
          List<String> nomes = participantes.split('&');

          for (String trecho in nomes) {
            String nome = trecho.trim();

            if (!monitoresPorNome.containsKey(nome)) {
              monitoresPorNome[nome] = Monitor(nome: nome, horarios: []);
            }

            Monitor monitor = monitoresPorNome[nome]!;
            Horario horario = Horario(dia: dia, texto: linha['horario']);
            monitor.horarios.add(horario);
          }
        }
      }
    }

    _monitores = monitoresPorNome.values.toList();
    _atualizarLista();
    notifyListeners();
  }

  void selecionarFiltro(DiaSemana? dia) {
    if (_filtroSelecionado && dia == _diaSelecionado) {
      return;
    }
    _filtroSelecionado = true;
    _diaSelecionado = dia;
    _paginaAtual = 0;
    _atualizarLista();
    notifyListeners();
  }

  void _atualizarLista() {
    _monitoresVisiveis = [];

    if (!_filtroSelecionado) {
      return;
    }

    for (Monitor monitor in _monitores) {
      if (_diaSelecionado == null) {
        _monitoresVisiveis.add(monitor);
      } else {
        for (Horario horario in monitor.horarios) {
          if (horario.dia == _diaSelecionado) {
            _monitoresVisiveis.add(monitor);
            break;
          }
        }
      }
    }
  }

  void registrarPagina(int pagina) {
    if (pagina < 0 || pagina >= _monitoresVisiveis.length) {
      return;
    }
    _paginaAtual = pagina;
    notifyListeners();
  }

  SelecaoMonitor selecionarMonitor(Monitor monitor) {
    return SelecaoMonitor(monitor: monitor, dia: _diaSelecionado);
  }
}
