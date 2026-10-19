import 'package:monitoria_dcomp/model/dia_semana.dart';
import 'package:monitoria_dcomp/model/horario.dart';
import 'package:monitoria_dcomp/model/monitor.dart';
import 'package:monitoria_dcomp/model/selecao_monitor.dart';

class HorariosViewModel {
  final SelecaoMonitor selecao;
  const HorariosViewModel({required this.selecao});

  Monitor get monitor => selecao.monitor;
  String get origem => selecao.dia?.nome ?? 'Todos';
  String get titulo =>
      selecao.dia == null ? 'Todos os atendimentos' : 'Atendimento deste dia';

  List<Horario> get horarios {
    List<Horario> lista = [];

    for (Horario horario in monitor.horarios) {
      if (selecao.dia == null || horario.dia == selecao.dia) {
        lista.add(horario);
      }
    }

    return lista;
  }

  Map<DiaSemana, List<Horario>> get horariosPorDia {
    Map<DiaSemana, List<Horario>> grupos = {};
    List<Horario> horariosSelecionados = horarios;

    for (DiaSemana dia in DiaSemana.values) {
      List<Horario> horariosDoDia = [];

      for (Horario horario in horariosSelecionados) {
        if (horario.dia == dia) {
          horariosDoDia.add(horario);
        }
      }

      if (horariosDoDia.isNotEmpty) {
        grupos[dia] = horariosDoDia;
      }
    }
    return grupos;
  }
}
