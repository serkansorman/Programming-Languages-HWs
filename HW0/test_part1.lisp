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
(setf resultList nil)

(defun helper (nestedList) 
  (if nestedList
    (if (atom (car nestedList))
      ;if the current element is not list, it is push it to the list then navigated on the rest of the list recursively
      (progn
        (push (car nestedList) resultList) 
        (helper (cdr nestedList))
      )
      ;if the current element is a list, navigated on this list recursively
      (progn 
        (helper (car nestedList))
        (helper (cdr nestedList))
      )
    )
    resultList
  )
)

(defun list-leveller (nestedList)
    (if  nestedList
      (progn
        (setf resultList nil) ;; Reset resultList on each function call
        (reverse (helper nestedList)) ;; reverse the result list
      )
      nil
    )
)

;; MAIN FUNCTION
(defun main ()
  (with-open-file (stream #p"input_part1.csv")
    (loop :for line := (read-csv-line stream) :while line :collect
      (format t "~a~%"
      ;; CALL YOUR (MAIN) FUNCTION HERE
      (list-leveller (read-from-string (nth 0 line)))

      )
    )
  )
)

;; CALL MAIN FUNCTION
(main)
