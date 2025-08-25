;; $Id: mergesort.scm,v 1.1 2008/11/08 10:09:08 mika Exp $
;;
;; Copyright (c) 2008, Generation Capital Ltd.  All rights reserved.
;;
;; Author: Mika Nystrom <mika@alum.mit.edu>
;;
;; mergesort from cs.gmu.edu/~white (and fixed)

(define (mergesort L less-than?)


  (define (mergelists L M)         ; assume L and M are sorted lists
    (cond ( (null? L) M)
	  ( (null? M) L)
	  ( (not (less-than? (car L)(car M)))
	    (cons (car M) (mergelists L (cdr M))))
	  (else
	   (cons (car L) (mergelists (cdr L)M)))
	  )
    )
  
  (define (split L)
    (define (iter a c d)
      (if (null? a) (list c d) (iter (cdr a) (cons (car a) d) c)))
    (iter L '() '()))
  
  (cond ((null? L)  '())
        ((= 1 (length L)) L)
        ((= 2 (length L)) (mergelists (list (car L))(cdr L)))
        (else (mergelists (mergesort (car (split L)) less-than?) 
                          (mergesort (car (cdr (split L))) less-than?) 
			  ))
	)
  )

(define (sort-numbers L) (mergesort L <))

