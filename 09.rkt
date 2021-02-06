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

(define number-window
  (for/mutable-set ([num (in-vector numbers 0 window-size)]) num))
;(for ([num number-window-set]) (printf "~a " num))

(define unfilled-target null)
(for ([target (in-vector numbers window-size)]
      [lower (in-vector numbers 0)]
      [upper (in-vector numbers (- window-size 1))]
      [index-to-remove (in-range -1 99999999)])
  
  (cond [debug-part-1 (printf "~a " target)])

  (set-add! number-window upper)
  (cond [(>= index-to-remove 0) (set-remove! number-window (vector-ref numbers index-to-remove))])

  ; this was originally done by creating a list from the 'vector window'
  ; to pass into (combinations .. 2), and then looking for a pair
  ; that sums correctly
  (define valid-pair null)
  (for ([num (in-mutable-set number-window)])
    (define other-num (- target num))
    (cond [(set-member? number-window other-num) (set! valid-pair (cons num other-num))])
    #:break (not (null? valid-pair))
    #f)
  
  (cond [(null? valid-pair) (set! unfilled-target target)])
  #:break (not (null? unfilled-target))

  (cond
    [debug-part-1
     (printf "(~a ~a) " (car valid-pair) (cdr valid-pair))
     (printf "~%")]))
  
(printf "unfilled-target: ~a~%" unfilled-target)

(define sum-indicies null)

(for ([lower numbers]
      [lower-index (in-naturals)]
      #:when (< lower unfilled-target))
  (for ([upper (in-vector numbers (+ lower-index 1))]
        [upper-index (in-naturals (+ lower-index 1))])
    (define sum
      (for/sum ([num (in-vector numbers lower-index (+ upper-index 1))]) num))
    #:break (> sum unfilled-target)
    (cond [(eq? sum unfilled-target) (set! sum-indicies (cons lower-index upper-index))])
    #:break (not (null? sum-indicies))
    #f)
  #:break (not (null? sum-indicies))
  #f)

(printf "[~a..~a] " (car sum-indicies) (cdr sum-indicies))

(define min unfilled-target)
(define max 0)
(for ([current-num (in-vector numbers (car sum-indicies) (+ (cdr sum-indicies) 1))])
  (cond [(< current-num min) (set! min current-num)])
  (cond [(> current-num max) (set! max current-num)])
  )
(printf "~a + ~a = ~a~%" min max (+ min max))