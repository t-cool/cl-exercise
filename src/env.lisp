(in-package :cl-user)

(defpackage cl-exercise.env
  (:use :cl)
  (:export :*host*))
(in-package :cl-exercise.env)

(defvar *host* nil)
