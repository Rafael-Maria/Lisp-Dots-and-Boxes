;_____________________________________operações do tabuleiro_______________________________
(defun get-arcos-horizontais (tab)
  "Função para receber os arcos-horizontais de um tabuleiro"
  (car tab)
)

(defun get-arcos-verticais (tab)
  "Função para receber os arcos-verticais de um tabuleiro"
  (car (cdr tab))
)

(defun get-arco-na-posicao (x y tab)
  "Função para receber um arco, recebe por parâmetros linha/coluna, o index e o lado vertical/horizontal do tabuleiro"
  (nth (- y 1) (nth (- x 1) tab))
)

(defun substituir (pos lista &optional (var 1))
 "Função para substituir um arco, recebe por parâmetros o index e uma coluna/linha do tabuleiro e opcionalmente o valor para substiruir (retorna uma linha/coluna)"
  (cond
   ((= pos 1) (cons var (cdr lista)))
   (T (cons (car lista) (substituir (- pos 1) (cdr lista) var)))
   )
)


(defun arco-na-posicao (x y tab &optional (value 1))
"Função para substituir um arco, recebe por parâmetros linha/coluna, o index e o lado vertical/horizontal do tabuleiro e opcionalmente o valor para substiruir (retorna uma lista de Linha/Colunas (vertical e horizontal))"
  (cond
   ((= x 1) (cons (substituir y (car tab) value) (cdr tab)))
   (t (cons (car tab) (arco-na-posicao (- x 1) y (cdr tab))))
  )
)


(defun arco-horizontal (fileira arco-pos tabuleiro)
"Função para criar um novo estado do tabuleiro, com um novo arco horizontal"
  (List (arco-na-posicao fileira arco-pos (get-arcos-horizontais (car tabuleiro)))(get-arcos-verticais (car tabuleiro)))
)

; (arco-vertical 1 2 (tabuleiro-teste))
(defun arco-vertical (fileira arco-pos tabuleiro)
"Função para criar um novo estado do tabuleiro, com um novo arco-vertical"
  (List (get-arcos-horizontais (car tabuleiro)) (arco-na-posicao fileira arco-pos (get-arcos-verticais (car tabuleiro))) )
)

(defun solution-found(tab)
"Função para determinar se o nr de caixas obtido é o pretendido (Nota: É póssivel usar esta função, caso o input do user provoque que o peça um nr de caixas que já existe no tabuleiro)"
  (cond
    ((>= (num-boxes (car tab)) (car (reverse tab))) t)
    (t nil)
  )
)

(defun num-boxes(tab &optional (line 1) (position 1))
"Função que retorna o nr de caixas de um determinado tabuleiro, (usa a dica fornecida no moodle)"
  (cond
     ((= line (length (get-arcos-horizontais tab))) 0)
     ((and (= 1 (get-arco-na-posicao line  position (get-arcos-horizontais tab))) (= 1 (get-arco-na-posicao (+ 1 line)  position (get-arcos-horizontais tab))) (= 1 (get-arco-na-posicao position line(get-arcos-verticais tab))) (= 1 (get-arco-na-posicao (+ 1 position) line (get-arcos-verticais tab)))) 
                      (cond
                          ((= position (length (car(get-arcos-horizontais tab)))) (+ 1 (num-boxes tab (+ 1 line) 1)))
                          (t (+ 1(num-boxes tab line (+ 1 position))))
                          )
                    )
     ((= position (length (car(get-arcos-horizontais tab)))) (num-boxes tab (+ 1 line) 1))
     (t (num-boxes tab line (+ 1 position)))
  )
)

;_________________________________________________Operações do nó____________________________________________
(defun no-profundidade(no)
"Função que retorna a profundidade de um nó"
  (Second no)
)

(defun no-pai (no)
"Função que retorna o tabuleiro pai de um nó"
  (Fourth no)
)

(defun start-no (tab value &optional (heu nil))
"Função para criar o nó inicial a partir do tabuleiro, do valor objetivo (nr de caixas para fechar) e opcionalmente a função da heurística"
	(cond
		((null heu) (list tab 0  nil nil value))
  		(t (list tab 0  (funcall heu tab value) nil value))
	)
)


