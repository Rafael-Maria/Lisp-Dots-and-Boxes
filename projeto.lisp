;__________________________________________INICIO_________________________
(defun Start()
"Função para iniciar o programa todo"
	(progn
		(let ((path (Insert-diretory)))
			  (compile-files path))
	)
)

(defun Insert-diretory()
"Função para colocar qual o path, em que está os ficheiros" 
    (progn
        (format t "Path para o diretorio dos ficheiros de processamento - ")
        (format nil (read-line))
    )
)

(defun compile-files (path)
"Função que compila os ficheiros necessários localizados na path fornecida "
     (progn 
       (compile-file (concatenate 'string path "\\puzzle.lisp"))
       (compile-file (concatenate 'string path "\\procura.lisp"))
       (load-files path)
     )
)

(defun load-files (path)
"Função que faz o load dos ficheiros criados pela função compile-files"
   (progn 
    (load (concatenate 'string path "\\puzzle.64ofasl")) 
    (load (concatenate 'string path "\\procura.64ofasl"))
    (Menu path)
   )
)

;_____________________________________________________Menus_________________________________
(defun Menu (path)
"Menu Principal da Aplicação"
	(progn
            (format t "~%~%~%~%~%MENU~%")
            (format t "1 - Start Search~%")
            (format t "2 - Sair~%")
            (format t "Escreve a opção - ")	
            (let ((opcao (read)))
		(cond((not (numberp opcao)) (Menu path))		
                     ((and (<= opcao 2) (>= opcao 1)) (cond((= opcao 1) (progn(Start-search path)(Menu path)))
                                                           ((= opcao 2) (progn (format t "Terminando")))
							)
                      )
                     (T (progn
                          (format t "~% Escolha invalida!~%")
                          (format t "~% Escolha entre 1 ou 2~%")
                          (format t "~%  ")
                          (Menu path)
			)
                      )
		)
             )
        )
)

;; Start-search 
(defun Start-search (path)
"Função que inicia a Procura" 
	(let* 	(	(algoritmo 						(read-algorithm))
                        (tab (read-tab path))
			(numero-objectivo-caixas  		(read-num-boxes-close tab))
			(heuristica 					(cond ((not (or (eql algoritmo 'dfs) (eql algoritmo 'bfs))) (read-heuristic)) (T nil)))
			(no 							(start-no tab numero-objectivo-caixas heuristica))
			(profundidade 					(cond ((eql algoritmo 'dfs) (read-depth)) (T nil)))
                        (limit (cond ((equal algoritmo 'ida-star) (read-limit))(t nil)))
			(tempo-inicial 					(get-internal-run-time))
			(solucao 						(cond ((equal algoritmo 'dfs)  (funcall algoritmo no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) profundidade))
                                                                                      ((equal algoritmo 'a-star)  (funcall algoritmo no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) heuristica))
                                                                                      ((equal algoritmo 'ida-star)  (funcall algoritmo no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab) limit heuristica no))
                                                                                      (t  (bfs no 'solution-found 'sucessores '(insert-vertical-sucessor-tab insert-horizontal-sucessor-tab)))
                                                                                      )
                        )		
		)
		(cond((null solucao) (format t "~%Nao tem resultado~%"))
			(T(results no profundidade algoritmo heuristica solucao path tempo-inicial))
		)
	)
)


;____________________________________________________LEITURAS________________________________________
(defun read-tab (path)
"Função que lêm um tabuleiro do Ficheiro problemas.dat, encontrado na path" 
    (progn
        (format t "~%> Escolhe o problema") 
        (format t "~%> Problema 1 (A) - Objetivo Fechar 3 caixas")
        (format t "~%> Problema 2 (B) - Objetivo Fechar 7 caixas")
        (format t "~%> Problema 3 (C) - Objetivo Fechar 10 caixas")
        (format t "~%> Problema 4 (D) - Objetivo Fechar 10 caixas (TAB limpo)")
        (format t "~%> Problema 5 (E) - Objetivo Fechar 20 caixas")
        (format t "~%> Problema 6 (F) - Objetivo Fechar 35 caixas")
        (format t "~%> Escreve a opção - ")        
        (let* ((opcao (read))
               (opcao-valida (lista-exists opcao '(1 2 3 4 5 6))))        
                    (cond ((not opcao-valida) (progn
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


(defun read-num-boxes-close (tab)
"Função que realiza a leitura do nr de caixas que o utilizador quer fechar no tabuleiro" 
	(progn
		(format t "~% - Nr de caixas para fechar?")
		(format t "~% ")
		(let ((resposta (read))
			(max-value (* (length (car(car tab))) (length (car(car(cdr tab)))))))
			(cond 
				((not (numberp resposta)) (read-num-boxes-close tab))
				((> resposta max-value) (progn (format t "~% Valor escolhido elevado para o tabuleiro!")(read-num-boxes-close tab)))
				((>= resposta 1) resposta)
				(T (read-num-boxes-close tab))))
	)
)

(defun read-limit ()
"Função que realiza a leitura do limit inicial do algoritmo ida*" 
	(progn
		(format t "~% - Valor inicial do limite?")
		(format t "~% ")
		(let ((resposta (read)))
			(cond 
				((not (numberp resposta)) (read-limit))
				((>= resposta 1) resposta)
				(T (read-limit))))
	)
)


(defun read-algorithm ()
"Função que realiza a leitura de qual algoritmo aplicar no tabuleiro" 
	(progn
		(format t "~% - Escolha o algoritmo")
		(format t "~% - bfs")
		(format t "~% - dfs")
		(format t "~% - a*")
                (format t "~% - ida* (incompleto?)")
		(format t "~% - ")
		
		(let* ((resposta (read))
				 (opcao-valida (lista-exists resposta '(bfs dfs a* ida*))))		
			(cond 
				((equal resposta 'a*) 'a-star)
                                ((equal resposta 'ida*) 'ida-star)
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
"Função que realiza a leitura de qual heuristica aplicar ao algoritmo a*" 
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
"Função que realiza a leitura de qual profundidade máxiam que se aplica ao algoritmo dfs"  
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


;_______________________________________________________________________________Resultados______________________________________________________________
(defun results (no-inicial profundidade-maxima algoritmo heuristica solucao diretoria tempo-inicial)
"Função que permite mostrar os resultados obtidos no listener" 
	(let* 
		(
                 (tempo (- (get-internal-run-time) tempo-inicial))
			(no-solucao (caar solucao))
			(lista-fechados (car (reverse solucao)))
			(tamanho-lista-fechados (length lista-fechados))
			(nos-gerados (+ tamanho-lista-fechados (length (nth 1 solucao))))
			(profundidade (second (car solucao)))
			(path (caminho (car solucao) lista-fechados))
			(valor-heuristico (cond ((not(numberp (third (car solucao))))0) (T(third (car solucao)))))
			(ramificacao (ramification-factor (length path) nos-gerados))
		)	
		
		(format t "~%_________________________________________________________~%"  )
                (format t "~%Tempo: ~s ms ~%" tempo)
		(format t "~%Estado inicial: ~s ~%"  (car no-inicial))
		(format t "~%Estado final: ~s ~%" no-solucao)
		(format t "~%Profundidade maxima: ~s ~%" profundidade-maxima)
                (format t "~%Profundidade: ~s ~%" profundidade)
		(format t "~%Algoritmo: ~s ~%" algoritmo)
		(format t "~%Heuristica: ~s ~%" heuristica)
		(format t "~%Nos Gerados: ~s ~%" nos-gerados)
		(format t "~%Nos expandidos: ~s ~%" tamanho-lista-fechados )
		(format t "~%Valor Heuristico do nó final: ~s ~%" valor-heuristico)
		(format t "~%Custo: ~s ~%" (+ valor-heuristico profundidade))
                (format t "~%Penetrancia: ~s ~%" (penetrancia (car solucao) nos-gerados))
                (format t "~%Fator de ramificacao: ~s ~%" ramificacao)
		(format t "~%Caminho ate solucao: ~%")
                (print-path path)
		(format t "~%Tamanho da lista: ~s ~%" tamanho-lista-fechados)
		;(format t "~%Caixas Ftempo-inicialechadas: ~s ~%" (caixas-fechadas (get-no-estado no-final)))
        (write-results-file no-inicial profundidade-maxima algoritmo heuristica solucao diretoria tempo no-solucao tamanho-lista-fechados nos-gerados profundidade path valor-heuristico ramificacao)
	)
)

(defun write-results-file (no-inicial profundidade-maxima algoritmo heuristica solucao diretoria tempo no-solucao tamanho-lista-fechados nos-gerados profundidade path valor-heuristico ramificacao)
"Função que armazena os resultados obtidos num ficheiro chamado estatisticas.dat, localizado na path fornecida" 
(with-open-file (ficheiro (concatenate 'string diretoria "\\estatisticas.dat") :direction :output :if-exists :append :if-does-not-exist :create)
		(format ficheiro "~%_________________________________________________________~%"  )
                (format ficheiro "~%Tempo: ~s ms ~%" tempo)
		(format ficheiro "~%Estado inicial: ~s ~%"  (car no-inicial))
		(format ficheiro "~%Estado final: ~s ~%" no-solucao)
		(format ficheiro "~%Profundidade maxima: ~s ~%" profundidade-maxima)
                (format ficheiro "~%Profundidade: ~s ~%" profundidade)
		(format ficheiro "~%Algoritmo: ~s ~%" algoritmo)
		(format ficheiro "~%Heuristica: ~s ~%" heuristica)
		(format ficheiro "~%Nos Gerados: ~s ~%" nos-gerados)
		(format ficheiro "~%Nos expandidos: ~s ~%" tamanho-lista-fechados )
		(format ficheiro "~%Valor Heuristico do nó final: ~s ~%" valor-heuristico)
		(format ficheiro "~%Custo: ~s ~%" (+ valor-heuristico profundidade))
                (format ficheiro "~%Penetrancia: ~s ~%" (penetrancia (car solucao) nos-gerados))
                (format ficheiro "~%Fator de ramificacao: ~s ~%" ramificacao)
		(format ficheiro "~%Caminho ate solucao: ~s ~%" path)
		(format ficheiro "~%Tamanho da lista: ~s ~%" tamanho-lista-fechados)
                )
)

(defun lista-exists (elemento lista)
"Função auxiliar usada para verificar se um elemento existe numa determinada lista"
	(cond
		((null lista) nil)
		((eql elemento (car lista)) T)
		(T (lista-exists elemento (cdr lista)))
	)
)

(defun print-path(path &optional (ficheiro t))
"Função para imprimeir o caminho"
  (cond
   ((= 1(length path)) (format ficheiro "~s ~%" (car path)))
   (t (progn (format ficheiro "~s ~%" (car path)) (print-path (cdr path))))
   )
)











