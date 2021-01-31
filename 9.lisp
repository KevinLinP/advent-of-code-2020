(load "~/quicklisp/setup.lisp")
(ql:quickload "alexandria")

(defparameter preamble 5)

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

(defparameter lower-index-start (+ (* -1 preamble) 1))
(defparameter index-to-remove-start (* -1 preamble))
(loop for num across numbers
      for upper-index from -1
      for lower-index from (- 0 preamble)
      for index-to-remove from (- 0 preamble 1)
      do (setf (gethash num *current-numbers*) T)
      if (>= index-to-remove 0)
      do (remhash (aref numbers index-to-remove) *current-numbers*)
      if (>= lower-index 0)
      do (loop
           for current-index from lower-index
           while (<= current-index upper-index)
           do (format t "~d~%" current-index))
      do (format t "~%"))
