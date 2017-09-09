(in-package :cl-user)
(defpackage cl-exercise
  (:use :cl)
  (:import-from :cl-exercise.handler
                :->get
                :->put)
  (:import-from :lack.builder
                :builder)
  (:import-from :alexandria
                :hash-table-plist
                :starts-with-subseq)
  (:export :start
           :stop))
(in-package :cl-exercise)

(defparameter *web*
  (lambda (env)
    (case (getf env :request-method)
      (:GET (->get env))
      (:PUT (->put env)))))

(setf *web*
      (builder
        (:static :path (lambda (path)
                         (if (starts-with-subseq "/static/" path)
                             path
                             nil)))
        *web*))

(defvar *handler* nil)

(defun start (&rest args &key server port debug &allow-other-keys)
  (declare (ignore server port debug))
  (when *handler*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))
  (setf *handler*
        (apply #'clack:clackup *web* args)))

(defun stop ()
  (prog1
      (clack:stop *handler*)
(setf *handler* nil)))
