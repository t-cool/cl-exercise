(in-package :dm-user)
(defpackage cl-exercise/darkmatter
  (:use :cl :dm-user))
(in-package :cl-exercise/darkmatter)

(defun %contains (list symbol)
  (dolist (elm list)
    (if (listp elm)
        (let ((result (%contains elm symbol)))
          (when result (return t)))
        (when (eq elm symbol)
            (return t)))))

(defun check-sexp (sexp optional)
  (format t "[Check] S-exp~%")
  (let ((requirements (gethash "requirements" optional)))
    (when requirements
      (format t "has requirements~%")
      (let ((symbols (gethash "symbols" requirements)))
        (when symbols
          (format t "has symbols ~A~%" (read-from-string symbols))
          (setf (gethash "sexpResult" optional)
                (write-to-string
                  (reduce (lambda (acc symbol)
                            (and acc
                                 (let ((contain? (%contains sexp symbol)))
                                       (when (null contain?)
                                         (format t "~A not found~%" symbol))
                                       contain?)))
                          (read-from-string symbols)
                          :initial-value t)))
          (format t "sexpResult = ~A~%" (gethash "sexpResult" optional))))))
  (values sexp optional))

(defun check-expect (return-value optional)
  (format t "[Check] expect~%")
  (let ((expect (gethash "expect" optional)))
    (when expect
      (format t "expect by ~A~%" expect)
      (setf (gethash "expectResult" optional)
            (write-to-string (funcall (eval (read-from-string expect)) return-value)))
      (format t "expectResult = ~A~%" (gethash "expectResult" optional)))
    (values return-value optional)))

(defun check-test (return-value output-rendering optional)
  (format t "[Check] test~%")
  (let ((test (gethash "test" optional)))
    (when test
      (format t "test by ~A~%" test)
      (setf (gethash "testResult" optional)
            (write-to-string (eval (read-from-string test))))
      (format t "testResult = ~A~%" (gethash "testResult" optional)))
    (values return-value output-rendering optional)))

(hook-eval-string-before #'check-sexp)
(hook-eval-string-after #'check-expect)
(hook-eval-string-finalize #'check-test)
