;; -*- Mode: Emacs-Lisp -*-
;       $Id: .emacs,v 1.12 2000/08/10 13:50:51 richardc Exp $

(add-to-list 'load-path "~/.stuff/elisp")
(add-to-list 'load-path "~/.stuff/elisp/tramp/lisp")
(require 'tramp)
(setq tramp-default-method "scp")

(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

(cond (running-xemacs
       ;; yup - we're in XEmacs
       (load "vc")

       (add-to-list 'Info-directory-list "~/.stuff/elisp/tramp/texi/")

       (setq efs-generate-anonymous-password "richardc@mirth.demon.co.uk")
       
      ;; (require 'eicq)
      ;; (setq eicq-user-alias "me")
      ;; (eicq-world-update)
       
       (turn-on-lazy-shot)
       (custom-set-variables
	'(gnuserv-program (concat exec-directory "/gnuserv"))
	'(toolbar-visible-p nil))

       )
      (t 
       ;; I'm not sure if I like this cond t stuff for defaults
       ;; other emacsen (probably GNU Emacs)
       (load "highline")
       (highline-mode)
       
       (load "mmm-mode")
       (mmm-add-find-file-hook)
       
       (global-font-lock-mode)
       
       (custom-set-faces
	'(mmm-default-submode-face ((t (:background "gray9"))))
	'(highline-face ((t (:background "gray30")))))
       )
      )

(load "mutt")

(setq cperl-indent-level 4
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      next-line-add-newlines nil
      flyspell-default-dictionary "british"
      c-default-style "linux")

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
