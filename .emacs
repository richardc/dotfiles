;; -*- Mode: Emacs-Lisp -*-
;       $Id: .emacs,v 1.16 2001/07/18 00:39:49 richardc Exp $

(add-to-list 'load-path "~/.elisp")

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

;; force our cperl mode to be the local one
(load-file "/home/richardc/.elisp/cperl-mode.el")

(setq frame-title-format (list "" 
			       'invocation-name "@" 'system-name' ": %b"))

(load "python-mode")
(load "mutt")


(cond ((string-match "XEmacs\\|Lucid" emacs-version)
       ;; yup - we're in XEmacs
       (load "vc")

       (turn-on-lazy-shot)
       (custom-set-variables
	'(load-home-init-file t t)
	'(gnuserv-program (concat exec-directory "/gnuserv"))
	'(toolbar-visible-p nil))
       (custom-set-faces)
       (gnuserv-start)
       )
      (t 
       ;; I'm not sure if I like this cond t stuff for defaults
       ;; other emacsen (probably GNU Emacs)

       (server-start)
       
       (load "mmm-mode")
       (mmm-add-find-file-hook)
       
       (global-font-lock-mode 1)
       
       (custom-set-faces
	'(mmm-default-submode-face ((t (:background "gray9"))))
	'(highline-face ((t (:background "gray30")))))
       )
      )

(setq cperl-indent-level 4
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      next-line-add-newlines nil
      flyspell-default-dictionary "british"
      diff-command "diff -u"
      c-default-style "linux"
      c-basic-offset 4)

(iswitchb-default-keybindings)

(defun perl-mode ()
  "overriden by a dirty hack to invoke cperl-mode"
  (interactive)
  (cperl-mode))

(defun nice-text-mode ()
  "setup a sane mode for editing english text"
  (interactive)
  (text-mode)
  (flyspell-mode)
  (auto-fill-mode))

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

