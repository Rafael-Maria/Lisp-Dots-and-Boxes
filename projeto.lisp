"Inicia o programa todo"
(defun Start()
	(progn
		(let ((path (Insert-diretory)))
			  (compile-files path)
    	 )
	)
)

"Pede o diretorio em que queres trabalhar"
(defun Insert-diretory() 
    (progn
        (format t "Path para o diretorio dos ficheiros de processamento - ")
        (format nil (read-line))
    )
)

"Compila os 2 ficheiros de processamento que temos"
(defun compile-files (path)
                (progn 
                    (compile-file (concatenate 'string path "\\puzzle.lisp"))
                    (compile-file (concatenate 'string path "\\procura.lisp"))
					(load-files path)
               )
)

"Faz load do resultado do compilamento dos ficheiros de processamento"
(defun load-files (path)
                (progn 
                    (load (concatenate 'string path "\\puzzle.64ofasl")) 
                    (load (concatenate 'string path "\\procura.64ofasl"))
					(Menu path)
               )
)



"Menu Principal para depois de importar todos os ficheiro"
(defun Menu (path)
	(loop	
		(progn
            (format t "~%~%~%~%~%MENU~%")
			(format t "1 - Start Search~%")
			(format t "2 - Sair~%")
			(format t "Escreve a op��o - ")
			
			(let ((opcao (read)))
				(cond
					((not (numberp opcao)) (Menu path))		
					((and (<= opcao 2) (>= opcao 1)) (cond
														((= opcao 1) (Start-search path))
														((= opcao 2) (progn (format t "Saindo...")) (return))
													)
					)
					(T (progn
							(format t "~% Escolha invalida!~%")
							(format t "~% Escolha entre 1 ou 2~%")
							(format t "~%  ")
						)
					)
				)
			)
		)
	)
)

;; Start-search 
(defun Start-search (path) 
	(let* 	(	(algoritmo 						(read-algorithm))
				(numero-objectivo-caixas  		(read-num-boxes-close))
				(heuristica 					(cond ((not (or (eql algoritmo 'dfs) (eql algoritmo 'bfs))) (read-heuristic)) (T nil)))
				(no 							(start-no (read-tab path) numero-objectivo-caixas heuristica))
				(profundidade 					(cond ((eql algoritmo 'dfs) (read-depth)) (T nil)))
				(tempo-inicial 					(get-internal-real-time))
				(solucao 						(cond 
												((equal algoritmo 'dfs)  (funcall algoritmo no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) profundidade))
												((equal algoritmo 'a-star)  (funcall algoritmo no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) heuristica))
												(t  (bfs no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab)))
				)
				)
				(tempo-final(- (get-internal-real-time) tempo-inicial))
				
				

			)
			(cond
				((null solucao) (format t "~%Nao tem resultado~%"))
				
				(T
					(results no profundidade algoritmo heuristica solucao path)
				)
			)
	)
)


;; read-tab
(defun read-tab (path)
    (progn
        (format t "~%> Escolhe o problema") 
        (format t "~%> Problema 1 (A) - Objetivo Fechar 3 caixas")
        (format t "~%> Problema 2 (B) - Objetivo Fechar 7 caixas")
        (format t "~%> Problema 3 (C) - Objetivo Fechar 10 caixas")
        (format t "~%> Problema 4 (D) - Objetivo Fechar 10 caixas (TAB limpo)")
        (format t "~%> Problema 5 (E) - Objetivo Fechar 20 caixas")
        (format t "~%> Problema 6 (F) - Objetivo Fechar 35 caixas")
        (format t "~%> Escreve a op��o - ")        
        (let* ((opcao (read))
               (opcao-valida (lista-exists opcao '(1 2 3 4 5 6))))        
                    (cond 
					((not opcao-valida) (progn
                                                                              (format t "~% Escolha invalida!")
                                                                              (format t "~% Escolha entre 1 e 6~%")
                                                                              (read-tab path)))
					(T(with-open-file (ficheiro (concatenate 'string path "\\problemas.dat") :direction :input :if-does-not-exist :error)
                           (let ((lines (loop for line = (read ficheiro nil) while line collect line)))
							(nth (- opcao 1) lines))
                    ))
					)
        )
    )
)


(defun read-num-boxes-close ()
	(progn
		(format t "~% - Nr de caixas para fechar?")
		(format t "~% ")
		(let ((resposta (read)))
			(cond 
				((not (numberp resposta)) (read-num-boxes-close))
				((>= resposta 1) resposta)
				(T (read-num-boxes-close))))
	)
)


(defun read-algorithm ()
	(progn
		(format t "~% - Escolha o algoritmo")
		(format t "~% - bfs")
		(format t "~% - dfs")
		(format t "~% - a*")
		(format t "~% - ")
		
		(let* ((resposta (read))
				 (opcao-valida (lista-exists resposta '(bfs dfs a*))))		
			(cond 
				((equal resposta 'a*) 'a-star)
				(opcao-valida resposta)
				(T (progn
						(format t "~% - Escolha Invalida!")
						(format t "~% ")
						(read-algorithm)
					)
				)
			)
		)
	)
)

(defun read-heuristic () 
	(progn
		(format t "~% Escolha a heuristica") 
		(format t "~% 	1 - h(x)= o(x) - c(x)")
		(format t "~% 	2 - Proposta pelo grupo")
		(format t "~% ")
		
		(let* ((resposta (read)))
			(cond
				((or (not (numberp resposta)) (or (> resposta 2) (< resposta 1))) 
					(progn
						(format t "~% Escolha Invalida!")
						(format t "~% ")
						(read-heuristic)
					))		
				(T (cond
						((= resposta 1) 'heuristica)
						((= resposta 2) 'heuristica-extra)
					)
				)
			)
		)
	)
)

(defun read-depth () 
	(progn
		(format t "~% Qual a profundidade que pretende ?")
		(format t "~% ")
		(let ((resposta (read)))
			(cond 
				((not (numberp resposta)) 
					(progn
						(format t "~% Escolha Invalida!")
						(format t "~%  ")
						(read-depth)
					))
				(T resposta)
			)
		)
	)
)

(defun results (no-inicial profundidade-maxima algoritmo heuristica solucao diretoria)

	(let* 
		(
			(no-solucao (caar solucao))
			(lista-fechados (car (reverse solucao)))
			(tamanho-lista-fechados (length lista-fechados))
			(nos-gerados (+ tamanho-lista-fechados (length (nth 1 solucao))))
			(profundidade (second (car solucao)))
			(path (caminho (car solucao) lista-fechados))
			(valor-heuristico (cond ((not(numberp (third (car solucao))))0) (T(third (car solucao)))))
			(ramificacao (ramification-factor (length path) tamanho-lista-fechados))
		)	
		
		(format t "~%_________________________________________________________~%"  )
		(format t "~%Estado inicial: ~s ~%"  (car no-inicial))
		(format t "~%Estado final: ~s ~%" no-solucao)
		(format t "~%Profundidade maxima: ~s ~%" profundidade-maxima)
		(format t "~%Algoritmo: ~s ~%" algoritmo)
		(format t "~%Heuristica: ~s ~%" heuristica)
		(format t "~%Profundidade: ~s ~%" profundidade)
		(format t "~%Nos Gerados: ~s ~%" nos-gerados)
		(format t "~%Nos expandidos: ~s ~%" tamanho-lista-fechados )
		(format t "~%Penetrancia: ~s ~%" (penetrancia (car solucao) nos-gerados))
		(format t "~%Valor Heuristico do n� final: ~s ~%" valor-heuristico)
		(format t "~%Custo: ~s ~%" (+ valor-heuristico profundidade))
		(format t "~%Caminho ate solucao: ~s ~%" path)
		(format t "~%Tamanho da lista: ~s ~%" tamanho-lista-fechados)
		(format t "~%Fator de ramificacao: ~s ~%" ramificacao)
		;(format t "~%TEMPO: ~s ~%" tempo-algoritmo)
		;(format t "~%Caixas Ftempo-inicialechadas: ~s ~%" (caixas-fechadas (get-no-estado no-final)))
        (write-results-file no-inicial profundidade-maxima algoritmo heuristica solucao diretoria)
	)
)

(defun write-results-file (no-inicial profundidade-maxima algoritmo heuristica solucao diretoria)
(let* 
		(
			(no-solucao (caar solucao))
			(lista-fechados (car (reverse solucao)))
			(tamanho-lista-fechados (length lista-fechados))
			(nos-gerados (+ tamanho-lista-fechados (length (nth 1 solucao))))
			(profundidade (second (car solucao)))
			(path (caminho (car solucao) lista-fechados))
			(valor-heuristico (cond ((not(numberp (third (car solucao))))0) (T(third (car solucao)))))
			(ramificacao (ramification-factor (length path) tamanho-lista-fechados))
		)
						
		(with-open-file (ficheiro (concatenate 'string diretoria "\\estatisticas.dat") :direction :output :if-exists :append :if-does-not-exist :create)
		(format ficheiro "~%_________________________________________________________~%"  )
		(format ficheiro "~%Estado inicial: ~s ~%"  (car no-inicial))
		(format ficheiro "~%Estado final: ~s ~%" no-solucao)
		(format ficheiro "~%Profundidade maxima: ~s ~%" profundidade-maxima)
		(format ficheiro "~%Algoritmo: ~s ~%" algoritmo)
		(format ficheiro "~%Heuristica: ~s ~%" heuristica)
		(format ficheiro "~%Profundidade: ~s ~%" profundidade)
		(format ficheiro "~%Nos Gerados: ~s ~%" nos-gerados)
		(format ficheiro "~%Nos expandidos: ~s ~%" tamanho-lista-fechados )
		(format ficheiro "~%Penetrancia: ~s ~%" (penetrancia (car solucao) nos-gerados))
		(format ficheiro "~%Caminho ate solucao: ~s ~%" path)
		(format ficheiro "~%Fator de ramificacao: ~s ~%" ramificacao)
		(format ficheiro "~%Valor Heuristico do n� final: ~s ~%" valor-heuristico)
		(format ficheiro "~%Custo: ~s ~%" (+ valor-heuristico profundidade))
		(format ficheiro "~%Caminho ate solucao: ~s ~%" path)
		)

)
)

(defun lista-exists (elemento lista)
	(cond
		((null lista) nil)
		((eql elemento (car lista)) T)
		(T (lista-exists elemento (cdr lista)))
	)
)

(defun current-date-string () "Retorna a data no formato de string"
	(multiple-value-bind (sec min hr dow dst-p tz)
		(get-decoded-time)
		(declare (ignore dow dst-p tz))	
		(format nil "~A-~A-~A " hr min sec)
	)
)










