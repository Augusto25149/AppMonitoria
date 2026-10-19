import 'package:monitoria_dcomp/model/horario.dart';

class Monitor {
  final String nome;
  final List<Horario> horarios;

  final String? caminhoFoto;
  const Monitor({required this.nome, required this.horarios, this.caminhoFoto});
}
