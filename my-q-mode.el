(load "~/.emacs.d/lisp/q-mode.el")

(defun my-q-mode-send-line-to-sh (&optional step)
  (interactive ())
  (setq currbuff (buffer-name))
  (setq linestr (replace-regexp-in-string "\n" " " (thing-at-point 'line t)))
  (shell)
  (goto-char (point-max))
  (insert linestr)
  (comint-send-input nil t)
  (switch-to-buffer-other-window currbuff)
  (next-line)
  (beginning-of-line))

(defun my-q-send-string (string)
  (setq currbuff (buffer-name))
  (let ((msg (concat q-msg-prefix string q-msg-postfix)))
    (shell)
    (insert msg)
    (comint-send-input nil t)
    (switch-to-buffer-other-window currbuff)))

(defun my-q-mode-send-function-to-sh ()
  "Send the current function to the inferior q[con] process."
  (interactive)
  (save-excursion
    (goto-char (point-at-eol))          ; go to end of line
    (let ((start (re-search-backward q-function-regex)) ; find beinning of function
          (end   (re-search-forward ":")) ; find end of function name
          (fun   (thing-at-point 'sexp))) ; find function body
      (setq funcstr (q-strip (concat (buffer-substring start end) fun)))
      (my-q-send-string funcstr))))

(defun my-q-mode-map (&optional step)
  (interactive())
  (define-key q-mode-map "\C-c\C-n" 'my-q-mode-send-line-to-sh)
  (define-key q-mode-map "\C-c\C-f" 'my-q-mode-send-function-to-sh))

(add-hook 'q-mode-hook (lambda () (my-q-mode-map ())))

