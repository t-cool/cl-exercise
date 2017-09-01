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
                :starts-with-subseq))
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
