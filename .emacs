;; -*- Mode: Emacs-Lisp -*-
;       $Id: .emacs,v 1.6 2000/06/20 19:17:56 richardc Exp $

(setq load-path (cons (expand-file-name "~/.stuff/elisp") load-path))
(load "mutt")
(load-library "vc")
(load "mpg123")
;;(load "mmm-mode")
;;(mmm-add-find-file-hook)

(setq cperl-indent-level 4
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      flyspell-default-dictionary "british"
      c-default-style "linux")
;;(global-font-lock-mode)

(defun perl-mode ()
  "overriden by a dirty hack to invoke cperl-mode"
  (interactive)
  (cperl-mode))

(defun hacking-untabify-buffer ()
  "strip trailing whitespace and untabify a buffer"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (match-end 0)))
    (goto-char (point-min))
    (if (search-forward "\t" nil t)
        (untabify (1- (point)) (point-max))))
  nil)

(add-hook 'cperl-mode-hook
          '(lambda ()
             (make-local-variable 'write-contents-hooks)
             (add-hook 'write-contents-hooks 'hacking-untabify-buffer)))

(custom-set-variables
 '(lazy-shot-mode t nil (lazy-shot))
 '(gnuserv-program (concat exec-directory "/gnuserv"))
 '(bar-cursor nil)
 '(font-menu-this-frame-only-p nil)
 '(toolbar-visible-p nil)
 '(font-lock-mode t nil (font-lock)))
(custom-set-faces)

