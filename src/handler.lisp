(in-package :cl-user)
(defpackage cl-exercise.handler
  (:use :cl)
  (:import-from :cl-exercise.render
                :render-index
                :render-exercise
                :notfound)
  (:import-from :cl-exercise.process
                :+launch-darkmatter+
                :get-entity
                :get-port
                :make-server-process-table
                :make-server-process
                :delete-server-process-table
                :add-host
                :get-proc)
  (:import-from :cl-exercise.utils
                :split)
  (:export :->get
           :->put))
(in-package :cl-exercise.handler)

(defvar *server-table*
  (make-server-process-table))

(defun ->get (env)
  (let ((params (split (getf env :request-uri) #\/)))
    (format t "~A(~A)~%" params (length params))
    (case (length params)
      (2 (render-index env))
      (3 (if (string= "ex" (aref params 1))
             (render-exercise env (aref params 2))))
      (t (notfound env)))))

(defun ->put (env))
