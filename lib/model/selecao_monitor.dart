import 'package:monitoria_dcomp/model/dia_semana.dart';
import 'package:monitoria_dcomp/model/monitor.dart';

class SelecaoMonitor {
  final Monitor monitor;
  final DiaSemana? dia;
  const SelecaoMonitor({required this.monitor, required this.dia});
}
