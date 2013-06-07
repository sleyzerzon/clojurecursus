(add-hook 'org-export-first-hook 'org-update-all-dblocks)

;; usage:
;;(org-dblock-write:define-counter '(:id "something" :text "Something
;;nr. "))

(defun org-dblock-write:define-counter (params)
  (let* ((id (plist-get params :id))
         (counterstr (concat "autocounter:" id))
         (text (plist-get params :text))
         (left (or (plist-get params :left) "*"))
         (right (or (plist-get params :right) ".*"))
         (countersymb (intern counterstr))
         (countertextsymb (intern (concat counterstr "-text")))
         (orgfunsymb (intern (concat "org-dblock-write:" id))))
    (setf (symbol-value countersymb) 0)
    (setf (symbol-value countertextsymb) text)
    (defalias orgfunsymb (lambda (params) (print counterstr) (autocounter-insert-count left counterstr right)))))

(defun autocounter-insert-count (left counterstr right)
  (let* ((counter (intern counterstr))
         (counter-text (symbol-value (intern (concat counterstr "-text")))))
    (incf (symbol-value counter))
    (insert "#+BEGIN_LATEX\n")
    (insert "\\noindent \\\\ \n")
    (insert "#+END_LATEX\n")
    (insert (concat left counter-text " " (int-to-string (symbol-value counter)) right))))
