;; -*- Mode: Emacs-Lisp -*-
;	$Id: .emacs,v 1.3 2000/06/05 13:11:03 richardc Exp $	

(setq load-path (cons (expand-file-name "~/.stuff/elisp") load-path))
(load "mutt")
(load "mmm-mode")
(mmm-add-find-file-hook)

(setq cperl-indent-level 4
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      c-default-style "linux")
(global-font-lock-mode)

(defun perl-mode ()
  "overriden by a dirty hack to invoke cperl-mode"
  (interactive)
  (cperl-mode))

(custom-set-variables
 '(ange-ftp-ftp-program-name "pftp")
 '(toolbar-visible-p nil)
 '(c-tab-always-indent (quote other))
 '(next-line-add-newlines nil)
 '(global-font-lock-mode t nil (font-lock)))
(custom-set-faces
 '(mmm-default-submode-face ((t (:bold nil)))))

;;(gnuserv-start)
