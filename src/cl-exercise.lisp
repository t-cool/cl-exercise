(in-package :cl-user)
(defpackage cl-exercise
  (:use :cl)
  (:import-from :cl-exercise.env
                :*host*)
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

(defvar *root-directory*
  (asdf:system-relative-pathname "cl-exercise" ""))

(defparameter *web*
  (lambda (env)
    (case (getf env :request-method)
      (:GET (->get env))
      (:PUT (->put env))
      (t (format t "http method error(~A)~%" (getf env :request-method))))))

(setf *web*
      (builder
        (:static :path (lambda (path)
                         (if (starts-with-subseq "/static/" path)
                             path
                             nil))
         :root *root-directory*)
        *web*))

(defvar *handler* nil)

(defun start (&rest args &key host server port debug &allow-other-keys)
  (declare (ignore host server port debug))
  (when *handler*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))
  (when host
    (setf *host* host))
  (setf *handler*
        (apply #'clack:clackup *web* args)))

(defun stop ()
  (prog1
      (clack:stop *handler*)
(setf *handler* nil)))
