(defun get-arcos-horizontais (tab)
  (car tab)
)

(defun get-arcos-verticais (tab)
  (car (cdr tab))
)

(defun get-arco-na-posicao (x y tab)
  (nth (- y 1) (nth (- x 1) tab))
)

(defun substituir (pos lista &optional (var 1))
  (cond
   ((= pos 1) (cons var (cdr lista)))
   (T (cons (car lista) (substituir (- pos 1) (cdr lista) var)))
   )
)


(defun arco-na-posicao (x y tab &optional (value 1))
  (cond
   ((= x 1) (cons (substituir y (car tab) value) (cdr tab)))
   (t (cons (car tab) (arco-na-posicao (- x 1) y (cdr tab))))
  )
)


(defun arco-horizontal (fileira arco-pos tabuleiro)
  (List (arco-na-posicao fileira arco-pos (get-arcos-horizontais (car tabuleiro)))(get-arcos-verticais (car tabuleiro)))
)

; (arco-vertical 1 2 (tabuleiro-teste))
(defun arco-vertical (fileira arco-pos tabuleiro)
  (List (get-arcos-horizontais (car tabuleiro)) (arco-na-posicao fileira arco-pos (get-arcos-verticais (car tabuleiro))) )
)

(defun solution-found(tab)
  (cond
    ((>= (num-boxes (car tab)) (car (reverse tab))) t)
    (t nil)
  )
)


(defun heuristica(no value)
        (- value (num-boxes no))
)

(defun start-no (no value &optional (heu nil))
	(cond
		((null heu) (list no 0  nil nil value))
  		(t (list no 0  (funcall heu no value) nil value))
	)
)


(defun sucessores (no-init opera &optional (heu nil))
  (cond
      ((null opera) nil)
      (t (append (funcall (car opera) no-init 1 1 heu) (sucessores no-init (cdr opera) heu)))
    )
)

(defun insert-vertical-sucessor-tab(tab &optional  (collum 1) (position 1) (heu nil))
  (cond
   ((> collum (length (get-arcos-verticais (car tab)))) nil)
   ((> position (length (car (get-arcos-verticais (car tab))))) (insert-vertical-sucessor-tab tab (+ 1 collum) 1 heu))
   ((equal (arco-vertical collum position tab) (car tab)) (insert-vertical-sucessor-tab tab collum (+ 1 position) heu))
   (t
    (cond
         ((and (= collum (length (get-arcos-verticais (car tab)))) (= position (length (car (get-arcos-verticais (car tab)))))) (cons (new-sucessor-verti tab collum position heu) nil)) ;alterar para retornar o ultimo
        ((= position (length (car (get-arcos-verticais (car tab))))) (cons (new-sucessor-verti tab collum position heu) (insert-vertical-sucessor-tab tab (+ 1 collum) 1 heu)))
        (t (cons (new-sucessor-verti tab collum position heu) (insert-vertical-sucessor-tab tab collum (+ 1 position) heu)))
      )
    )
   )
)

;profundidade do no
(defun tab-prof (tab)
  (Second tab)
)

(defun new-sucessor-verti(tab collum position &optional (heu nil))
	(cond
		((null heu) (list (arco-vertical collum position tab) (+ 1(tab-prof tab)) heu (car tab) (car (reverse tab))))
  		(t (list (arco-vertical collum position tab) (+ 1(tab-prof tab)) (funcall heu (arco-vertical collum position tab) (car (reverse tab))) (car tab) (car (reverse tab))))
	)
)

(defun insert-horizontal-sucessor-tab(tab &optional (line 1) (position 1) (heu nil))
  (cond
   ((> line (length (get-arcos-horizontais(car tab))))  nil)
   ((> position (length (car (get-arcos-horizontais (car tab))))) (insert-horizontal-sucessor-tab tab (+ 1 line) 1 heu))
   ((equal(arco-horizontal line position tab) (car tab)) (insert-horizontal-sucessor-tab tab line (+ 1 position) heu))
   (t
    (cond
         ((and (= line (length (get-arcos-horizontais(car tab)))) (= position (length (car (get-arcos-horizontais (car tab)))))) (cons (new-sucessor-hori tab line position heu) nil)) ;alterar para retornar o ultimo
        ((= position (length (car (get-arcos-horizontais (car tab))))) (cons (new-sucessor-hori tab line position heu) (insert-horizontal-sucessor-tab tab (+ 1 line ) 1 heu)))
        (t (cons (new-sucessor-hori tab line position heu) (insert-horizontal-sucessor-tab tab line (+ 1 position) heu)))
      )
    )
   )
)

(defun new-sucessor-hori(tab line position &optional (heu nil))
	(cond
		((null heu) (list (arco-horizontal line position tab) (+ 1(tab-prof tab)) heu (car tab) (car (reverse tab))))
 	 	(t (list (arco-horizontal line position tab) (+ 1(tab-prof tab)) (funcall heu (arco-horizontal line position tab) (car (reverse tab))) (car tab) (car (reverse tab))))
	)
)

(defun num-boxes(tab &optional (line 1) (position 1))
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

(defun heuristica-extra (tab value)
         (+ (heuristica-extra-aux (get-arcos-horizontais tab)) (heuristica-extra-aux (get-arcos-verticais tab)) (apply #'+ (car (get-arcos-horizontais tab))) (apply #'+ (car (reverse(get-arcos-horizontais tab)))) (apply #'+ (car (get-arcos-verticais tab))) (apply #'+ (car (reverse(get-arcos-verticais tab)))) (- value (num-boxes tab)))
)

;Enter tab vertical or horizontal
(defun heuristica-extra-aux(tab-side &optional (line 2))
  (cond
      ((= line (length tab-side)) 0)
      ((and (= 1 (get-arco-na-posicao line  1 tab-side)) (= 1 (get-arco-na-posicao line  (length (car tab-side)) tab-side))) (+ 2 (heuristica-extra-aux tab-side line)))
      ((or (= 1 (get-arco-na-posicao line  1 tab-side)) (= 1 (get-arco-na-posicao line  (length (car tab-side)) tab-side))) (+ 1 (heuristica-extra-aux tab-side line)))
      (t (heuristica-extra-aux tab-side (+ 1 line)))
  )
)

(defun no-pai (no)
  (Fourth no)
)

(defun caminho(no-final lista-fechados)
  (cond ((null no-final) '())
        (t (append (caminho (find-the-no-from-fechados (no-pai no-final) (- (tab-prof no-final) 1) lista-fechados) lista-fechados) (list(car no-final))))
  )
)

(defun find-the-no-from-fechados(tab prof lista-fechados)
  (cond
   ((null lista-fechados) nil)
   ((and(equal(car (car lista-fechados)) tab) (equal(tab-prof (car lista-fechados)) prof)) (car lista-fechados))
   (t (find-the-no-from-fechados tab prof (cdr lista-fechados)))
   )
)


(defun tabuleiro-teste ()
  "Retorna um tabuleiro 3x3 (3 arcos na vertical por 3 arcos na horizontal)"
    '(
        ((0 0 0) (0 0 1) (0 1 1) (0 0 1))
        ((0 0 0) (0 1 1) (1 0 1) (0 1 1))
    )
)