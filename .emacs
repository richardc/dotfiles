;; -*- Mode: Emacs-Lisp -*-
;       $Id$

(add-to-list 'load-path "~/.elisp")

;; toggle this based on the terminal misbehaviour of the day
;(normal-erase-is-backspace-mode)

(global-set-key "\M-g" 'goto-line)

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

;; force our cperl mode to be the local one
;(load-file "~/.elisp/cperl-mode.el")

(setq frame-title-format (list "" 
			       'invocation-name "@" 'system-name' ": %b"))

(server-start)
;;(gnuserv-start)

;; http://www.emacswiki.org/emacs/download/apache-mode.el;;   
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))
       
(global-font-lock-mode 1)
(setq transient-mark-mode t)
(iswitchb-mode)
(setq cperl-indent-level 4
      cperl-indent-parens-as-block 1
      cperl-close-paren-offset -4
      cperl-continued-statment-offset 4
      cperl-indent-parens-as-block t
      cperl-tab-always-indent t
      flyspell-default-dictionary "english"
      ispell-dictionary "english"
      line-number-mode 1
      column-number-mode 1
      indent-tabs-mode nil
      next-line-add-newlines nil
      diff-command "diff -u"
      diff-switches '("-up")
      vc-diff-switches '("-up")
      c-default-style "linux"
      c-basic-offset 4)

(defalias 'perl-mode 'cperl-mode)

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

(defun nice-text-mode ()
  "setup a sane mode for editing english text"
  (interactive)
  (text-mode)
  (flyspell-mode)
  (auto-fill-mode))

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
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(highline-face ((t (:background "gray30"))))
 '(mmm-default-submode-face ((t (:background "gray9")))))


