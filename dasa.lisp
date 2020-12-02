(ql:quickload '())

(defpackage dasa
  (:use :cl :websocket-driver))

(in-package :dasa)

(defvar *connections* (make-hash-table))
(defparameter servidor nil)

(defun handle-new-connection (con)
  (setf (gethash con *connections*)
        (format nil "user-~a" (random 100000))))

(defparameter *echo-server*
  (lambda (env)
    (let ((ws (make-server env)))

      (on :open    ws (lambda () (handle-new-connection ws)))
      (on :message ws (lambda (message)
			(print ws)
			(print message)
			(send ws message)))
      
      (lambda (responder)
        (declare (ignore responder))
        (start-connection ws)))))

(defparameter handler (clack:clackup *echo-server* :server :wookie :port 5000))
;; (clack:stop handler)

