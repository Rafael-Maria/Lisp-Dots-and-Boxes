(defun jogar(no max-time);Depth por default é 4 e o player é 1
	(progn (setq next-sucessor-final '())
	(cond
			((terminal (car no)) (format t "O no é terminal ~%"))
			(t(let*(
				(start-time (get-internal-run-time))
				(best-evaluation (alphabeta no depth-search -9999999 9999999 'sucessores-aux 1 4 max-time start-time))
				(new-node (cond ((null next-sucessor-final) (butlast(car(sucessores-aux no 1)))) (t (find-best best-evaluation))))
				)
				(List (last new-node) (butlast new-node))
                                
			))
		)
	)
)