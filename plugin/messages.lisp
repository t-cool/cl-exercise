(in-package :cl-user)
(defpackage cl-exercise/darkmatter.messages
  (:use :cl)
  (:export :not-found-symbol))
(in-package :cl-exercise/darkmatter.messages)

(defun not-found-symbol (symbol)
  (format t "<strong>Not found symbol: ~A</strong>~%" symbol))
