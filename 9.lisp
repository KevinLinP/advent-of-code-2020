(load "~/quicklisp/setup.lisp")
(ql:quickload "alexandria")
(ql:quickload "iterate")
(use-package :iterate)

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

(iterate
  (for target in-vector numbers)
  (for target-index from 0)
  (for upper-index from -1)
  (for lower-index from (- 0 preamble))
  (for index-to-remove from (- 0 preamble 1))
  ;(format t "~d ~d ~d ~d ~d ~%" target target-index upper-index lower-index index-to-remove)
  (if (>= upper-index 0)
    (setf (gethash (aref numbers upper-index) *current-numbers*) T))
  ;(if (>= index-to-remove 0)
    ;(remhash (aref numbers index-to-remove) *current-numbers*)
  (if (< lower-index 0) (next-iteration))
  (iterate
    (for current-index from lower-index to upper-index)
    (format t "~d " (aref numbers current-index)))
  (format t "~%")
  )

;(defparameter lower-index-start (+ (* -1 preamble) 1))
;(defparameter index-to-remove-start (* -1 preamble))
;(loop for num across numbers
      ;for upper-index from -1
      ;for lower-index from (- 0 preamble)
      ;for index-to-remove from (- 0 preamble 1)
      ;do (setf (gethash num *current-numbers*) T)
      ;if (>= index-to-remove 0)
      ;do (remhash (aref numbers index-to-remove) *current-numbers*)
      ;if (>= lower-index 0)
      ;do (loop
           ;for current-index from lower-index
           ;while (and (<= current-index upper-index) ())
           ;do (format t "~d~%" current-index))
      ;do (format t "~%"))
