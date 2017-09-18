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
                :split
                :%log)
  (:import-from :alexandria
                :plist-hash-table
                :hash-table-plist)
  (:import-from :quri
                :url-decode)
  (:export :->get
           :->put))
(in-package :cl-exercise.handler)

(defvar *client* (jsonrpc:make-client))
(defvar *server-table*
  (make-server-process-table))
(defun kill-all-process ()
  (delete-server-process-table *server-table*)
  (format t  "Killed all server process"))

(defun response-result (id result)
  (format nil "{\"jsonrpc\": \"2.0\", \"id\": ~S, \"result\": ~A}" id result))

(defun emit-response (id hash)
  (%emit-json
    201
    (yason:encode-plist
      `("jsonrpc" "2.0"
        "result" ,hash
        "id" ,id))))

(defun emit-error (id code)
  (let* ((code (case code
                 (:parse-error -32700)
                 (:invalid-request -32600)
                 (:method-not-found -32601)
                 (:invalid-params -32602)
                 (:internal-error -32603)
                 (otherwise code)))
         (message (case code
                    (-32700 "Parse error")
                    (-32600 "Invalid Request")
                    (-32601 "Method not found")
                    (-32602 "Invalid params")
                    (-32603 "Internal error")
                    (otherwise "Server error"))))
    (%log (format nil "~A ~A%" id code) "Error response")
  (%emit-json
    200
    (encode-to-string
      (plist-hash-table
        `("jsonrpc" "2.0"
          "error" ,(plist-hash-table
                     `("code" ,code
                       "message" ,message)
                     :test #'equal)
          "id" ,id)
        :test #'equal)))))

(defun %emit-json (status json-string)
  `(,status (:content-type "application/json") (,json-string)))

(defun %read-raw-body (env)
  (let ((raw-body (flexi-streams:make-flexi-stream
                    (getf env :raw-body)
                    :external-format (flexi-streams:make-external-format :utf-8)))
        (result (make-array 0 :element-type 'character :fill-pointer 0 :adjustable t)))
    (with-output-to-string (out result)
      (loop for line = (read-line raw-body nil nil) while line
            do (write-line line out)))
    result))




(defun ->get (env)
  (print env)
  (let ((params (split (getf env :request-uri) #\/)))
    (format t "~A(~A)~%" params (length params))
    (case (length params)
      (2 (render-index env))
      (3 (if (string= "ex" (aref params 1))
             (render-exercise env (aref params 2))))
      (t (notfound env)))))

(defun ->put (env)
  (format t "put")
  (let* ((uri (url-decode (getf env :request-uri)))
         (path (split uri #\/))
         (body (%read-raw-body env))
         (json (yason:parse body)))
    (format t "[PUT] ~A~%" uri)
    (force-output)
    (if (null (hash-table-p json))
        (emit-error (gethash "id" json "null") :parse-error)
        (let ((id (gethash "id" json "null"))
              (method (gethash "method" json))
              (params (gethash "params" json (make-hash-table)))
              (descripter (gethash "descripter" json)))
          (add-host *server-table* id)
          (case (length path)
            (3 (if (and (string= "eval" (aref path 1))
                        (string= "" (aref path 2)))
                   (->put/eval/ env id descripter method params)))
            (t (emit-error "null" :invalid-request)))))))

(defun ->put/eval/ (env id descripter method params)
  (if (null descripter)
      (emit-error id :invalid-params)
      (progn
        (tagbody start
                 (handler-bind ((error (lambda (c)
                                         (format t "~A~%" c)
                                         (make-server-process *server-table* id descripter)
                                         (go start))))
                   (let ((proc (get-proc *server-table* id descripter)))
                     (if proc
                         (progn
                           (%log (format nil "Connect in port ~A" (get-port proc)))
                           (jsonrpc:client-connect *client*
                                                   :url (format nil "ws://127.0.0.1:~A" (get-port proc))
                                                   :mode :websocket))
                         (progn
                           (make-server-process *server-table* id descripter)
                           (go start))))))
        (%log (format nil "Method ~A~%Params ~A"
                      method
                      (hash-table-plist params)))
        (force-output)
        (handler-case
          (let* ((result (jsonrpc:call *client* method params))
                 (json-string (encode-to-string result)))
            (%log (format nil "Result ~A" (response-result id json-string)))
            `(200 (:content-type "application/json")
              (,(response-result id json-string))))
          (error (c)
                 (let ((entity (get-entity (get-proc *server-table* id descripter))))
                   (loop for line = (read-line (uiop:process-info-output entity))
                         while line
                         do (format t "## ~A~%" line))
                   (force-output)
                   (exit)))))))


(defun encode-to-string (ht)
  (let ((stream (make-string-output-stream)))
    (yason:encode ht stream)
    (get-output-stream-string stream)))

