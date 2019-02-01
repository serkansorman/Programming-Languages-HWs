
(setq KEYWORDS '("and" "or" "not" "equal"  
				"append" "concat" "set" "deffun" 
				"for" "while" "if" "exit" "true" "false"))

(setq OPERATORS '("+" "-" "/" "*" "(" ")" "**"))

(setq start_index 0) ;Indicates beginning of current sub string
(setq flag 0) ;Indicates whether current word is a keyword or not


(defun get-file (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          	collect line
    )
  )
)

(defun is_alpha (symbol)
	(and (> (char-code (aref symbol 0)) 64) (< (char-code (aref symbol 0)) 123))
)

(defun is_digit (symbol)
      (and (> (char-code (aref symbol 0)) 47) (< (char-code (aref symbol 0)) 58))
)

(defun lexer (filename)
	(setq file_as_list (get-file filename))
	(setq token_list nil)


	(loop for line in file_as_list
		do
		(loop for index from 0 to (- (length line) 1)

			do ;Detects Positive Integers
        	(if (and (< index (length line)) (is_digit (string (aref line index)))) 

        		(progn
		        	(setq digits "")
					(loop while (and (< index (length line)) (is_digit (string (aref line index))))
						do
						(setq digits (concatenate 'string digits (string (aref line index))))
	       				(setq index (+ index 1))

	       			)
	       			(setq index (- index 1))
	       			(push (append (list "integer") (list digits)) token_list)
	       		)

			)


			;Detects Operators
        	(if (position (string (aref line index)) OPERATORS :test #'string=)

        		(progn
        			;Check for ** operator
        			(if (and (string-equal "*" (string (aref line index)))  
        			 	(< index (- (length line) 1)) (string-equal "*" (string (aref line (+ 1 index)))))
	        			(progn
	        				(push (append (list "operator") (list "**")) token_list)
	        				(setq index (+ 1 index))

	        			)
	        			;Detects Negative integers
	        			(if (and (< index (- (length line) 1)) (string-equal "-" (string (aref line index))) (is_digit (string (aref line (+ index 1)))))

    						(progn
	        					(setq digits "-")
	        					(setq index (+ index 1))
								(loop while (and (< index (length line)) (is_digit (string (aref line index))))
									do
									(setq digits (concatenate 'string digits (string (aref line index))))
       								(setq index (+ index 1))

       							)
								(push (append (list "integer") (list digits)) token_list)
       							(if (position (string (aref line index)) OPERATORS :test #'string=)
       								 (setq index (- index 1))
       							)
       						)
	        				(push (append (list "operator") (list(string (aref line index)))) token_list)
        				)
	        		)
        		)		
        	)

        	;Detects Keywords and Identifiers
			do 
			(if (and (< index (length line)) (is_alpha (string (aref line index))))

				(progn
					;Detects Keywords
					(loop for key_word in KEYWORDS
			      		
			      		do (setq first_occur (search key_word (substring line start_index (+ 1 index)) :test #'string=))
			      		(if first_occur
		      				(progn
		   						
		   						;Prevents read as a keyword such identifiers that includes keywords "factORial" "multipicAND" etc.
		      					(if (and (> first_occur 0) (null (is_alpha (string (aref (substring line start_index (+ 1 index)) (- first_occur 1)))))
		      						  (or (= index (- (length (substring line start_index index)) 1)) (null (is_alpha (string (aref (substring line start_index (+ index 2)) (+ first_occur (length key_word))))))))

		      						(progn
		      							(if (or (string-equal key_word "true") (string-equal key_word "false"))
				      						(push (append (list "bool") (list key_word)) token_list)
				      						(push (append (list "keyword") (list key_word)) token_list)
				      					)
					      				(setq start_index (+ start_index 1 (length key_word)))
					      				(setq flag 1)
					      			)
				      			)
		      				)	
			      		)
			      	)
					;Detects Identifiers
			      	(if (and (= flag 0)  ( or (= index (- (length line) 1)) (null (is_alpha (string (aref line (+ 1 index)))))))

			      		(progn
			      			(setq sub_str_length (length (substring line start_index (+ 1 index))))
			      			(setq count (- sub_str_length 1))
			      			(setq sub_str (string (substring line start_index (+ 1 index))))

     						(loop while (and (> count -1) (is_alpha (string (aref sub_str count))))
       							do(setq count (- count 1))
       						)
     						(push (append (list "identifier") (list(substring sub_str (+ 1 count) sub_str_length))) token_list)
			      		)
			      	)
			      	(setq flag 0)
			    )
		    )  	
       )
       (setq start_index 0)	  
    )
    (reverse token_list)
)