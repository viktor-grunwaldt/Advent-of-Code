#!/usr/bin/guile -s
!#

(define-syntax ->
  (syntax-rules ()
    ((_ x) x)
    ((_ x (f args ...) rest ...)
     (-> (f x args ...) rest ...))
    ((_ x f rest ...)
     (-> (f x) rest ...))))

(define-syntax ->>
  (syntax-rules ()
    ((_ x) x)
    ((_ x (f args ...) rest ...)
     (->> (f args ... x) rest ...))
    ((_ x f rest ...)
     (->> (f x) rest ...))))

(use-modules
  (ice-9 textual-ports) ; ports = IO, match
  (ice-9 match) ; 
  (srfi srfi-1)) ; map, fold

(define (display-line obj)
  "Display an object followed by a newline."
  (display obj)
  (newline))

(define (list-scan proc seed ls)
  (cons seed
    (match ls
      (() '())
      ((x . xs) (list-scan proc (proc seed x) xs)))))

(define (unix-uniq sorted-list)
  (match sorted-list
    (() '())                     ;; Empty list
    ((x) (list x))               ;; Single item
    ((x y . rest)                ;; Two or more items
     (if (equal? x y)
         (unix-uniq (cons y rest))    ;; Skip x, recurse
         (cons x (unix-uniq (cons y rest))))))) ;; Keep x, recurse

(define (partial f . args)
  (lambda more-args
    (apply f (append args more-args))))

(define (santa_move c)
  (match c
    (#\^ +0.0+1.0i)
    (#\v +0.0-1.0i)
    (#\> +1.0+0.0i)
    (#\< -1.0+0.0i)
    (_ #f) ))

(define (complex<? a b)
  (if (= (real-part a) (real-part b))
      (< (imag-part a) (imag-part b))  ;; Same X, compare Y
      (< (real-part a) (real-part b)))) ;; Compare X

(define (moves-to-pos xs)
  (->> xs
    (filter-map santa_move)
    (list-scan + 0.0+0.0i) ))

(define (count-uniq-positions xs)
  (->> xs
    moves-to-pos
    ((lambda (x) (sort x complex<?)))
    unix-uniq
    length))

(define (pt1 text)
  (-> text string->list count-uniq-positions))

(define data (get-string-all (open-file "./input.txt" "r" )))
(display-line (pt1 "^^"))
(display-line (pt1 data))

(define (partition-by-idx ls)
  (match ls
   ('() '(() ()))
   ((x) (list (list x) '() ))
   ((x y . xs)
      (let ((res (partition-by-idx xs)))
        (match res
         ((l r) (list  (cons x l)  (cons y r)))
         (_ "unreachable!"))))))

(define (pt2 text)
  (->> text
       string->list
       partition-by-idx
       (map moves-to-pos)
       (apply append)
       ((lambda (x) (sort x complex<?)))
       unix-uniq
       length
       ))

(display-line (pt2 "^v"))
(display-line (pt2 "^>v<"))
(display-line (pt2 "^v^v^v^v^v"))
(display-line (pt2 data))
