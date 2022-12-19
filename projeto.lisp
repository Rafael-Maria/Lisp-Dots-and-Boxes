(defun Start()
"Forma de iniciar o problema"
	(progn
		(let ((path (Insert-diretory)))
			  (compile-files path)
    	 )
	)
)


(defun Insert-diretory()
"Função para o utilizador indicar o caminho onde os ficheiros do programa se encontram" 
    (progn
        (format t "Path para o diretorio dos ficheiros de processamento - ")
        (format nil (read-line))
    )
)

(defun compile-files (path)
"Função para compilar os ficheiros do programa"
                (progn 
                    (compile-file (concatenate 'string path "\\puzzle.lisp"))
                    (compile-file (concatenate 'string path "\\procura.lisp"))
					(load-files path)
               )
)

(defun load-files (path)
"Função para fazer o load dos ficheiros compilados"
                (progn 
                    (load (concatenate 'string path "\\puzzle.64ofasl")) 
                    (load (concatenate 'string path "\\procura.64ofasl"))
					(Menu path)
               )
)


(defun Menu (path)
"Menu Principal da aplicação"
	(loop	
		(progn
            (format t "~%~%~%~%~%MENU~%")
			(format t "1 - Start Search~%")
			(format t "2 - Sair~%")
			(format t "Escreve a opção - ")
			
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
"Função utilizada para permitir iniciar a procura" 
	(let* 	(	(algoritmo 						(read-algorithm))
				(numero-objectivo-caixas  		(read-num-boxes-close))
				(heuristica 					(cond ((not (or (eql algoritmo 'dfs) (eql algoritmo 'bfs))) (read-heuristic)) (T nil)))
				(no 							(start-no (read-tab path) numero-objectivo-caixas heuristica))
				(profundidade 					(cond ((eql algoritmo 'dfs) (read-depth)) (T nil)))
				(solucao 						(cond 
												((equal algoritmo 'dfs)  (funcall algoritmo no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) profundidade))
												((equal algoritmo 'a-star)  (funcall algoritmo no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) heuristica))
												(t  (bfs no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab)))
 )
				)

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
"Função usada para ler qual tabuleiro para utilizar"
	(progn
		(format t "~%> Escolhe o problema") 
		(format t "~%> Problema A - Objetivo Fechar 3 caixas")
		(format t "~%> Problema B - Objetivo Fechar 7 caixas")
		(format t "~%> Problema C - Objetivo Fechar 10 caixas")
		(format t "~%> Problema D - Objetivo Fechar 10 caixas (Tabuleiro limpo)")
		(format t "~%> Problema E - Objetivo Fechar 20 caixas")
		(format t "~%> Problema F - Objetivo Fechar 35 caixas")
		(format t "~%> Escreve a opção - ")
		
		(let* ((opcao (read))
			   (opcao-valida (lista-exists opcao '(a b c d e f))))		
					(with-open-file (ficheiro (concatenate 'string path "\\problemas.dat") :direction :input :if-does-not-exist :error)
					
						(cond
							((not opcao-valida) (progn
													(format t "~% Escolha invalida!")
													(format t "~% Escolha entre A a F")
													(read-tab path)))
							((equal opcao 'a) (nth 0 (read ficheiro)))
							((equal opcao 'b) (nth 1 (read ficheiro)))
							((equal opcao 'c) (nth 2 (read ficheiro)))
							((equal opcao 'd) (nth 3 (read ficheiro)))
							((equal opcao 'e) (nth 4 (read ficheiro)))
							((equal opcao 'f) (nth 5 (read ficheiro)))
						)
					)
		)
	)
)


(defun read-num-boxes-close ()
"Função usada para ler quantas caixas o utilizador quer fechadas"
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
"Função usada para ler qual o algoritmo"
	(progn
		(format t "~% - Escolha o algoritmo")
		(format t "~% - bfs")
		(format t "~% - dfs")
		(format t "~% - a*")
		(format t "~% - ")
		
		(let* ((resposta (read))
				 (opcao-valida (lista-exists resposta '(bfs dfs))))		
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
"Função usada para ler qual a heuristica que o utilizador quer" 
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
"Função usada para ler qual a profundida máxima" 
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
"Função usada para imprimir e guardar os resultados obtidos"
	(let* 
		(
			(tamanho-lista-abertos (nth 3 (car solucao)))
			(no-solucao (caar solucao))
			(tamanho-lista-fechados (length (car ( reverse solucao))))
			(nos-gerados (+ tamanho-lista-fechados (length (nth 1 solucao))))
			(profundidade (second (car solucao)))
			;(no-final (get-no-estado solucao))
			;(path (path-solucao no-solucao))
			(valor-heuristico (third (car solucao)))
		)
						
		
		(format t "~%Estado inicial: ~s ~%"  (car no-inicial))
		(format t "~%Estado final: ~s ~%" no-solucao)
		(format t "~%Profundidade maxima: ~s ~%" profundidade-maxima)
		(format t "~%Algoritmo: ~s ~%" algoritmo)
		(format t "~%Heuristica: ~s ~%" heuristica)
		(format t "~%Profundidade: ~s ~%" profundidade)
		(format t "~%Nos Gerados: ~s ~%" nos-gerados)
		(format t "~%Nos expandidos: ~s ~%" (- tamanho-lista-fechados 1))
		;(format t "~%Penetrancia: ~s ~%" (penetrancia no-final nos-gerados))
		;(format t "~%Fator de Ramificacao: ~s ~%" (fator-ramificacao profundidade tamanho-lista-fechados))
		(format t "~%Valor Heuristico: ~s ~%~%~%~%" valor-heuristico)
		;(format t "~%path ate a solucao: ~s ~%" path)	
		;(format t "~%Caixas Ftempo-inicialechadas: ~s ~%" (caixas-fechadas (get-no-estado no-final)))
        (write-results-file no-inicial profundidade-maxima algoritmo heuristica solucao diretoria)
	)
)

(defun write-results-file (no-inicial profundidade-maxima algoritmo heuristica solucao diretoria)
"Função usada para guardar os resultados obtidos"
(let* 
		(
			(tamanho-lista-abertos (nth 3 (car solucao)))
			(no-solucao (caar solucao))
			(tamanho-lista-fechados (length (car ( reverse solucao))))
			(nos-gerados (+ tamanho-lista-fechados (length (nth 1 solucao))))
			(profundidade (second (car solucao)))
			;(no-final (get-no-estado solucao))
			;(path (path-solucao no-solucao))
			(valor-heuristico (third (car solucao)))
		)
						
		(with-open-file (ficheiro (concatenate 'string diretoria "\\estatisticas.dat") :direction :output :if-exists :append :if-does-not-exist :create)
		(format ficheiro "~%Estado inicial: ~s ~%"  (car no-inicial))
		(format ficheiro "~%Estado final: ~s ~%" no-solucao)
		(format ficheiro "~%Profundidade maxima: ~s ~%" profundidade-maxima)
		(format ficheiro "~%Algoritmo: ~s ~%" algoritmo)
		(format ficheiro "~%Heuristica: ~s ~%" heuristica)
		(format ficheiro "~%Profundidade: ~s ~%" profundidade)
		(format ficheiro "~%Nos Gerados: ~s ~%" nos-gerados)
		(format ficheiro "~%Nos expandidos: ~s ~%" (- tamanho-lista-fechados 1))
		(format ficheiro "~%Valor Heuristico: ~s ~%~%~%~%" valor-heuristico)
		;(format t "~%path ate a solucao: ~s ~%" path)	
		;(format t "~%Caixas Ftempo-inicialechadas: ~s ~%" (caixas-fechadas (get-no-estado no-final)))
		;(format t "~%Penetrancia: ~s ~%" (penetrancia no-final nos-gerados))
		;(format t "~%Fator de Ramificacao: ~s ~%" (fator-ramificacao profundidade tamanho-lista-fechados))
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









