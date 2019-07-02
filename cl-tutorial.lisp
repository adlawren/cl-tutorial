;;;; Basics

;; comment

#|
multi-line comment
#|
nested multi-line comment
|#
|#

;; Lisp syntax is composed of S-expressions
;; An S-expressions is either an atom, or a list

;; Atoms
'quoted-thing
123
3.14
t ;; 'true'
:this-is-a-keyword
'("this" "is" "a" "list")

;;;; Functions

;; Function calls
(format t "hello")
(print "hello again")

;; Function definition
(defun example-function (x)
  "Docstring"
  (print x))
(example-function 'todo)

;; Function application
(funcall #'example-function "something")
(apply #'example-function (list "something"))

;; Mutliple return values
(defun multi-return (num)
  "Returns multiple values"
  (values (+ num 1) (+ num 2) (+ num 3)))

(multi-return 1)

;; Bind multiple return values to named variables (in scope)
(multiple-value-bind (one two three)
  (multi-return 5)
  (print one)
  (print two)
  (print three))

;;;; Variables

;; Normal, lexically scoped variables
(let ((variable 'value)
      (variable-2 'other-value))
  (print variable)
  (print variable-2))

;; To define a variable with an initial value that depends on the value of a previously defined variable
(let* ((x 1)
       (y (+ x 1)))
  (print y))

;; Dynamically scoped variables

;; Assigns the variable to the value - even if previously defined
(defparameter dynamic-var "I'm global")
(defparameter dynamic-var "I'm global - overwritten")
(print dynamic-var)

;; Assigns the variable to the value - only if previously undefined
;; Note: does not require 'initial' value
(defvar dynamic-var-2 "I'm global too")
(defvar dynamic-var-2 "I'm global too - overwritten")
(print dynamic-var-2)

;; Dynamic variables can be overwritten temporarily
(let ((dynamic-var "Locally overwritten"))
  (print dynamic-var))
(print dynamic-var)

;;;; Lists

(list 1 2 3)

;; Accessors
(first '(1 2 3))
(second '(1 2 3))
(tenth '(1 2 3 4 5 6 7 8 9 10))
(nth 2 '(1 2 3))

(defparameter list-example '(1 2 3))
(setf (second list-example) 123)
(print list-example)
(setf (nth 1 list-example) 456)
(print list-example)

;; Higher-order functions
(mapcar (lambda (val) (= val 3)) '(1 2 3))
(mapcar #'string-upcase '("Some" "strings" "&c"))

(reduce #'+ '(1 2 3))
(reduce (lambda (x y) (* x y)) '(1 2 3 4))

(sort '(10 9 8 7 6 5 4 3 2 1) #'<)
(sort '(10 9 8 7 6 5 4 3 2 1) (lambda (v1 v2) (< v1 v2)))

;; Destructuring
(destructuring-bind (first second &rest other)
    '(1 2 3 4 5 6)
  (format t "First: ~A~%" first)
  (format t "Second: ~A~%" second)
  (format t "Other: ~A~%" other))

;;;; I/O

;; Printing - TODO: make examples of the different format-s
(format t "todo")

;; Write to file
(with-open-file
    (stream (merge-pathnames "cl/cl-tutorial/test.txt" (user-homedir-pathname))
            :direction :output
            :if-exists :supersede
            :if-does-not-exist :create)
  (format stream "line 1~%line 2~%line 3~%"))

;; Read from file
(with-open-file
    (stream (merge-pathnames "cl/cl-tutorial/test.txt" (user-homedir-pathname)))
  (do ((l (read-line stream nil) (read-line stream nil))) ((eq l nil))
      (print l)))

;;;; Macros
(defmacro custom-unless (condition &body body)
  ;; Note: the '@' is needed because 'body' is a list of expressions (ex. '((print 'a) (print 'b))'), which cannot be evaluated directly - each has to be evaluated separately (i.e. we need '(print 'a) (print 'b)')
  `(if (not ,condition) (progn ,@body)))
(defparameter test-var 1)
(custom-unless (= test-var 1) (print "unless is false"))
(custom-unless (= test-var 2) (print "unless is false"))

;;;; OOP

;; Functions/variables can be associated with symbols using property lists
(setf (get 'a-random-symbol 'prop-1) 'prop-1-value)
(setf (get 'a-random-symbol 'prop-2) (lambda (x) (print x)))
(print (get 'a-random-symbol 'prop-1))
(funcall (get 'a-random-symbol 'prop-2) 'test)

(defparameter object-var (gensym))
(setf (get object-var 'prop-1) 'prop-1-value)
(print (get object-var 'prop-1))

(defun make-object (field1 field2)
  (let ((obj (gensym)))
    (setf (get obj 'field1) field1)
    (setf (get obj 'field2) field2)
    obj))
(defparameter object-instance (make-object 'field1 'field2))
(get object-instance 'field1)

;; Generic functions/methods
(defgeneric generic-method (param) (:documentation "Generic function example"))
(defmethod generic-method ((object integer))
  (format nil "Integer method ~a~%" object))
(defmethod generic-method ((object float))
  (format nil "Float method ~a~%" object))
(generic-method 1)
(generic-method 1.0)

;; Classes
(defclass vehicle ()
  ((speed :accessor vehicle-speed
          :initarg :speed
          :type float
          :documentation "Vehicle speed"))
  (:documentation "Vehicle base class"))
(defclass bus (vehicle)
  ((mass :reader car-mass
         :initarg :mass
         :type float
         :documentation "Car mass"))
  (:documentation "Car class"))
(defparameter bus-instance (make-instance 'bus
                                          :speed 50
                                          :mass 500))
(class-of bus-instance)
(car-mass bus-instance)
(vehicle-speed bus-instance)
(describe 'bus)

;;;; Package management
;; See cl-tutorial.asd
;; Note: to import this package: (ql:quickload :cl-tutorial)

;;;; Sources:
;; - https://lisp-lang.org/learn/
;; - http://www.lispworks.com/documentation/HyperSpec/Body/f_get.htm
