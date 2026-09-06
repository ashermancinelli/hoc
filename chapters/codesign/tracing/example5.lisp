
(defun make-ir () (make-array 0 :adjustable t :fill-pointer 0))
(defparameter *ip* nil)
(defparameter *outer* nil)
(defparameter *debug* t)

(defun matches-form (got expect)
  (every (lambda (x y)
           (or (eq y '_)
               (equal x y)))
         got expect))

(defmacro emit (form)
  `(vector-push-extend ,form *ip*))

(defun jit-call (callee &rest args)
  (let ((sym (gensym "call-result"))
        )
    (emit `(,callee ,@args))
    sym))

(defun jit-for (start end body)
  (if
    (and (integerp start) (integerp end))
    (loop for i from start below end do (funcall body i))
    (emit `(jit-for ,start ,end ,body))))

(defun rewrite-loop (loop-form)
  (destructuring-bind
    (_l _f i _f start _b end _d body)
    loop-form
    (format t "~a from ~a to ~a ~a~%" (type-of i) (type-of start) (type-of end) body)
    (let ((*ir* (make-ir))
          (body-ir (jit-compile body)))
      `(jit-for
         ,(jit-compile start)
         ,(jit-compile end)
         (lambda (,i) ,body-ir)
         ))))

(defmacro with-ip (ip &rest body)
  `(let ((*outer* *ip* *ip* ip))
     ,@body
     (emit *outer*)))

(defun set-item (arr idx val)
  (emit `(set-item ,arr ,idx ,val)))

(defun get-item (arr idx)
  (let ((out (gensym "get-item")))
    (emit `(setq ,out (get-item ,arr ,idx)))
    out))

(defun do-jit-compile (form)
  (cond
    ((atom form) form)            ; skip atoms
    ((eq (car form) 'quote) form) ; skip quotes
    ((eq (car form) 'loop) (rewrite-loop form))
    ((eq (car form) '+) `(jit-call ,@form))
    ((eq (car form) 'setf)
     (destructuring-bind (_setf (_aref arr idx) val) form
       `(set-item
          ,(jit-compile arr)
          ,(jit-compile idx)
          ,(jit-compile val))))
    ((eq (car form) 'elt)
     `(get-item
        ,(jit-compile (second form))
        ,(jit-compile (third form))))
    (t (mapcar #'jit-compile form))))

(defun jit-compile (form)
  (let ((after (do-jit-compile form)))
    (if (not (equal form after))
      (format t "--- ~a~%+++ ~a~%~%" form after))
    after))

(defmacro trace-jit (name args &body body)
  (format t "JIT-compiling ~a~%~a~%" name `(defun ,name ,args ,body))
  (let* ((*ip* (make-ir))
         (arg-syms (mapcar #'(lambda (_) (quote (gensym "jit-arg"))) args))
         (fn (gensym "ast-compiled"))
         (compiled
           `(defun ,name ,args
              (let ((*ip* (make-ir))
                    (,fn (lambda ,args ,@(mapcar #'jit-compile body))))
                (funcall ,fn ,@arg-syms)
                *ip*))))
    (format t "AST-preprocessed function:~%~a~%" compiled)
    compiled))

(trace-jit
  foo (a N)
  (loop for i from 0 below N do
        (setf (aref a i)
              (+ (elt a i) i))))
(let* ((N 5)
       (a (make-array N))
       (ir (foo a N)))
  (format t "Result: ~a~%IR: ~a~%" a ir))
