(in-package :cl-user)
(defpackage cl-exercise.render
  (:use :cl)
  (:import-from :darkmatter.client.runtime
                :html-runtime)
  (:export :render-index
           :render-exercise
           :notfound))
(in-package :cl-exercise.render)

(djula:add-template-directory
  (asdf:system-relative-pathname "cl-exercise" "templates/"))

(defvar *data-directory*
  (asdf:system-relative-pathname "cl-exercise" "data/"))

(defvar +index.html+
  (djula:compile-template* "index.html"))

(defvar +exercise.html+
  (djula:compile-template* "exercise.html"))

(defvar +404.html+
  (djula:compile-template* "404.html"))

(defun read-string-from-file (path)
  (with-open-file (s path :direction :input)
    (let ((buf (make-string (file-length s))))
      (read-sequence buf s)
      buf)))

(defun read-question-list ()
  (mapcar #'read-question-file
          (directory
            (format nil "~A/*.json"
                    (namestring *data-directory*)))))

(defun read-question-file (path)
  (let ((data
          (hash-table-plist
            (yason:parse
              (read-string-from-file path)))))
    (list "path" path
          "data" data)))

(defun render-index (env)
  (djula:render-template* +index.html+ nil
                          :questions (read-question-list)))

(defun render-exercise (env fname)
  (let ((path (format nil "~A/~A.json"
                      (namestring *data-directory*)
                      fname)))
    (if (probe-file path)
        (djula:render-template* +exercise.html+ nil
                                :runtime (html-runtime env)
                                :question (read-question-file path))
        (notfound env))))

(defun notfound (env)
  (djula:render-template* +404.html+ nil))
