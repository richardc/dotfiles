;; -*- Mode: Emacs-Lisp -*-
;       $Id: .emacs,v 1.36 2002/08/17 11:59:22 richardc Exp $

(add-to-list 'load-path "~/.elisp")
(add-to-list 'load-path "~/.elisp/tramp/lisp")

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

;; force our cperl mode to be the local one
(load-file "~/.elisp/cperl-mode.el")

(setq frame-title-format (list "" 
			       'invocation-name "@" 'system-name' ": %b"))

(require 'tramp)
(setq tramp-default-method "su")
;(setq tramp-verbose 10
;      tramp-debug-buffer t)
(load "mutt")

(load "erc")
(setq erc-server "irc.rhizomatic.net" 
      erc-port 6667 
      erc-nick "rjc_erc"
      erc-user-name (user-full-name))

;; Taken from the comment section in inf-ruby.el
(setq ruby-program-name "/usr/local/bin/ruby")
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

(cond ((string-match "XEmacs\\|Lucid" emacs-version)
       ;; yup - we're in XEmacs
       (load "vc")
;;       (setq tty-erase-char nil)

       (gnuserv-start)
       (turn-on-lazy-shot)
       (custom-set-variables
	'(load-home-init-file t t)
	'(toolbar-visible-p nil))
       (load "xemacs-faces")
       )
      (t 
       ;; I'm not sure if I like this cond t stuff for defaults
       ;; other emacsen (probably GNU Emacs)

       ;;(server-start)
       (gnuserv-start)
       
       (global-font-lock-mode 1)
       ;(transient-mark-mode)
       
       (custom-set-faces
	'(mmm-default-submode-face ((t (:background "gray9"))))
	'(highline-face ((t (:background "gray30")))))
       )
      )

(setq cperl-indent-level 4
      flyspell-default-dictionary "british"
      ispell-dictionary "british"
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      next-line-add-newlines nil
      diff-command "diff -u"
      diff-switches '("-up")
      vc-diff-switches '("-up")
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
