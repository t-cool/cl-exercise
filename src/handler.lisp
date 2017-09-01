(in-package :cl-user)
(defpackage cl-exercise.handler
  (:use :cl)
  (:import-from :cl-exercise.render
                :render-index
                :render-exercise
                :notfound)
  (:import-from :darkmatter.client.runtime
                :+launch-server+
                :get-entity
                :get-port
                :make-server-process-table
                :make-server-process
                :delete-server-process-table
                :add-host
                :get-proc)
  (:import-from :darkmatter.utils
                :split)
  (:export :->get
           :->put))
(in-package :cl-exercise.handler)

(defvar *server-table*
  (make-server-process-table))

(defun ->get (env)
  (let ((params (split (getf env :request-uri) #\/)))
    (case (length params)
      (0 (render-index env))
      (2 (if (string= "ex" (aref params 0))
             (render-exercise env (aref params 1))))
      (t (notfound env)))))

(defun ->put (env))
