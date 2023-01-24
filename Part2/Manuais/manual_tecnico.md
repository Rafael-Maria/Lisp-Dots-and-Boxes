# **Manual Técnico**

![Dotesandboxes](./Images/Dots_and_Boxes_example_game.png "Dots and boxes")

Diogo Dias - 202001673
Rafael Maria - 202001443

Docentes:
Joaquim Filipe,
Filipe Mariano

## **Arquitetura do sistema**

### Módulos

Temos 3 módulos principais no projeto, tais como:

#### Jogo

+ jogo.lisp -
O ficheiro de projeto é basicamente a zona onde fazemos a chamada de todas a funções, funciona como um main, temos os inputs dos utilizadores, são todos capturados e consoante as suas escolhas são posteriormente inseridas dentro das funções.

#### Puzzle

+ Puzzle.lisp -
O puzzle onde fazemos a montagem e tudo o que tem com o problema descrito, varia desde os sucessores ás heuristicas escolhidas ou dadas pelos professores.

#### Algoritmo

+ Algoritmo.lisp -
Por fim, temos o ficheiro de procura onde é estabelecido o algoritmo alfa-beta

## Entidades e sua implementação

Nesta parte do documento está uma visão greal das funções que desenvolvemos em todo o projeto, de modo a que sejam agrupadas por funcionamento típico.
Para complemento desta informação temos os comentários feitos diretamente no código.

### **Ficheiro Jogo**

+ Nos ficheiros do projeto, globalmente decidimos agrupar certas funções consoante o seu funcionamento pois existem muitas funções de recolha de inputs do  utilizador, até mesmo de inserção das diretorias das pastas do projeto ou algoritmicas.
Sendo assim:

+ Funções de leitura de diretórios e compilação/load dos ficheiros:
  + Start()
  + Insert-diretory()
  + compile-files (path)
  + load-files (path)

+ Funções de leitura dos inputs do utilizador:
  + Menu (path)
  + who-start-play(path)
  + max-depth-search()
  + max-time-search()
  + jogada(no player)
  + read-side ()
  + read-position (tab side)
  + read-index (tab side)
  + human-game(no path player depth-search time-search &optional (time-print 0))

+ Funções de processamento e acesso a ficheiros externos:
  + cpu-game-human(no path player depth-search time-search &optional (time-print 0))
  + cpu-game(no path player depth-search time-search &optional (time-print 0))
  + change-player(player)
  + winner-screen(no time-print path depth-search)
  + print-result (no time-print path depth-search)
  + print-score(score)
  + print-tab(tab-hori tab-verti)
  + print-hori(tab-hori)
  + print-verti(tab-verti)
  + write-results-file (no profundidade-maxima diretoria tempo)

### **Ficheiro Puzzle**

+ Funções de Seletores:
  + get-arcos-horizontais (tab)
  + get-arcos-verticais (tab)
  + get-arco-na-posicao (x y tab)
  + get-score(no)

+ Funções auxiliares:
  + substituir (pos lista &optional (var 1))
  + arco-na-posicao (x y tab &optional (value 1)

+ Funções relativas a Operadores:
  + arco-horizontal (fileira arco-pos tabuleiro &optional (value 1))
  + arco-vertical (fileira arco-pos tabuleiro &optional (value 1))
  + num-boxes(tab &optional (line 1) (position 1))
  + sort-lista (list player)

+ Funções Sucessoras:
  + sucessores-aux (no player)
  + sucessores (no-init opera &optional (player 1))
  + insert-vertical-sucessor-tab(no &optional  (collum 1) (position 1) (player 1))
  + new-sucessor-verti(no collum position &optional (player 1))
  + insert-horizontal-sucessor-tab(no &optional (line 1) (position 1) (player 1))
  + new-sucessor-hori(no line position &optional (player 1))

+ Função Usadas no alfabeta:
  + avaliacao(no)
  + terminal(tab)
  + terminal-aux(tab-hori tab-verti)
  + zero-in-list-p (list)
  + find-best (evaluation)

### **Ficheiro Algoritmo**

+ Funções de algoritmia:
  + alphabeta(node prof min max sucess player start-prof max-time time-start)

+ Funções auxiliares do alphabeta:
  + alfabeta-max-aux(node prof min max sucess start-prof max-time time-start)
  + alfabeta-max(sucesslist prof min max sucess start-prof max-time time-start &optional (value -9999999))
  + alfabeta-min-aux(node prof min max sucess start-prof max-time time-start)
  + alfabeta-min(sucesslist prof min max sucess start-prof max-time time-start &optional (value 9999999))

## **Algoritmos e sua implementação**

### AlfaBeta

O algoritmo AlfaBeta, consiste num algoritmo de procura utilizado, em jogos de 2 jogadores.
O objetivo deste algoritmo é minimizar o número de nós que necessitam de ser avaliados por o algoritmo minimax, obtendo assim o melhor movimento no jogo.
O alfabeta utiliza dois valores, o alfa e o beta,para manter uma noção de como forem os movimentos executados até então.(O alfa representa a melhor jogada do jogador max e o beta representa a melhor jogada pelo jogador min).
A forma deste algoritmo reduzir o número de nós avaliados é através do corte, onde caso aconteça de um nó ter um resoltado pior ele e a sua sub-arvore é "cortado" da procura.

## **Opções tomadas**

Optamos pela implementação do AlfaBeta sobre o negamax, pois decidimos aproveitar a implementação da mesma desenvolvida durante as aulas de laboratório.

## **Limitações**

### **Requisitos não implementados**

A implementação de Memoização e de Procura quiescente.

### Refactoring póssivel de fazer

Dentro da Realização do Projeto foi possível perceber a existência de Refactoring que podiam ser implementados, dentro dos quais temos:

+ Utilização de operações para o problema em vez de repetir a operação car e cdr;
+ Os nomes de algumas váriaveis;
+ Uso de closures nas váriaveis globais;

### Melhoramentos potênciais

+ Há espaço para melhorias, de forma a fazer com que a eficiência e legibilidade do código sejam facilitadas, o cumprimento do Refactoring mencionado no ponto anterior é um dos pontos a melhorar tambêm.
+ A limitação da própria IDE do LispWorks Personal, pois contêm um Limite na memória Heap.
+ Uma limpeza na aparência visual da interface com o utilizador
