# **Manual Técnico**

![Dotesandboxes](https://cdn.discordapp.com/attachments/1034576604090871880/1053708156636766269/Dots_and_Boxes_example_game.png "Dots and boxes")

Diogo Dias - 202001673
Rafael Maria - 202001443

Docentes:
Joaquim Filipe,
Filipe Mariano

## **Arquitetura do sistema**

### Módulos

#### Objetivos

##### Projeto

##### Puzzle

##### Procura

## Entidades e sua implementação

## Algoritmos e sua implementação

## Opções tomadas

Optamos por fazer as implementações dos Algoritmos em funções separadas, apesar de ser póssivel criar uma função génerica.

## Limitações

### **Requisitos não implementados**

Não foi realizada nenhuma estátistica
A implementação dos Algoritmos IDA*, SMA* e RBFS

### Refactoring póssivel de fazer

Dentro da Realização do Projeto foi possível perceber a existência de Refactoring que podiam ser implementados dentro dos quais temos:

+ Utilização da função Let e Let* para não existir repetição de chamada ás mesmas funções
+ Utilização de operações para o problema em vez de repetir a operação car e cdr
+ Nos algoritmos existir uma implementação génerica (especialmente para o DFS e BFS)
+ Os nomes de Algumas váriaveis

### Melhoramentos potências

As melhorias que iriam criar um efeito maior na eficiência e legibilidade do código seria, o cumprimento do Refactoring mencionado no ponto Anterior.
A limitação da própria IDE do LispWorks Personal, pois contêm um Limite na memória Heap.