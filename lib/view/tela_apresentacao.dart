import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monitoria_dcomp/view/tema.dart';
import 'package:monitoria_dcomp/viewmodel/monitores_view_model.dart';

class TelaApresentacao extends StatefulWidget {
  final MonitoresViewModel monitores;
  const TelaApresentacao({super.key, required this.monitores});
  @override
  State<TelaApresentacao> createState() => _TelaApresentacaoState();
}

class _TelaApresentacaoState extends State<TelaApresentacao> {
  Timer? temporizador;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    await widget.monitores.carregarDados();
    if (!mounted || widget.monitores.erro != null) {
      return;
    }
    temporizador = Timer(const Duration(seconds: 2), () {
      context.go('/');
    });
  }

  @override
  void dispose() {
    temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: ListenableBuilder(
            listenable: widget.monitores,
            builder: (context, child) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icones/monitoria.png',
                  width: 170,
                  height: 150,
                  excludeFromSemantics: true,
                ),
                const SizedBox(height: 28),
                const Text(
                  'Monitoria DCOMP',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: CoresAplicativo.texto,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Encontre o melhor horário para aprender',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: CoresAplicativo.secundario,
                  ),
                ),
                const SizedBox(height: 32),
                if (widget.monitores.erro == null)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Column(
                    children: [
                      Text(widget.monitores.erro!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _iniciar,
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
