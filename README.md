# Monitoria DCOMP

Aplicativo Flutter em português para consultar os horários fornecidos no enunciado. Usa MVVM, Material Design 3, ChangeNotifier, ListenableBuilder e GoRouter, seguindo a organização dos exemplos da Simone. O menu lateral, a apresentação automática, o PageView e os PNGs foram acrescentados conforme os requisitos deste trabalho.

## Executar

O SDK fica fora do projeto. Em um terminal nesta pasta:

```powershell
flutter pub get
flutter run -d chrome
```

Para conferir o código e o comportamento:

```powershell
flutter analyze
flutter test
flutter build web
```

Android também possui a estrutura de projeto gerada pelo Flutter. Para executar em um celular, configure as ferramentas e licenças do Android SDK e use `flutter run` com o dispositivo conectado.

## Onde encontrar cada responsabilidade

| Pasta ou arquivo | Responsabilidade |
| --- | --- |
| `lib/main.dart` | Inicia o aplicativo, injeta o ViewModel e configura o idioma |
| `lib/model/` | Modelos de monitor, horário, dia e seleção para navegação |
| `lib/viewmodel/monitores_view_model.dart` | Carrega o JSON, converte modelos, filtra monitores e guarda a página |
| `lib/viewmodel/horarios_view_model.dart` | Decide quais horários mostrar e os agrupa por dia |
| `lib/view/tela_apresentacao.dart` | Exibe a apresentação e controla os dois segundos antes de navegar |
| `lib/view/` | Telas e tema visual; não filtra os dados |
| `lib/view/componentes/` | Menu, carrossel, cartão do monitor e avatar |
| `lib/route/roteador.dart` | Rotas e passagem da seleção pelo extra do GoRouter |
| `assets/dados/horarios.json` | Única fonte local dos horários |
| `assets/icones/` | Os três PNGs originais enviados pelo usuário |
| `test/` | Testes das regras e da navegação com os dados do projeto |

## Fluxo da aplicação

1. A apresentação carrega os dados e aguarda dois segundos.
2. A principal começa sem filtro; o usuário abre o menu.
3. Segunda a Sexta mostram somente os monitores que atendem no dia. Todos mostra os cinco perfis.
4. O card abre os detalhes com o monitor e o dia de origem.
5. Os detalhes exibem somente o dia selecionado ou todos os atendimentos, incluindo sábado em Todos.
6. Voltar remove os detalhes da pilha, preservando filtro e posição do carrossel.

O carrossel mostra parte dos cards vizinhos, indicadores, contador e setas para mouse/teclado. Em telas largas a fração muda para apresentar vários cards. As telas usam rolagem vertical para acomodar dispositivos pequenos.

## Dados e decisões

- Os dados foram transcritos do JSON fornecido. Não há confirmação externa de atualização dos monitores; este aplicativo usa o mock local solicitado.
- Por confirmação do usuário, Abdom e Abdom Levi são a mesma pessoa. Com sua autorização, apenas as células de terça às 16:45 e 17:30 foram normalizadas para `Schmal & Abdom Levi`.
- Os 20 horários, demais nomes e disponibilidades foram mantidos. `-` representa ausência de atendimento e não vira um perfil.
- Nenhum horário de término foi inventado. A interface mostra os textos de horário da fonte, sem agrupar em intervalos presumidos.
- Sábado permanece nos dados e nos detalhes de Todos, mas não é uma opção do menu solicitado.
- Os nomes e fotos das pessoas presentes nas imagens de referência não substituem os nomes do JSON.

## Cadastrar uma foto futuramente

O campo `Monitor.caminhoFoto` aceita um caminho de asset. Coloque a imagem em uma pasta de assets, declare-a no pubspec e informe seu caminho ao construir o monitor no ViewModel. Enquanto esse campo for null, o app mostra `assets/icones/monitor.png`. Não faz download de fotos.

## Padrões usados

Os modelos com campos final e construtores nomeados, a divisão model/view/viewmodel, ChangeNotifier, ListenableBuilder e GoRouter com extra seguem os exemplos de aula. Os recursos adicionais foram usados para atender aos requisitos explícitos. Não usamos Provider, Riverpod, API remota ou banco de dados. A skill Simone Flutter continua instalada somente na pasta local de skills, fora deste repositório.

## Como ler o código

Comece por `main.dart`, que cria o ViewModel e o roteador. Depois leia as três rotas em `route/roteador.dart`.

Na tela principal, `build` escolhe entre `_estadoInicial` e `_listaMonitores`. O menu chama `selecionarFiltro` no ViewModel. O carrossel cuida apenas da rolagem e usa `CartaoMonitor` para desenhar cada perfil.

No `MonitoresViewModel`, `definirDados` percorre as linhas do JSON, separa os nomes por `&` e monta os objetos Monitor e Horario. `selecionarFiltro` atualiza a lista com laços `for` e condições `if`. Nos detalhes, `HorariosViewModel` faz a seleção dos horários e os agrupa por dia também com laços explícitos.

O carregamento e a mensagem de erro ficam no ViewModel dos monitores. A apresentação controla somente seu temporizador e a navegação. Não é necessário outro ViewModel para esse efeito visual.

O código continua sem comentários, conforme solicitado. Esta documentação explica a organização sem misturar explicações com a implementação.
