#!/usr/bin/guile -s
!#
(use-modules (ice-9 textual-ports)) ; ports = IO
(use-modules (srfi srfi-1)) ; map, fold

(define (display-line obj)
  "Display an object followed by a newline."
  (display obj)
  (newline))

(display "Hello, world!\n")

(define (santa_move char)
    (cond
      ((char=? char #\() 1)
      ((char=? char #\)) -1)
      (else 0)))

(define (pt1 text)
  (fold + 0 (map santa_move (string->list text))))

(define data (get-string-all (open-file "./input.txt" "r" )))
(display-line (pt1 data))

(define (list-scan proc seed ls)
  (cons seed
    (if (null? ls)
        '()
        (list-scan proc (proc seed (car ls)) (cdr ls)))))

(define (list-index pred? ls)
  (define (f xs i)
    (cond
      ((null? xs) '())
      ((pred? (car xs)) i)
      (else (f (cdr xs) (+ 1 i)))))
  (f ls 0))

(define (pt2 text)
  (list-index negative? (list-scan + 0 (map santa_move (string->list text)))))

(display-line (pt2 ")"))
(display-line (pt2 "()())"))
(display-line (pt2 data))

