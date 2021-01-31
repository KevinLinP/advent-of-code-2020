(load "~/quicklisp/setup.lisp")
(ql:quickload "alexandria")

(defparameter number-list
  (with-open-file (input "9.input.sample")
    (loop for line = (read-line input nil)
          while line
          collect (parse-integer line))))

(defparameter numbers
  (make-array
    (list (length number-list))
    :initial-contents number-list))

(defparameter *current-numbers* (make-hash-table))

(loop for num across numbers
      for i from 0
      do (setf (gethash num *current-numbers*) T)
      if (> i 24)
      do (remhash (aref numbers (- num 25)) *current-numbers*))
