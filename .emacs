;; -*- Mode: Emacs-Lisp -*-
;       $Id$

(add-to-list 'load-path "~/.elisp")

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

;; force our cperl mode to be the local one
(load-file "~/.elisp/cperl-mode.el")

(load-file "~/.elisp/vc-svn.el")

(setq frame-title-format (list "" 
			       'invocation-name "@" 'system-name' ": %b"))

(require 'tramp)
(setq tramp-default-method "sshx")
;(setq tramp-verbose 10
;      tramp-debug-buffer t)
(load "mutt")

(cond ((string-match "XEmacs\\|Lucid" emacs-version)
       ;; yup - we're in XEmacs
       (require 'vc)

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
       (server-start)
       ;(gnuserv-start)
       
       (global-font-lock-mode 1)
       ;(transient-mark-mode)
       
       (custom-set-faces
	'(mmm-default-submode-face ((t (:background "gray9"))))
	'(highline-face ((t (:background "gray30")))))
       )
      )

(setq cperl-indent-level 4
      cperl-indent-parens-as-block 1
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
(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(case-fold-search t)
 '(current-language-environment "ASCII")
 '(global-font-lock-mode t nil (font-lock))
 '(load-home-init-file t t)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(show-paren-mode t nil (paren))
 '(speedbar-directory-unshown-regexp "^\\(\\.svn\\|CVS\\|RCS\\|SCCS\\)\\'")
 '(speedbar-indentation-width 2)
 '(tool-bar-mode nil nil (tool-bar))
 '(transient-mark-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(highline-face ((t (:background "gray30"))))
 '(mmm-default-submode-face ((t (:background "gray9")))))
