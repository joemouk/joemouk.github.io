#lang racket
(require rackunit racket/file pollen/rerequire)

(define (change-required-file path proc-value)
  (display-to-file (format "#lang racket/base
(provide proc)
(define (proc) ~v)" proc-value) path #:exists 'replace)
  (sleep 1) ; to make sure mod time changes so rerequire notices it
  (file-or-directory-modify-seconds path (current-seconds)))

;; create "two.rkt" with `proc` function that evaluates to "foo"
(change-required-file "two.rkt" "foo")
;; even though "two.rkt" is inside a submodule, rerequire will transitively load it the first time
(check-true (and (member (path->complete-path "two.rkt") (dynamic-rerequire "one.rkt")) #t))
;; change "two.rkt"
(change-required-file "two.rkt" "zam")
;; this will error: rerequire should transitively reload "two.rkt", but doesn't
(check-false (empty? (dynamic-rerequire "one.rkt"))) 

(map (λ(mpis) (map mpi->path mpis)) (map mod-depends (filter mod? (flatten (hash->list loaded)))))