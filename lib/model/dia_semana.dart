enum DiaSemana {
  segunda('segunda', 'Segunda'),
  terca('terca', 'Terça'),
  quarta('quarta', 'Quarta'),
  quinta('quinta', 'Quinta'),
  sexta('sexta', 'Sexta'),
  sabado('sabado', 'Sábado');

  final String chave;
  final String nome;
  const DiaSemana(this.chave, this.nome);
}
