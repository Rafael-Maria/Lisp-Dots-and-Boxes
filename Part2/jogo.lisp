(defvar *start-time* 0)
(defvar *depth-max-search* 4)

;__________________________________________INICIO_________________________
(defun Start()
"Funcao para iniciar o programa todo"
	(progn
		(let ((path (Insert-diretory)))
			  (compile-files path))
	)
)

(defun Insert-diretory()
"Funcao para colocar qual o path, em que esta os ficheiros" 
    (progn
        (format t "Path para o diretorio dos ficheiros de processamento - ")
        (format nil (read-line))
    )
)

(defun compile-files (path)
"Funcao que compila os ficheiros necessarios localizados na path fornecida "
     (progn 
       (compile-file (concatenate 'string path "\\puzzle.lisp"))
       (compile-file (concatenate 'string path "\\algoritmo.lisp"))
       (load-files path)
     )
)

(defun load-files (path)
"Funcao que faz o load dos ficheiros criados pela funcao compile-files"
   (progn 
	(setq next-sucessor-final '())
    (load (concatenate 'string path "\\puzzle.64ofasl")) 
    (load (concatenate 'string path "\\algoritmo.64ofasl"))
    (Menu path)
   )
)

;_____________________________________________________Menus_________________________________
(defun Menu(path)
"Menu principal"
	(progn
		(format t "~%~%~%~%~%MENU~%")
		(format t "1 - Human vs CPU~%")
            		(format t "2 - CPU vs CPU~%")
            		(format t "3 - Sair~%")
            		(format t "Escreve a opcao - ")	
		(let ((opcao (read)))
			(cond((not (numberp opcao)) (Menu path))		
                     	((and (<= opcao 3) (>= opcao 1)) (cond((= opcao 1) (progn(who-start-play path)(Menu path))) ;Human vs Machine Game
								((= opcao 2) (progn(cpu-game (start-no) path 1 (max-depth-search) (max-time-search))(Menu path))) ; Machine vs Machine Game
                                                           	((= opcao 3) (progn (format t "Terminando")))
							)
                      )
                     (T (progn
                          (format t "~% Escolha invalida!~%")
                          (format t "~% Escolha entre 1 ou 3~%")
                          (format t "~%  ")
                          (Menu path)
			)
                      )
		)
             )
        )
)

(defun who-start-play(path)
	(setq *start-time* 0)
  	(if (y-or-n-p "Pretende iniciar a partida como Jogador 1? (y/n)")
	   (human-game (start-no) path 1 (max-depth-search) (max-time-search))
	   (cpu-game-human (start-no) path 1 (max-depth-search) (max-time-search)))	   
)

(defun max-depth-search()
	(progn
            	(format t "Escreva a máxima profundidade - ")	
		(let ((opcao (read)))
			(cond((not (numberp opcao)) (progn
                          (format t "~% Escolha invalida!~%")
                          (format t "~% Escolha um número maior que 1~%")
                          (format t "~%  ")
                          (max-depth-search)
			))		
                     	( (>= opcao 1) opcao)
                     (T (progn
                          (format t "~% Escolha invalida!~%")
                          (format t "~% Escolha um número maior que 1~%")
                          (format t "~%  ")
                          (max-depth-search)
			)
                      )
		)
             )
        )
)


(defun max-time-search()
	(progn
            	(format t "Escreva o tempo de procura em milisegundos - ")	
		(let ((opcao (read)))
			(cond((not (numberp opcao)) (progn
                          (format t "~% Escolha invalida!~%")
                          (format t "~% Escolha um número maior que 1~%")
                          (format t "~%  ")
                          (max-time-search)
			))		
                     	( (>= opcao 1) opcao)
                     (T (progn
                          (format t "~% Escolha invalida!~%")
                          (format t "~% Escolha um número maior que 1~%")
                          (format t "~%  ")
                          (max-time-search)
			)
                      )
		)
             )
        )
)

(defun human-game(no path player depth-search time-search &optional (time-print 0))
	(progn
		(print-result no time-print path depth-search)
		(cond
			((terminal (car no)) (winner-screen no time-print path depth-search))
			(t(let*(
				(start-time (get-internal-run-time))
				(new-node (jogada no player))(next-player (change-player player))
				(time-taken (- (get-internal-run-time) start-time))
				)(progn
				(cond
					((numberp (last new-node)) (human-game (butlast new-node) path player depth-search time-search time-taken))
					(t (cpu-game-human new-node path next-player depth-search time-search time-taken))
				))
			))
		)
	)
)

(defun cpu-game-human(no path player depth-search time-search &optional (time-print 0))
	(progn
		(print-result no time-print path depth-search)
		(cond
			((terminal (car no)) (winner-screen no time-print path depth-search))
			(t(let*(
				(start-time (get-internal-run-time))
				(best-evaluation (alphabeta no depth-search -9999999 9999999 'sucessores-aux player depth-search time-search start-time))
				(time-taken (- (get-internal-run-time) start-time))
				(new-node (cond ((null next-sucessor-final) (butlast(car(sucessores-aux no player)))) (t (find-best best-evaluation))))
				(reset (setq next-sucessor-final '()))
                                (next-player (change-player player))
				)
                            (progn 
				(cond
					((not(equal (car(cdr no)) (car(cdr new-node)))) (cpu-game-human new-node path player depth-search time-search time-taken))
					(t (human-game new-node path next-player depth-search time-search time-taken))
				))
                                
			))
		)
	)
)

(defun cpu-game(no path player depth-search time-search &optional (time-print 0))
	(progn 
		(print-result no time-print path depth-search)
		(cond
			((terminal (car no)) (winner-screen no time-print path depth-search))
			(t(let*(
				(start-time (get-internal-run-time))
				(best-evaluation (alphabeta no depth-search -9999999 9999999 'sucessores-aux player depth-search time-search start-time))
				(time-taken (- (get-internal-run-time) start-time))
				(new-node (cond ((null next-sucessor-final) (butlast(car(sucessores-aux no player)))) (t(find-best best-evaluation))))
				(reset (setq next-sucessor-final '()))
                                (next-player (change-player player))
                                ) 
			(cond
				((not(equal (car(cdr no)) (car(cdr new-node)))) (cpu-game new-node path player depth-search time-search time-taken))
				(t (cpu-game new-node path next-player depth-search time-search time-taken))
			)
			))
		)
	)
)

(defun change-player(player)
	(cond
		((= player 1) 2)
		((= player 2) 1)
		(t nil)
	)
)

(defun winner-screen(no time-print path depth-search)
"Show the final result"
;TODO
(progn
	(format t "~% Jogo Terminado!")
	(print-tab(car(car no)) (car (cdr (car no))))
	(print-score (car (cdr no)))
	(let((winner (avaliacao no)))
		(cond
			((> winner 0) (format t "Player 1 ganhou!"))
			((< winner 0) (format t "Player 2 ganhou!"))
			((= winner 0) (format t "Empate!"))
		)
	)
)
)
(defun print-result (no time-print path depth-search)
"save statistics stats and print a board"
;TODO
(progn
	(format t "~% play done! ~%")
	(format t "~% time ~s ms ~%" time-print)
	(print-tab(car(car no)) (car (cdr (car no))))
	(print-score (car (cdr no)))
	(write-results-file no depth-search path time-print)
)
)

(defun print-score(score)
(progn 
	(format t "~%Pontuação Player 1: ~s ~%" (car score))
	(format t "~%Pontuação Player 2: ~s ~%" (car(cdr score)))
)
)

(defun write-results-file (no profundidade-maxima diretoria tempo)
"Funcao que armazena os resultados obtidos num ficheiro chamado estatisticas.dat, localizado na path fornecida" 
(with-open-file (ficheiro (concatenate 'string diretoria "\\estatisticas.dat") :direction :output :if-exists :append :if-does-not-exist :create)
		(format ficheiro "~%_________________________________________________________~%"  )
                (format ficheiro "~%Tempo de procura: ~s ms ~%" tempo)
		(format ficheiro "~%Profundidade maxima: ~s ~%" profundidade-maxima)
		(format ficheiro "~%Tabuleiro: ~s ~%" (car no))
		(format ficheiro "~%Pontuação Player 1: ~s ~%" (car(car (cdr no))))
		(format ficheiro "~%Pontuação Player 2: ~s ~%" (car(cdr(car (cdr no)))))
		(format ficheiro "~%Operação: ~s ~%" (last no));Se der tempo adicionar desenho do Tab
                )
)


(defun jogada(no player)

	(let* (
		(side (read-side))
		(position (read-position (car no) side))
		(index (read-index (car no) side))
                )
		(cond 
			((= side 1) (let ((new-node (new-sucessor-hori no position index player))) (cond ((or (equal (arco-horizontal position index no 2) (car no)) (equal (arco-horizontal position index no 1) (car no))) (jogada no player)) (t new-node))))
			(t (let ((new-node (new-sucessor-verti no position index player))) (cond ((or (equal (arco-vertical position index no 2) (car no)) (equal (arco-vertical position index no 1) (car no))) (jogada no player)) (t new-node))))
		)

        )
)


(defun read-side ()
	(progn
		(format t "~% Escolha o lado") 
		(format t "~% 	1 - Horizontal")
		(format t "~% 	2 - Vertical")
		(format t "~% ")
		
		(let* ((resposta (read)))
			(cond
				((or (not (numberp resposta)) (or (> resposta 2) (< resposta 1))) 
					(progn
						(format t "~% Escolha Invalida!")
						(format t "~% ")
						(read-side)
					))		
				(T resposta
				)
			)
		)
	)
)



(defun read-position (tab side)
	(progn
		(format t "~% Escolha a posiao:") 
		(format t "~% ")
		
		(let* (	(side-value (cond ((= side 1) (length (car tab))) (t (length (car (cdr tab))))))
			(resposta (read)))
			(cond
				((or (not (numberp resposta)) (or (> resposta side-value) (< resposta 1))) 
					(progn
						(format t "~% Escolha Invalida!")
						(format t "~% ")
						(read-position tab side)
					))		
				(T resposta
				)
			)
		)
	)
)

(defun read-index (tab side)
	(progn
		(format t "~% Escolha o index da posiao escolhida:") 
		(format t "~% ")
		
		(let* (	(side-value (cond ((= side 1) (length (car (car tab)))) (t (length (car (car(cdr tab)))))))
			(resposta (read)))
			(cond
				((or (not (numberp resposta)) (or (> resposta side-value) (< resposta 1))) 
					(progn
						(format t "~% Escolha Invalida!")
						(format t "~% ")
						(read-index tab side)
					))		
				(T resposta
				)
			)
		)
	)
)

(defun print-tab(tab-hori tab-verti)
    (cond
        ((and (null tab-hori) (null tab-verti)) (format t "~%"))
        (t(progn
            (print-hori tab-hori)
            (cond ((not (null tab-hori))(format t "x~%")))
            (print-verti tab-verti)
            (format t "~%")
            (print-tab (cdr tab-hori) (cdr tab-verti))
            )
        )
    )
)

(defun print-hori(tab-hori)
    (cond
        ((null tab-hori))
        (t (mapcar #'(lambda(x) (cond ((= x 1) (format t "x-")) ((= x 2) (format t "x+")) (t (format t "x ")))) (car tab-hori)))
        )
)

(defun print-verti(tab-verti)
    (cond
        ((null tab-verti))
        (t (mapcar #'(lambda(x) (cond ((= x 1) (format t "| ")) ((= x 2) (format t "+ ")) (t (format t "  ")))) (car tab-verti)))
        )
)