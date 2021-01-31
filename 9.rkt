#lang racket

; i couldn't get this running from CLI, so i'm using Dr. Racket.
; i did not enjoy Common Lisp's documentation, but had a much better
; time with Racket. it was mostly the 'for loop' weirdness that killed me.
; elegant to read and write, but somewhat difficult to change sometimes.

(define window-size 25)
(define input-file (open-input-file "9.input"))

(define numbers
  (for/vector ([line (in-lines input-file)])
    (string->number line)))
(close-input-port input-file)

(for ([target numbers]
      [lower-index (in-range (- 0 window-size) 9999999)]
      [upper-index (in-range -1 9999999)]
      #:when (>= lower-index 0))
  (printf "~a~%" target)
  
  (define number-window
    (for/list ([i (in-range lower-index (+ upper-index 1))]) ; exclusive at top!
      (vector-ref numbers i)))
  ;(for ([num number-window]) (printf "~a " num))

  (define valid-pair
    (for/first ([pair (in-combinations number-window 2)]
              #:when (eq? target (apply + pair)))
      pair))
  #:break (not valid-pair)

  (printf "(~a ~a)" (first valid-pair) (last valid-pair))
  (printf "~%~%")
  )