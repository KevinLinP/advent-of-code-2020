#lang racket

; i couldn't get this running from CLI, so i'm using Dr. Racket.
; i did not enjoy Common Lisp's documentation, but had a much better
; time with Racket. it was mostly the 'for loop' weirdness that killed me.
; elegant to read and write, but somewhat difficult to change sometimes.

(define debug-part-1 #f)
(define window-size 25)
(define input-file (open-input-file "9.input"))

(define numbers
  (for/vector ([line (in-lines input-file)])
    (string->number line)))
(close-input-port input-file)

(define last-target 0)

(for ([target numbers]
      [lower-index (in-range (- 0 window-size) 9999999)]
      [upper-index (in-range -1 9999999)]
      #:when (>= lower-index 0))
  (cond [debug-part-1 (printf "~a " target)])
  
  (define number-window
    (for/list ([num (in-vector numbers lower-index (+ upper-index 1))]) num)) ; exclusive at top!
  ;(for ([num number-window]) (printf "~a " num))

  ; maintaining a HashSet to check for pair is algorithmically faster
  (define valid-pair
    (for/first ([pair (in-combinations number-window 2)]
                #:when (eq? target (apply + pair)))
      pair))
  
  (cond [(not valid-pair) (set! last-target target)])
  #:break (not valid-pair)

  (cond
    [debug-part-1
     (printf "(~a ~a) " (first valid-pair) (last valid-pair))
     (printf "~%")]))
  
(printf "~%~%last-target: ~a~%~%" last-target)

(for ([lower numbers]
      [lower-index (in-naturals)]
      #:when (< lower last-target))
  (for ([upper (in-vector numbers (+ lower-index 1))]
        [upper-index (in-naturals (+ lower-index 1))])
    (define sum
      (for/sum ([num (in-vector numbers lower-index (+ upper-index 1))]) num))
    #:break (> sum last-target)
    (cond
      [(eq? sum last-target)
       (define min last-target)
       (define max 0)
       (for ([current-num (in-vector numbers lower-index (+ upper-index 1))])
         (cond [(< current-num min) (set! min current-num)])
         (cond [(> current-num max) (set! max current-num)])
         )
       (printf "[~a..~a] ~a + ~a = ~a~%" lower-index upper-index min max (+ min max))])
    ))