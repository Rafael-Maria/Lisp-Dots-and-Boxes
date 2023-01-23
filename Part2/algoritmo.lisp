;;BASED ON WIKI FAIL-HARD PSEUDOCODE
(defun alphabeta(node prof min max sucess player start-prof max-time time-start)
	(cond
		((= 0 prof) (avaliacao node));return value
		((terminal (car node)) (avaliacao node));check if is terminal
		((>= (- (get-internal-run-time) time-start) max-time) (avaliacao node))
		((= 1 player) (let ((result (alfabeta-max-aux node prof min max sucess start-prof max-time time-start))) (progn (cond ((= 1 (- start-prof prof))(setq next-sucessor-final (cons (cons result node) next-sucessor-final)))) result)))
		((= 2 player) (let ((result (alfabeta-min-aux node prof min max sucess start-prof max-time time-start))) (progn (cond ((= 1 (- start-prof prof))(setq next-sucessor-final (cons (cons result node) next-sucessor-final)))) result)))
	)
)

(defun alfabeta-max-aux(node prof min max sucess start-prof max-time time-start)
	(let ((sucessores (funcall sucess node 1)));Obter os sucessores
		(alfabeta-max sucessores prof min max sucess start-prof max-time time-start)
		)
)

(defun alfabeta-max(sucesslist prof min max sucess start-prof max-time time-start &optional (value -9999999))
	(cond
		((null (car sucesslist)) value); Check what to return 
		(t (let ((valueResult (cond
                                      ((numberp (last (car sucesslist))) (max value (alphabeta (butlast (car sucesslist)) (- prof 1) min max sucess 1 start-prof max-time time-start)))
                                      (t (max value (alphabeta (car sucesslist) (- prof 1) min max sucess 2 start-prof max-time time-start))))));
			(cond ((>= valueResult max) valueResult);cut
				(t (alfabeta-max (cdr sucesslist) prof (max min valueResult) max sucess start-prof max-time time-start valueResult)))))
	)
)

(defun alfabeta-min-aux(node prof min max sucess start-prof max-time time-start)
	(let ((sucessores (funcall sucess node 2)));Obter os sucessores
		(alfabeta-min sucessores prof min max sucess start-prof max-time time-start)
		)
)


(defun alfabeta-min(sucesslist prof min max sucess start-prof max-time time-start &optional (value 9999999))
	(cond
		((null (car sucesslist)) value); Check what to return 
		(t (let ((valueResult (cond
                                      ((numberp (last (car sucesslist))) (min value (alphabeta (butlast (car sucesslist)) (- prof 1) min max sucess 2 start-prof max-time time-start)))
                                      (t (min value (alphabeta (car sucesslist) (- prof 1) min max sucess 1 start-prof max-time time-start))))));
			(cond ((<= valueResult min) valueResult);cut
				(t (alfabeta-min (cdr sucesslist) prof min (min max valueResult) sucess start-prof max-time time-start valueResult)))))
	)
)