;;BASED ON WIKI FAIL-SOFT PSEUDOCODE
;___________________________________Variaveis Globais para estatistica________________________
		(setq node-total-count 0)
		(setq alfa-total-cut 0)
		(setq beta-total-cut 0)
		(setq depth-max-value 0)

;___________________________________Implementação do AlfaBeta________________________
(defun alphabeta(node prof min max sucess player start-prof max-time time-start)
"Funcao principal do algoritmo alfabeta, passa por argumento um no, a profundidade atual (decremento da profundidade inicial), o valor de alfa, o valor de beta, a funcao de sucessores, o jogador que realiza a jogada, profundidade inicial, tempo máximo (em ms) e o tempo que a procura iniciou (em ms)"
	(progn (incf node-total-count)
	(cond
		((= 0 prof) (progn (setq depth-max-value 0) (avaliacao node)));return value
		((terminal (car node)) (progn (setq depth-max-value prof) (avaliacao node)));check if is terminal
		((>= (- (get-internal-run-time) time-start) max-time) (progn (setq depth-max-value prof) (avaliacao node)))
		((= 1 player) (let ((result (alfabeta-max-aux node prof min max sucess start-prof max-time time-start))) (progn (cond ((= 1 (- start-prof prof))(setq next-sucessor-final (cons (cons result node) next-sucessor-final)))) result)))
		((= 2 player) (let ((result (alfabeta-min-aux node prof min max sucess start-prof max-time time-start))) (progn (cond ((= 1 (- start-prof prof))(setq next-sucessor-final (cons (cons result node) next-sucessor-final)))) result)))
	)
	)
)

(defun alfabeta-max-aux(node prof min max sucess start-prof max-time time-start)
"Funcao auxiliar do alfabeta maximizante, com o objetivo de obter os sucessores, passa por parametro, o no, a profundidade, o alfa, o beta, a fucao sucessor, o tempo maximo (em ms) e o tempo inicial (em ms)"
	(let ((sucessores (funcall sucess node 1)));Obter os sucessores
		(alfabeta-max sucessores prof min max sucess start-prof max-time time-start)
		)
)

(defun alfabeta-max(sucesslist prof min max sucess start-prof max-time time-start &optional (value -9999999))
"Funcao maximizante do alfabeta, para descobrir o valor do maximizante, passa por parametro, a lista de sucessores, a profundidade, o alfa, o beta, a fucao sucessor,a profundidade inicial, o tempo maximo (em ms), o tempo inicial (em ms) e opcionalmente o valor atual(função usada em ciclo para cada elemento da lista de sucessores)"
	(cond
		((null (car sucesslist)) value); Check what to return 
		(t (let ((valueResult (cond
                                      ((numberp (last (car sucesslist))) (max value (alphabeta (butlast (car sucesslist)) (- prof 1) min max sucess 1 start-prof max-time time-start)))
                                      (t (max value (alphabeta (car sucesslist) (- prof 1) min max sucess 2 start-prof max-time time-start))))));
			(cond ((>= valueResult max) (progn (incf beta-total-cut) valueResult));beta cut
				(t (alfabeta-max (cdr sucesslist) prof (max min valueResult) max sucess start-prof max-time time-start valueResult)))))
	)
)

(defun alfabeta-min-aux(node prof min max sucess start-prof max-time time-start)
"Funcao auxiliar do alfabeta minimizante, com o objetivo de obter os sucessores, passa por parametro, o no, a profundidade, o alfa, o beta, a fucao sucessor, o tempo maximo (em ms) e o tempo inicial (em ms)"
	(let ((sucessores (funcall sucess node 2)));Obter os sucessores
		(alfabeta-min sucessores prof min max sucess start-prof max-time time-start)
		)
)


(defun alfabeta-min(sucesslist prof min max sucess start-prof max-time time-start &optional (value 9999999))
"Funcao minimizante do alfabeta, para descobrir o valor minimizante, passa por parametro, a lista de sucessores, a profundidade, o alfa, o beta, a fucao sucessor,a profundidade inicial, o tempo maximo (em ms), o tempo inicial (em ms) e opcionalmente o valor atual(função usada em ciclo para cada elemento da lista de sucessores)"
	(cond
		((null (car sucesslist)) value); Check what to return 
		(t (let ((valueResult (cond
                                      ((numberp (last (car sucesslist))) (min value (alphabeta (butlast (car sucesslist)) (- prof 1) min max sucess 2 start-prof max-time time-start)))
                                      (t (min value (alphabeta (car sucesslist) (- prof 1) min max sucess 1 start-prof max-time time-start))))));
			(cond ((<= valueResult min) (progn (incf alfa-total-cut) valueResult));alfa cut
				(t (alfabeta-min (cdr sucesslist) prof min (min max valueResult) sucess start-prof max-time time-start valueResult)))))
	)
)