#!/usr/bin/guile -s
!#
(use-modules (ice-9 textual-ports)) ; ports = IO
(use-modules (srfi srfi-1)) ; map, fold

(define (display-line obj)
  "Display an object followed by a newline."
  (display obj)
  (newline))

(display "Hello, world!\n")

(define (partial f . args)
  (lambda more-args
    (apply f (append args more-args))))

(define (parse raw)
  (define (split-by-x row)
    (map string->number (string-split row #\x)))
  (map split-by-x (string-split (string-trim-both  raw) #\newline)))

(define (area l w h)
  (+ (* 2 l w) (* 2 h w) (* 2 l h)
     (min (* l w) (* h w) (* l h))))

(define (pt1 text)
  (fold + 0 (map (partial apply area) (parse text))))

(display-line (pt1 "2x3x4"))
(define data (get-string-all (open-file "./input.txt" "r" )))

(display-line (pt1 data))

(define (ribbon l w h)
  (+
    (* 2 (+ l w h (* -1 (max l w h))))
    (* l w h)))

(define (pt2 text)
  (fold + 0 (map (partial apply ribbon) (parse text))))

(display-line (pt2 "2x3x4"))
(display-line (pt2 data))

