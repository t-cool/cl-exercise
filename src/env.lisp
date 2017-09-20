(in-package :cl-user)

(defpackage cl-exercise.env
  (:use :cl)
  (:export :*host*
           :*debug*))
(in-package :cl-exercise.env)

(defvar *host* nil)
(defvar *debug* nil)
