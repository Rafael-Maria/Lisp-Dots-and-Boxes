;_____________________________________AlGORITMOS________________________________________________________
(defun bfs (no-init solution sucessores opera &optional (aberto nil) (fechado nil))
"Função usada para calcular o melhor resultado utilizando o algoritmo BFS.Recebe por parâmetros o nó-inicial, a função para calcular a solução, a função para calcular os sucessores, uma lista com as operações usadas nos sucessores, e opcionalmente a lista de nós abertos e a lista de nós fechados"
  (let* ((sucess (funcall sucessores no-init opera))
    (actual-sucess (check-auxiliar-check-for-all-sucessores sucess aberto fechado)))
  (cond ((funcall solution no-init) (list no-init aberto fechado))
        (T (bfs (car(append actual-sucess aberto)) solution sucessores opera (append (cdr aberto) actual-sucess) (cons no-init fechado)))
  )
  )
)

(defun dfs (no-init solution sucessores opera max &optional (aberto nil) (fechado nil))
"Função usada para calcular o melhor resultado utilizando o algoritmo DFS.Recebe por parâmetros o nó-inicial, a função para calcular a solução, a função para calcular os sucessores, uma lista com as operações usadas nos sucessores, qual a profundidade máxima, e opcionalmente a lista de nós abertos e a lista de nós fechados"
  (cond ((null no-init) nil)
  (t(let* ((sucess (funcall sucessores no-init opera))
    (actual-sucess (check-auxiliar-check-for-all-sucessores sucess aberto fechado)))
    (cond ((funcall solution no-init) (list no-init aberto fechado))
          ((= max (no-profundidade no-init)) (dfs (car aberto) solution sucessores opera max (cdr  aberto) (cons no-init fechado)))
          (T (dfs (car (append actual-sucess aberto)) solution sucessores opera max (append actual-sucess (cdr aberto)) (cons no-init fechado)))
          )
    ))
  )
)

;_______________________________________________AUXILIAR ALGORITMOS (BFS e DFS)_____________________________________________
(defun auxiliar-check-already-in-close-or-open(no &optional (abertos nil) (fechados nil))
"Função auxiliar que retorna o no se não existir na lista de fechados e de abertos,e caso exista retorna nil,recebe por parâmetros um nó e, opcionalmente uma lista de nós abertos e de nós fechados"
  (cond
   ((and (null abertos) (null fechados)) no) ;The no was never explored
   ((or (equal (car no) (car abertos)) (equal (car no) (car(car fechados)))) nil) ;The no is alredy explored or to explore 
   (t (auxiliar-check-already-in-close-or-open no (cdr abertos) (cdr fechados))) ;Recursively to check the rest of abertos e fechados
   )
)

(defun check-auxiliar-check-for-all-sucessores(sucessores &optional (abertos nil) (fechados nil))
"Função auxiliar que retorna os nós que nunca foram explorados ou que irão ser explorados, recebe a lista de póssiveis sucessores, e opcionalmente,uma lista com os nós abertos e nó fechados"
  (cond
   ((null sucessores) nil);in case the sucessores are empty
   (t (cons (auxiliar-check-already-in-close-or-open (car sucessores) abertos fechados) (check-auxiliar-check-for-all-sucessores (cdr sucessores) abertos fechados))) ;recursive call
  )
)

