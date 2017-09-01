#|
  This file is a part of cl-exercise project.
  Copyright (c) 2017 Eddie, Noguchi Hiroki
|#

(in-package :cl-user)
(defpackage cl-exercise-test-asd
  (:use :cl :asdf))
(in-package :cl-exercise-test-asd)

(defsystem cl-exercise-test
  :author "Eddie, Noguchi Hiroki"
  :license "MIT"
  :depends-on (:cl-exercise
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "cl-exercise"))))
  :description "Test system for cl-exercise"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
