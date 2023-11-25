(defmacro html (used-tags &rest body)
  `(flet ((html-tag (tag &optional ops &rest rest)
                    (let ((content (cond
                                    ((typep ops 'list) (first rest))
                                    (ops (concatenate 'list (list ops) (first rest)))
                                    (t nil))))
                      (let ((options (when (typep ops 'list) ops)))
                        (concatenate 'string "<" tag
                                     (format nil "~{ ~a~}" options) ">"
                                     (format nil "~{~a~%~}" content) "</" tag ">")
                        ))))
     (flet ,(mapcar (lambda
                      (tag)
                      `(,(intern (string-upcase tag))
                        (&optional ops &rest rest)
                        (html-tag ,tag ops rest)))
                    used-tags)
       ,@body)))