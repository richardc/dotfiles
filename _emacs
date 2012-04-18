;; -*- Mode: Emacs-Lisp -*-

(add-to-list 'load-path "~/.elisp")

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(require 'cl)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(markdown-mode puppet-mode apache-mode)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; toggle this based on the terminal misbehaviour of the day
;(normal-erase-is-backspace-mode)

(global-set-key "\M-g" 'goto-line)

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

(setq frame-title-format (list "" 
			       'invocation-name "@" 'system-name' ": %b"))

(server-start)

;; puppet-mode
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; from http://orgmode.org/worg/org-tutorials/orgtutorial_dto.html
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; apache-mode.el
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

;; markdown mode
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mkd$" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown$" . markdown-mode))
       
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


