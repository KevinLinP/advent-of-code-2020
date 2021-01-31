(load "~/quicklisp/setup.lisp")
(ql:quickload "alexandria")
(ql:quickload "iterate")
(use-package :iterate)

(defparameter preamble 25)

(defparameter number-list
  (with-open-file (input "9.input")
    (loop for line = (read-line input nil)
          while line
          collect (parse-integer line))))

(defparameter numbers
  (make-array
    (list (length number-list))
    :initial-contents number-list))

; part 1
;(iterate
  ;(for target in-vector numbers)
  ;(for target-index from 0)
  ;(for upper-index from -1)
  ;(for lower-index from (- 0 preamble))
  ;;(for index-to-remove from (- 0 preamble 1))
  ;;(format t "~d ~d ~d ~d ~d ~%" target target-index upper-index lower-index index-to-remove)
  ;;(if (>= upper-index 0)
    ;;(setf (gethash (aref numbers upper-index) *current-numbers*) T))
  ;;(if (>= index-to-remove 0)
    ;;(remhash (aref numbers index-to-remove) *current-numbers*)
  ;(if (< lower-index 0) (next-iteration))
  ;(format t "~d: " target)
  ;(iterate
    ;(for left-index from lower-index to (- upper-index 1))
    ;(for left-number = (aref numbers left-index))
    ;(iterate
      ;(for right-index from (+ left-index 1) to upper-index)
      ;(for right-number = (aref numbers right-index))
      ;(for total = (+ left-number right-number))
      ;(if (eq target total) (format t "~d ~d " left-number right-number))
      ;)
    ;)
  ;(format t "~%")
  ;)
