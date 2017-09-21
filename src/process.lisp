(in-package :cl-user)
(defpackage cl-exercise.process
  (:use :cl)
  (:export :+launch-darkmatter+
           :get-entity
           :get-port
           :make-server-process-table
           :delete-server-process-table
           :add-host
           :get-proc
           :make-server-process))
(in-package :cl-exercise.process)

(defparameter +launch-darkmatter+
  (cond
    ((= 0 (third (multiple-value-list (uiop:run-program "which darkmatter" :ignore-error-status t))))
     "darkmatter")
    ((= 0 (third (multiple-value-list (uiop:run-program "which ros" :ignore-error-status t))))
     (format nil "exec ~A"
             (asdf:system-relative-pathname "darkmatter" #P"roswell/darkmatter.ros")))
    ((= 0 (third (multiple-value-list (uiop:run-program "which sbcl" :ignore-error-status t))))
     "sbcl --noinform --eval '(ql:quickload :darkmatter)' --eval '(darkmatter:start)'")
    (t
     (format t "Install roswell or sbcl~%")
     (exit))))

(defclass server-process ()
  ((entity :reader get-entity
           :initform nil
           :initarg :entity)
   (port :type integer
         :reader get-port
         :initform 0
         :initarg :port)))

(defun make-server-process-table ()
  (make-hash-table :test #'equal))

(defun add-host (tbl hostname)
  (let ((proc-table (gethash hostname tbl nil)))
    (if proc-table
        proc-table
        (setf (gethash hostname tbl)
              (make-hash-table :test #'equal)))))

(defun get-proc (tbl hostname id)
  (let ((proc-table (gethash hostname tbl nil)))
    (when proc-table
      (gethash id proc-table))))

(defun %parse-port-number (string)
  (dotimes (index (length string))
    (when (eq #\: (char string index))
      (return (parse-integer string :start (1+ index) :junk-allowed t)))))

(defun make-server-process (tbl hostname id)
  (let* ((proc-table (gethash hostname tbl))
         (out (make-array 0 :element-type 'character :adjustable t))
         (entity (uiop:launch-program +launch-darkmatter+ :output :stream))
         (port nil))
    (loop for cnt from 0 below 50
          until (numberp port)
          do (format t ".")
             (force-output)
             (sleep 1)
             (setf out (read-line (uiop:process-info-output entity)))
             (setf port (%parse-port-number out)))
    (fresh-line)
    (setf (gethash id proc-table)
          (make-instance 'server-process :entity entity :port port))
    port))

(defun delete-server-process-table (tbl)
  (with-hash-table-iterator
    (generator-fn tbl)
    (loop
      (multiple-value-bind (more? key spl)
        (generator-fn)
        (unless more? (return t))
        (with-hash-table-iterator
          (generator-fn spl)
          (loop
            (multiple-value-bind (more? key proc)
              (generator-fn)
              (unless more? (return t))
              (uiop:terminate-process (get-entity proc) :urgent t)
              (uiop:wait-process (get-entity proc)))))))))

