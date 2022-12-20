(defun auxiliar-check-already-in-close-or-open(no &optional (abertos nil) (fechados nil))
"Fun��o auxiliar que retorna o no se n�o existir na lista de fechados e de abertos,e caso exista retorna nil,recebe por par�metros um n� e, opcionalmente uma lista de n�s abertos e de n�s fechados"
  (cond
   ((and (null abertos) (null fechados)) no) ;The no was never explored
   ((or (equal (car no) (car abertos)) (equal (car no) (car(car fechados)))) nil) ;The no is alredy explored or to explore 
   (t (auxiliar-check-already-in-close-or-open no (cdr abertos) (cdr fechados))) ;Recursively to check the rest of abertos e fechados
   )
)

(defun check-auxiliar-check-for-all-sucessores(sucessores &optional (abertos nil) (fechados nil))
"Fun��o auxiliar que retorna os n�s que nunca foram explorados ou que ir�o ser explorados, recebe a lista de p�ssiveis sucessores, e opcionalmente,uma lista com os n�s abertos e n� fechados"
  (cond
   ((null sucessores) nil);in case the sucessores are empty
   (t (cons (auxiliar-check-already-in-close-or-open (car sucessores) abertos fechados) (check-auxiliar-check-for-all-sucessores (cdr sucessores) abertos fechados))) ;recursive call
  )
)

(defun bfs (no-init solution sucessores opera &optional (aberto nil) (fechado nil))
"Fun��o usada para calcular o melhor resultado utilizando o algoritmo BFS.Recebe por par�metros o n�-inicial, a fun��o para calcular a solu��o, a fun��o para calcular os sucessores, uma lista com as opera��es usadas nos sucessores, e opcionalmente a lista de n�s abertos e a lista de n�s fechados"
  (let* ((sucess (funcall sucessores no-init opera))
    (actual-sucess (check-auxiliar-check-for-all-sucessores sucess aberto fechado)))
  (cond ((funcall solution no-init) (list no-init aberto fechado))
        (T (bfs (car(append actual-sucess aberto)) solution sucessores opera (append (cdr aberto) actual-sucess) (cons no-init fechado)))
  )
  )
)

(defun dfs (no-init solution sucessores opera max &optional (aberto nil) (fechado nil))
"Fun��o usada para calcular o melhor resultado utilizando o algoritmo DFS.Recebe por par�metros o n�-inicial, a fun��o para calcular a solu��o, a fun��o para calcular os sucessores, uma lista com as opera��es usadas nos sucessores, qual a profundidade m�xima, e opcionalmente a lista de n�s abertos e a lista de n�s fechados"
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

(defun no-profundidade (no)
"Fun��o auxiliar para descobrir a profundidade de um n�"
  (Second no)
 )


(defun auxiliar-check-already-in-close-or-open-for-a(no &optional (abertos nil) (fechados nil))
"Fun��o auxiliar que retorna o no se n�o existir na lista de fechados,e caso exista retorna nil,recebe por par�metros um n� e, opcionalmente uma lista de n�s abertos e de n�s fechados"
  (cond
   ((and (null abertos) (null fechados)) no) ;The no was never explored
   ((equal (car no) (car(car fechados))) nil) ;The no is alredy explored 
   (t (auxiliar-check-already-in-close-or-open no (cdr abertos) (cdr fechados))) ;Recursively to check the rest of abertos e fechados
   )
)

(defun check-auxiliar-check-for-all-sucessores-for-a(sucessores &optional (abertos nil) (fechados nil))
"Fun��o auxiliar que retorna os n�s que nunca foram explorados, recebe a lista de p�ssiveis sucessores, e opcionalmente,uma lista com os n�s abertos e n� fechados"
  (cond
   ((null sucessores) nil);in case the sucessores are empty
   (t (cons (auxiliar-check-already-in-close-or-open (car sucessores) abertos fechados) (check-auxiliar-check-for-all-sucessores (cdr sucessores) abertos fechados))) ;recursive call
  )
)


(defun a-star(no-init solution sucessores opera heu &optional (aberto nil) (fechado nil))
"Fun��o usada para calcular o melhor resultado utilizando o algoritmo A*.Recebe por par�metros o n�-inicial, a fun��o para calcular a solu��o, a fun��o para calcular os sucessores, uma lista com as opera��es usadas nos sucessores, qual a heuristica utilizada, e opcionalmente a lista de n�s abertos e a lista de n�s fechados"
 (let* ((sucess (funcall sucessores no-init opera heu))
    		(actual-sucess (check-auxiliar-check-for-all-sucessores-for-a sucess aberto fechado)))
    		(cond ((funcall solution no-init) (list no-init aberto fechado))
          		(T
                         (a-star (car(sort-lista (append actual-sucess aberto))) solution sucessores opera heu (append actual-sucess (cdr aberto)) (cons no-init fechado))
                         )
               )
         )  
)

(defun sort-lista (list)
"Fun��o auxiliar para ordernar uma lista pelo seu custo (profundidade + valor heuristica)"
  (sort list #'< :key (lambda (x) (+ (third x) (second x)))))
  
  
(defun ida-star (no-init solution sucessores opera max-heur heu &optional (lista-sucess nil) (no-root nil))
"Fun��o usada para calcular o melhor resultado utilizando o algoritmo IDA*.Recebe por par�metros o n�-inicial, a fun��o para calcular a solu��o, a fun��o para calcular os sucessores, uma lista com as opera��es usadas nos sucessores,qual o limite, qual a heuristica utilizada, e opcionalmente a lista de n�s abertos e o n� raiz"
   (let* ((sucess (funcall sucessores no-init opera heu)))
            (cond ((funcall solution no-init) (list no-init max-heur))
                      ((< max-heur (+ (third no-init) (second no-init))) (ida-star no-root solution sucessores opera (+ (second no-init)(third no-init)) heu))
                  (T
                         (ida-star (car (sort-lista (append sucess lista-sucess))) solution sucessores opera max-heur heu (append sucess lista-sucess) no-init)
                         )
               )
   ) 
)

(defun penetrancia (no nos-gerados)
"Fun��o usada para calcular a penetrancia, recebe como par�metros, o no-resultado e o n� de n�s gerados"
    (cond
        ((not (=  nos-gerados 0)) (float (/ (no-profundidade no)  nos-gerados)))
    )
)

(defun ramification-factor(length-of-path total-nos)
"Fun��o usada para calcular o fator de ramifica��o, recebe como par�metros, o tamanho do caminho e o n� de n�s totais"
	(float(/ total-nos length-of-path))
)