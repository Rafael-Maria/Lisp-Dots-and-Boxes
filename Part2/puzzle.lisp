(setq next-sucessor-final '())
;_____________________________________operacoes do tabuleiro_______________________________
(defun get-arcos-horizontais (tab)
  "Funcao para receber os arcos-horizontais de um tabuleiro"
  (car tab)
)

(defun get-arcos-verticais (tab)
  "Funcao para receber os arcos-verticais de um tabuleiro"
  (car (cdr tab))
)

(defun get-arco-na-posicao (x y tab)
  "Funcao para receber um arco, recebe por parametros linha/coluna, o index e o lado vertical/horizontal do tabuleiro"
  (nth (- y 1) (nth (- x 1) tab))
)

(defun substituir (pos lista &optional (var 1))
 "Funcao para substituir um arco, recebe por parametros o index e uma coluna/linha do tabuleiro e opcionalmente o valor para substiruir (retorna uma linha/coluna)"
  (cond
   ((= pos 1) (cons var (cdr lista)))
   (T (cons (car lista) (substituir (- pos 1) (cdr lista) var)))
   )
)


(defun arco-na-posicao (x y tab &optional (value 1))
"Funcao para substituir um arco, recebe por parametros linha/coluna, o index e o lado vertical/horizontal do tabuleiro e opcionalmente o valor para substiruir (retorna uma lista de Linha/Colunas (vertical e horizontal))"
  (cond
   ((= x 1) (cons (substituir y (car tab) value) (cdr tab)))
   (t (cons (car tab) (arco-na-posicao (- x 1) y (cdr tab) value)))
  )
)


(defun arco-horizontal (fileira arco-pos tabuleiro &optional (value 1))
"Funcao para criar um novo estado do tabuleiro, com um novo arco horizontal"
  (List (arco-na-posicao fileira arco-pos (get-arcos-horizontais (car tabuleiro)) value)(get-arcos-verticais (car tabuleiro)))
)

; (arco-vertical 1 2 (tabuleiro-teste))
(defun arco-vertical (fileira arco-pos tabuleiro &optional (value 1))
"Funcao para criar um novo estado do tabuleiro, com um novo arco-vertical"
  (List (get-arcos-horizontais (car tabuleiro)) (arco-na-posicao fileira arco-pos (get-arcos-verticais (car tabuleiro)) value) )
)


(defun num-boxes(tab &optional (line 1) (position 1))
"Funcao que retorna o nr de caixas de um determinado tabuleiro, (usa a dica fornecida no moodle)"
  (cond
     ((= line (length (get-arcos-horizontais tab))) 0)
     ((null (get-arco-na-posicao (+ 1 position) line (get-arcos-verticais tab))) 0)
     ((and (not (= 0 (get-arco-na-posicao line  position (get-arcos-horizontais tab)))) (not (= 0 (get-arco-na-posicao (+ 1 line)  position (get-arcos-horizontais tab)))) (not (= 0 (get-arco-na-posicao position line(get-arcos-verticais tab)))) (not(= 0 (get-arco-na-posicao (+ 1 position) line (get-arcos-verticais tab))) )) 
                      (cond
                          ((= position (length (car(get-arcos-horizontais tab)))) (+ 1 (num-boxes tab (+ 1 line) 1)))
                          (t (+ 1(num-boxes tab line (+ 1 position))))
                          )
                    )
     ((= position (length (car(get-arcos-horizontais tab)))) (num-boxes tab (+ 1 line) 1))
     (t (num-boxes tab line (+ 1 position)))
  )
)


(defun sort-lista (list player)
  (cond ((= player 1) (sort list #'> :key (lambda (x) (avaliacao x))))
	(t(sort list #'< :key (lambda (x) (avaliacao x))))
	)
)
(defun sucessores-aux (no player)
	(sort-lista (sucessores no '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) player) player)
)

(defun sucessores (no-init opera &optional (player 1))
  (cond
      ((null opera) nil)
      (t (append (funcall (car opera) no-init 1 1 player) (sucessores no-init (cdr opera) player)))
    )
)

(defun insert-vertical-sucessor-tab(no &optional  (collum 1) (position 1) (player 1))
  (cond
   ((> collum (length (get-arcos-verticais (car no)))) nil)
   ((> position (length (car (get-arcos-verticais (car no))))) (insert-vertical-sucessor-tab no (+ 1 collum) 1 player))
   ( (or (equal (arco-vertical collum position no 2) (car no)) (equal (arco-vertical collum position no 1) (car no))) (insert-vertical-sucessor-tab no collum (+ 1 position) player))
   (t
    (cond
         ((and (= collum (length (get-arcos-verticais (car no)))) (= position (length (car (get-arcos-verticais (car no)))))) (cons (new-sucessor-verti no collum position player) nil)) ;alterar para retornar o ultimo
        ((= position (length (car (get-arcos-verticais (car no))))) (cons (new-sucessor-verti no collum position player) (insert-vertical-sucessor-tab no (+ 1 collum) 1 player)))
        (t (cons (new-sucessor-verti no collum position player) (insert-vertical-sucessor-tab no collum (+ 1 position) player)))
      )
    )
   )
)


(defun new-sucessor-verti(no collum position &optional (player 1))
	(let* ((newtab (arco-vertical collum position no player))
		(newboxes (num-boxes newtab))
  		(oldboxes (apply '+ (get-score no))))
  		(cond
			((= newboxes oldboxes)
				(cond
					((= player 1) (list newtab (get-score no) (list collum position 'arco-vertical)))
					((= player 2) (list newtab (get-score no) (list collum position 'arco-vertical)))
					)
			)
			(t ;plan player plays again
				(cond
					((= player 1) (list newtab (list (- newboxes (car(cdr(get-score no)))) (car(cdr(get-score no)))) (list collum position 'arco-vertical)0))
					((= player 2) (list newtab (list (car (get-score no)) (- newboxes (car (get-score no))) ) (list collum position 'arco-vertical) 0))
				)
			)
		)
	)
)

(defun insert-horizontal-sucessor-tab(no &optional (line 1) (position 1) (player 1))
  (cond
   ((> line (length (get-arcos-horizontais(car no))))  nil)
   ((> position (length (car (get-arcos-horizontais (car no))))) (insert-horizontal-sucessor-tab no (+ 1 line) 1 player))
   ( (or (equal(arco-horizontal line position no 1) (car no)) (equal(arco-horizontal line position no 2) (car no))) (insert-horizontal-sucessor-tab no line (+ 1 position) player))
   (t
    (cond
         ((and (= line (length (get-arcos-horizontais(car no)))) (= position (length (car (get-arcos-horizontais (car no)))))) (cons (new-sucessor-hori no line position player) nil)) ;alterar para retornar o ultimo
        ((= position (length (car (get-arcos-horizontais (car no))))) (cons (new-sucessor-hori no line position player) (insert-horizontal-sucessor-tab no (+ 1 line ) 1 player)))
        (t (cons (new-sucessor-hori no line position player) (insert-horizontal-sucessor-tab no line (+ 1 position) player)))
      )
    )
   )
)

(defun new-sucessor-hori(no line position &optional (player 1))
	(let* ((newtab (arco-horizontal line position no player))
		(newboxes (num-boxes newtab))
		(oldboxes (apply '+ (get-score no))))
  		(cond
			((= newboxes oldboxes)
				(cond
					((= player 1) (list newtab (get-score no) (list line position 'arco-horizontal)))
					((= player 2) (list newtab (get-score no) (list line position 'arco-horizontal)))
					)
			)
			(t ;plan player plays again
				(cond
					((= player 1) (list newtab (list (- newboxes (car(cdr(get-score no)))) (car(cdr(get-score no)))) (list line position 'arco-horizontal) 0))
					((= player 2) (list newtab (list (car (get-score no)) (- newboxes (car (get-score no)))) (list line position 'arco-horizontal) 0))
				)
			)
		)
	)
)


(defun get-score(no)
  (car (cdr no))

(defun avaliacao(no)
(let* ((score (car (cdr no)))
          (playerone (car score))
          (playertwo (car(cdr score)))
        )
	(progn 
   		(- playerone playertwo)
	)
  )
)

(defun terminal(tab)
  (cond
      ((terminal-aux (car tab) (car (cdr tab)))t)
      (t nil)
  )
)


(defun terminal-aux(tab-hori tab-verti)
	(cond
		((and (null tab-hori) (null tab-verti))t)
		((null tab-hori) (and (not(zero-in-list-p (car tab-verti))) (terminal-aux (cdr tab-hori)(cdr tab-verti))))
		((null tab-verti)(and (not(zero-in-list-p (car tab-hori))) (terminal-aux (cdr tab-hori)(cdr tab-verti))))
		(t (and (not(zero-in-list-p (car tab-hori))) (not(zero-in-list-p(car tab-verti))) (terminal-aux (cdr tab-hori)(cdr tab-verti))))
	
	)
)

(defun zero-in-list-p (list)
  (cond ((null list) nil)
        ((= (car list) 0) t)
        (t (zero-in-list-p (cdr list)))))


(defun find-best (evaluation)
	(let
		((result-possibility  (car next-sucessor-final)))
		(cond
			((= (car result-possibility) evaluation) (cdr result-possibility))
			(t
				(progn
					(setq next-sucessor-final (cdr next-sucessor-final))
					(find-best evaluation)
				)
			)
		)
	)
)


;_________________________________________________Nos para Testes____________________________________________

(defun start-no ()
  (list '(
 (
 (0 0 0 0 0 0)
 (0 0 0 0 0 0)
 (0 0 0 0 0 0)
 (0 0 0 0 0 0)
 (0 0 0 0 0 0)
 (0 0 0 0 0 0)
 )
 (
 (0 0 0 0 0)
 (0 0 0 0 0)
 (0 0 0 0 0)
 (0 0 0 0 0)
 (0 0 0 0 0)
 (0 0 0 0 0)
 (0 0 0 0 0)
 )
) '(0 0) '(0 0 0))
)

(defun start-no-1()
  (list '(
 (
 (0 0 0)
 (0 0 0)
(0 0 0)
 )
 (
 (0 0)
 (0 0)
(0 0)
(0 0)
 )
) '(0 0) '(0 0 0))
)


(defun start-no-teste ()(list '(((1 0 1) (2 1 2) (1 2 1)) ((2 0) (2 0) (0 0) (2 0))) '(0 1) '(4 1 ARCO-VERTICAL)))

