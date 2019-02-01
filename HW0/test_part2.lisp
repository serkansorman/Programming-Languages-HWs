(load "csv-parser.lisp")
(in-package :csv-parser)

;; (read-from-string STRING)
;; This function converts the input STRING to a lisp object.
;; In this code, I use this function to convert lists (in string format) from csv file to real lists.

;; (nth INDEX LIST)
;; This function allows us to access value at INDEX of LIST.
;; Example: (nth 0 '(a b c)) => a

;; !!! VERY VERY VERY IMPORTANT NOTE !!!
;; FOR EACH ARGUMENT IN CSV FILE
;; USE THE CODE (read-from-string (nth ARGUMENT-INDEX line))
;; Example: (mypart1-funct (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))

;; DEFINE YOUR FUNCTION(S) HERE

 (defun merge-lists (list1 list2)
     (cond 
      ;; if one of the lists is null, return the non-empty list
     	((null list1) list2)
  	 	((null list2) list1)
  	 	((cons (car list1) (merge-lists (cdr list1) list2))) ;; add list1 elements to list2 recursively
  	 )
 )

;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part2.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
      (merge-lists (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))
      
      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
