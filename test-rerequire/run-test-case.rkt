#lang racket/base
(require pollen/render sugar pollen/cache rackunit racket/file)

(require pollen/render sugar pollen/cache rackunit racket/file)
(define (touch ps) (display-to-file (file->string ps) ps #:exists 'replace))
(define (make-dr arg) (format "#lang racket/base
(provide do)
(define (do) ~v)" arg))
(define dr "directory-require.rkt")

(parameterize ([current-cache (make-cache)])
  (when (file-exists? "pollen.cache") (delete-file "pollen.cache"))
  (display-to-file (make-dr "first-dr") dr #:exists 'replace)
  (check-equal? (render (->complete-path "one.html.pp")) "first-dr")
  ;(check-equal? (render (->complete-path "two.html.pp")) "first-dr")
  (display-to-file (make-dr "second-dr") dr #:exists 'replace)  
  (check-equal? (render (->complete-path "one.html.pp")) "second-dr")
  ;(check-equal? (render (->complete-path "two.html.pp")) "second-dr")
  
  )