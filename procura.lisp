(defun auxiliar-check-already-in-close-or-open(no &optional (abertos nil) (fechados nil))
  (cond
   ((and (null abertos) (null fechados)) no) ;The no was never explored
   ((or (equal (car no) (car abertos)) (equal (car no) (car(car fechados)))) nil) ;The no is alredy explored or to explore 
   (t (auxiliar-check-already-in-close-or-open no (cdr abertos) (cdr fechados))) ;Recursively to check the rest of abertos e fechados
   )
)

(defun check-auxiliar-check-for-all-sucessores(sucessores &optional (abertos nil) (fechados nil))
  (cond
   ((null sucessores) nil);in case the sucessores are empty
   (t (cons (auxiliar-check-already-in-close-or-open (car sucessores) abertos fechados) (check-auxiliar-check-for-all-sucessores (cdr sucessores) abertos fechados))) ;recursive call
  )
)

(defun bfs (no-init solution sucessores opera &optional (aberto nil) (fechado nil))
  (let* ((sucess (funcall sucessores no-init opera))
    (actual-sucess (check-auxiliar-check-for-all-sucessores sucess aberto fechado)))
  (cond ((funcall solution no-init) (list no-init aberto fechado))
        (T (bfs (car(append actual-sucess aberto)) solution sucessores opera (append (cdr aberto) actual-sucess) (cons no-init fechado)))
  )
  )
)

(defun dfs (no-init solution sucessores opera max &optional (aberto nil) (fechado nil))
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
  (Second no)
 )


(defun auxiliar-check-already-in-close-or-open-for-a(no &optional (abertos nil) (fechados nil))
  (cond
   ((and (null abertos) (null fechados)) no) ;The no was never explored
   ((equal (car no) (car(car fechados))) nil) ;The no is alredy explored or to explore 
   (t (auxiliar-check-already-in-close-or-open no (cdr abertos) (cdr fechados))) ;Recursively to check the rest of abertos e fechados
   )
)

(defun check-auxiliar-check-for-all-sucessores-for-a(sucessores &optional (abertos nil) (fechados nil))
  (cond
   ((null sucessores) nil);in case the sucessores are empty
   (t (cons (auxiliar-check-already-in-close-or-open (car sucessores) abertos fechados) (check-auxiliar-check-for-all-sucessores (cdr sucessores) abertos fechados))) ;recursive call
  )
)


(defun a-star(no-init solution sucessores opera heu &optional (aberto nil) (fechado nil))
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
  (sort list #'< :key (lambda (x) (+ (third x) (second x)))))
  
  (defun ida-star (no-init solution sucessores opera max-heur heu &optional (lista-sucess nil) (no-root nil))
   (let* ((sucess (funcall sucessores no-init opera heu)))
            (cond ((funcall solution no-init) (list no-init max-heur))
                      ((< max-heur (+ (third no-init) (second no-init))) (ida-star no-root solution sucessores opera (+ (second no-init)(third no-init)) heu))
                  (T
                         (ida-star (car (sort-lista (append sucess lista-sucess))) solution sucessores opera max-heur heu (append sucess lista-sucess) no-init)
                         )
               )
   ) 
)