(defun caminho(no-final lista-fechados)
"Função que retorna o caminho necessário do nó-raiz até o nó objetico, recebe por parametros o nó final e a lista de nós fechados"
  (cond ((null no-final) '())
        (t (append (caminho (find-the-no-from-fechados (no-pai no-final) (- (no-profundidade no-final) 1) lista-fechados) lista-fechados) (list(car no-final))))
  )
)

(defun find-the-no-from-fechados(tab prof lista-fechados)
"Função auxiliar de caminho que retorna um nó de tabuleiro caso exista na lista de fechados,recebe por parâmetro um tabuleiro, a profundidade, e uma lista de nós fechados"
  (cond
   ((null lista-fechados) nil)
   ((and(equal(car (car lista-fechados)) tab) (equal(no-profundidade (car lista-fechados)) prof)) (car lista-fechados))
   (t (find-the-no-from-fechados tab prof (cdr lista-fechados)))
   )
)


(defun sucessores (no-init opera &optional (heu nil))
"Função que criar todos os póssiveis sucessores para um determinado nó, recebe o nó-pai, as operações póssiveis de realizar e opcionalmente a função da heurística, retorna a lista de sucessores póssiveis"
  (cond
      ((null opera) nil)
      (t (append (funcall (car opera) no-init 1 1 heu) (sucessores no-init (cdr opera) heu)))
    )
)

(defun insert-vertical-sucessor-tab(no &optional  (collum 1) (position 1) (heu nil))
"Função que retorna a lista de sucessores, que alteram um arco vertical, recebe o no e opcionalmente a coluna, posição e a heuristica"
  (cond
   ((> collum (length (get-arcos-verticais (car no)))) nil)
   ((> position (length (car (get-arcos-verticais (car no))))) (insert-vertical-sucessor-tab no (+ 1 collum) 1 heu))
   ((equal (arco-vertical collum position no) (car no)) (insert-vertical-sucessor-tab no collum (+ 1 position) heu))
   (t
    (cond
         ((and (= collum (length (get-arcos-verticais (car no)))) (= position (length (car (get-arcos-verticais (car no)))))) (cons (new-sucessor-verti no collum position heu) nil)) ;alterar para retornar o ultimo
        ((= position (length (car (get-arcos-verticais (car no))))) (cons (new-sucessor-verti no collum position heu) (insert-vertical-sucessor-tab no (+ 1 collum) 1 heu)))
        (t (cons (new-sucessor-verti no collum position heu) (insert-vertical-sucessor-tab no collum (+ 1 position) heu)))
      )
    )
   )
)


(defun new-sucessor-verti(no collum position &optional (heu nil))
"Função que retorna um novo sucessor, em que foi alterado uma arco vertical"
	(cond
		((null heu) (list (arco-vertical collum position no) (+ 1(no-profundidade no)) heu (car no) (car (reverse no))))
  		(t (list (arco-vertical collum position no) (+ 1(no-profundidade no)) (funcall heu (arco-vertical collum position no) (car (reverse no))) (car no) (car (reverse no))))
	)
)

(defun insert-horizontal-sucessor-tab(no &optional (line 1) (position 1) (heu nil))
"Função que retorna a lista de sucessores, que alteram um arco horizontal, recebe o no e opcionalmente a linha, posição e a heuristica"
  (cond
   ((> line (length (get-arcos-horizontais(car no))))  nil)
   ((> position (length (car (get-arcos-horizontais (car no))))) (insert-horizontal-sucessor-tab no (+ 1 line) 1 heu))
   ((equal(arco-horizontal line position no) (car no)) (insert-horizontal-sucessor-tab no line (+ 1 position) heu))
   (t
    (cond
         ((and (= line (length (get-arcos-horizontais(car no)))) (= position (length (car (get-arcos-horizontais (car no)))))) (cons (new-sucessor-hori no line position heu) nil)) ;alterar para retornar o ultimo
        ((= position (length (car (get-arcos-horizontais (car no))))) (cons (new-sucessor-hori no line position heu) (insert-horizontal-sucessor-tab no (+ 1 line ) 1 heu)))
        (t (cons (new-sucessor-hori no line position heu) (insert-horizontal-sucessor-tab no line (+ 1 position) heu)))
      )
    )
   )
)

(defun new-sucessor-hori(no line position &optional (heu nil))
"Função que retorna um novo sucessor, em que foi alterado uma arco horizontal, recebe o no-pai, a linha e a posição para alterar no tabuleiro e opcionalmente a heuristica"
	(cond
		((null heu) (list (arco-horizontal line position no) (+ 1(no-profundidade no)) heu (car no) (car (reverse no))))
 	 	(t (list (arco-horizontal line position no) (+ 1(no-profundidade no)) (funcall heu (arco-horizontal line position no) (car (reverse no))) (car no) (car (reverse no))))
	)
)

;______________________________________________________Heuristica___________________________________________________________
(defun heuristica(no value)
"Função da heuristica fornecida pelo prof, nr de caixas que falta fechar = objetivo de caixas (value) - nr de caixas no nó atual"
        (- value (num-boxes no))
)

(defun heuristica-extra (tab value)
"Função da heuristica proposta por nós, consiste no somátorio do nr de arcos na borda do tabuleiro da 1ª e última posição de cada linha/coluna em que existe arcos com o nr de caixas que falta obter"
         (+ (heuristica-extra-aux (get-arcos-horizontais tab)) (heuristica-extra-aux (get-arcos-verticais tab)) (apply #'+ (car (get-arcos-horizontais tab))) (apply #'+ (car (reverse(get-arcos-horizontais tab)))) (apply #'+ (car (get-arcos-verticais tab))) (apply #'+ (car (reverse(get-arcos-verticais tab)))) (- value (num-boxes tab)))
)

(defun heuristica-extra-aux(tab-side &optional (line 2))
  "Função auxiliar da heuristica proposta por nós, que permite verificar a 1 e última posição de cada linha/coluna, por arcos. recebe por parametros, um lado do Tabuleiro e opcionalmente a linha/coluna (Nota o valor default da line é 2, pois já foi somado préviamente as bordas todas, fazendo assim que não exista somas repetidas)"
  (cond
      ((= line (length tab-side)) 0)
      ((and (= 1 (get-arco-na-posicao line  1 tab-side)) (= 1 (get-arco-na-posicao line  (length (car tab-side)) tab-side))) (+ 2 (heuristica-extra-aux tab-side (+ 1 line))))
      ((or (= 1 (get-arco-na-posicao line  1 tab-side)) (= 1 (get-arco-na-posicao line  (length (car tab-side)) tab-side))) (+ 1 (heuristica-extra-aux tab-side (+ 1 line))))
      (t (heuristica-extra-aux tab-side (+ 1 line)))
  )
)


;____________________________________________________________________Testes________________________________
(defun tabuleiro-teste ()
  "Retorna um tabuleiro 3x3 (3 arcos na vertical por 3 arcos na horizontal) para a realização de testes, sem a interface de utilizador"
    '(
        ((0 0 0) (0 0 1) (0 1 1) (0 0 1))
        ((0 0 0) (0 1 1) (1 0 1) (0 1 1))
    )
)