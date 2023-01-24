(defun jogar(no max-time &optional (depth 4) (player 1))
"Funcao para o campeonato de IA"
	(progn (setq next-sucessor-final '())
	(cond
			((terminal (car no)) (format t "O no é terminal ~%"))
			(t(let*(
				(start-time (get-internal-run-time))
				(best-evaluation (alphabeta no depth -9999999 9999999 'sucessores-aux player depth max-time start-time))
				(new-node (cond ((null next-sucessor-final) (butlast(car(sucessores-aux no 1)))) (t (find-best best-evaluation))))
                                (new-node-without-last (butlast new-node))
				)
                            (cond
                             ((numberp (car(last new-node))) (List (car(last new-node-without-last)) (butlast new-node-without-last)))
                             (t (List (car(last new-node)) (butlast new-node-without-last))) 
                             )       
			))
		)
	)
)