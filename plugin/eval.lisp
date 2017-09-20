(in-package :dm-user)
(defpackage cl-exercise/darkmatter
  (:use :cl :dm-user)
  (:import-from :cl-exercise/darkmatter.messages
                :not-found-symbol))
(in-package :cl-exercise/darkmatter)

(defun %contains (list symbol)
  (dolist (elm list)
    (if (listp elm)
        (let ((result (%contains elm symbol)))
          (when result (return t)))
        (when (eq elm symbol)
            (return t)))))

(defun check-sexp (sexp optional)
  (when *debug*
    (format t "<b>[DEBUG] Check S-expression: ~A</b>~%" sexp))
  (let ((requirements (gethash "requirements" optional)))
    (when requirements
      (let ((symbols (gethash "symbols" requirements)))
        (when symbols
          (when *debug*
            (format t "<b>[DEBUG] Symbols: ~A</b>~%" symbols))
          (setf (gethash "sexpResult" optional)
                (write-to-string
                  (loop for check in (mapcar (lambda (symbol)
                                               (let ((contain? (%contains sexp symbol)))
                                                 (when (null contain?)
                                                   (not-found-symbol symbol))
                                                 contain?))
                                             (read-from-string symbols))
                        always check)))
          (when *debug*
            (format t "<b>[DEBUG] sexpResult = ~A</b>~%" (gethash "sexpResult" optional)))))))
  (values sexp optional))

(defun check-expect (return-value optional)
  (when *debug*
    (format t "<b>[DEBUG] Check return value: ~A</b>~%" return-value))
  (let ((expect (gethash "expect" optional)))
    (when expect
      (when *debug*
        (format t "<b>[DEBUG] (funcall #'~A ~A)</b>~%" expect return-value))
      (setf (gethash "expectResult" optional)
            (write-to-string (funcall (eval (read-from-string expect)) return-value)))
      (when *debug*
        (format t "<b>[DEBUG] expectResult = ~A</b>~%" (gethash "expectResult" optional))))
    (values return-value optional)))

(defun check-test (return-value output-rendering optional)
  (when *debug*
    (format t "<b>[DEBUG] Check test case</b>~%"))
  (let ((test (gethash "test" optional)))
    (when test
      (when *debug*
        (format t "<b>[DEBUG] Test case: ~A</b>~%" test))
      (setf (gethash "testResult" optional)
            (write-to-string (eval (read-from-string test))))
      (when *debug*
        (format t "<b>[DEBUG] testResult = ~A</b>~%" (gethash "testResult" optional))))
    (values return-value output-rendering optional)))

(hook-eval-string-before #'check-sexp)
(hook-eval-string-after #'check-expect)
(hook-eval-string-finalize #'check-test)
