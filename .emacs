;; -*- Mode: Emacs-Lisp -*-
;	$Id: .emacs,v 1.5 2000/06/19 15:20:19 richardc Exp $	

(setq load-path (cons (expand-file-name "~/.stuff/elisp") load-path))
(load "mutt")
(load-library "vc")
;;(load "mmm-mode")
;;(mmm-add-find-file-hook)

(setq cperl-indent-level 4
      font-lock-verbose nil
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      c-default-style "linux")

(defun perl-mode ()
  "overriden by a dirty hack to invoke cperl-mode"
  (interactive)
  (cperl-mode))

(custom-set-variables
 '(next-line-add-newlines nil)
 '(lazy-shot-mode t nil (lazy-shot))
 '(c-tab-always-indent (quote other))
 '(gnuserv-program (concat exec-directory "/gnuserv"))
 '(toolbar-visible-p nil)
 '(font-lock-mode t nil (font-lock)))
(custom-set-faces
 '(mmm-default-submode-face ((t (:bold nil))))
 '(font-lock-comment-face ((((class color) (background dark)) (:foreground "red")))))