;__________________________________________________ORDENAÇÂO___________________________________________
(defun sort-lista (list)
"Função auxiliar para ordernar uma lista pelo seu custo (profundidade + valor heuristica)"
  (sort list #'< :key (lambda (x) (+ (third x) (second x)))))

;__________________________________________________ALGORITMO A*___________________________________
(defun a-star(no-init solution sucessores opera heu &optional (aberto nil) (fechado nil))
"Função usada para calcular o melhor resultado utilizando o algoritmo A*.Recebe por parâmetros o nó-inicial, a função para calcular a solução, a função para calcular os sucessores, uma lista com as operações usadas nos sucessores, qual a heuristica utilizada, e opcionalmente a lista de nós abertos e a lista de nós fechados"
 (let* ((sucess (funcall sucessores no-init opera heu))
    		(actual-sucess (check-auxiliar-check-for-all-sucessores-for-a sucess aberto fechado)))
    		(cond ((funcall solution no-init) (list no-init aberto fechado))
          		(T
                         (a-star (car(sort-lista (append actual-sucess aberto))) solution sucessores opera heu (append actual-sucess (cdr aberto)) (cons no-init fechado))
                         )
               )
         )  
)

;_____________________________________________ALGORITMO IDA_____________________________________________
(defun ida-star(no-init solution sucessores opera max-heur heu no-root &optional (aberto nil) (fechado nil))
"Função usada para calcular o melhor resultado utilizando o algoritmo IDA*.Recebe por parâmetros o nó-inicial, a função para calcular a solução, a função para calcular os sucessores, uma lista com as operações usadas nos sucessores,qual o limite, qual a heuristica utilizada, e opcionalmente a lista de nós abertos, fechados e o nó raiz"
  (let* ((sucess (funcall sucessores no-init opera heu))
    		(actual-sucess (check-auxiliar-check-for-all-sucessores-for-a sucess aberto fechado)))
    (cond ((funcall solution no-init) (list no-init aberto fechado))
          ((and (> max-heur (third no-init)) (null aberto)(null fechado))(ida-star no-root solution sucessores opera (new-max-heur (sort-lista actual-sucess) max-heur) heu no-root actual-sucess))
          ((and (> max-heur (third no-init)) (null aberto))(ida-star no-root solution sucessores opera (new-max-heur (sort-lista fechado) max-heur) heu no-root))
          ((> max-heur (third no-init)) (ida-star (car aberto) solution sucessores opera max-heur heu no-root (cdr  aberto) fechado) (cons no-init fechado))
          (T (ida-star (car (append actual-sucess aberto)) solution sucessores opera max-heur heu no-root (append actual-sucess (cdr aberto)) (cons no-init fechado)))
          )
    )
)

(defun new-max-heur (sorted-list max-heur)
"Função para descobrir o prox limite"
 (let ((no-custo (third (car sorted-list))))
  (cond
   ((< no-custo max-heur) no-custo)
   (t (new-max-heur (cdr sorted-list) max-heur))
   )
  )
)

;________________________________________________AUXILIAR ALGORITMOS(A* e IDA*)___________________________
(defun auxiliar-check-already-in-close-or-open-for-a(no &optional (abertos nil) (fechados nil))
"Função auxiliar que retorna o no se não existir na lista de fechados,e caso exista retorna nil,recebe por parâmetros um nó e, opcionalmente uma lista de nós abertos e de nós fechados"
  (cond
   ((and (null abertos) (null fechados)) no) ;The no was never explored
   ((equal (car no) (car(car fechados))) nil) ;The no is alredy explored 
   (t (auxiliar-check-already-in-close-or-open no (cdr abertos) (cdr fechados))) ;Recursively to check the rest of abertos e fechados
   )
)

(defun check-auxiliar-check-for-all-sucessores-for-a(sucessores &optional (abertos nil) (fechados nil))
"Função auxiliar que retorna os nós que nunca foram explorados, recebe a lista de póssiveis sucessores, e opcionalmente,uma lista com os nós abertos e nó fechados"
  (cond
   ((null sucessores) nil);in case the sucessores are empty
   (t (cons (auxiliar-check-already-in-close-or-open (car sucessores) abertos fechados) (check-auxiliar-check-for-all-sucessores (cdr sucessores) abertos fechados))) ;recursive call
  )
)
  
;_________________________________________________ESTÁTISTICAS__________________________________________________
(defun penetrancia (no nos-gerados)
"Função usada para calcular a penetrancia, recebe como parâmetros, o no-resultado e o nº de nós gerados"
    (cond
        ((not (=  nos-gerados 0)) (float (/ (no-profundidade no)  nos-gerados)))
    )
)

(defun ramification-factor(length-of-path total-nos)
"Função usada para calcular o fator de ramificação, recebe como parâmetros, o tamanho do caminho e o nº de nós totais"
	(float(/ total-nos length-of-path))
)