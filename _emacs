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
(defvar my-packages '(
		      ack-and-a-half
		      apache-mode
		      clojure-mode
		      clojure-test-mode
		      exec-path-from-shell
		      flx-ido
		      flymake
		      flymake-cursor
		      flymake-easy
		      flymake-puppet
		      flymake-ruby
		      flymake-shell
		      json-mode
		      markdown-mode
		      magit
		      nrepl
		      pastels-on-dark-theme
		      projectile
		      puppet-mode
		      ruby-mode
		      ruby-test-mode
		      yaml-mode
		      )
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; set a color theme
(load-theme 'pastels-on-dark t)

;; trim trailing whitespace on save, always
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; proectile - mostly from https://github.com/bbatsov/projectile/blob/master/README.md
(projectile-global-mode)

;; uniqify buffer names better
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)
(add-hook
 'magit-log-edit-mode-hook
 (lambda ()
   (setq fill-column 72)
   (turn-on-auto-fill)))

(global-set-key "\M-g" 'goto-line)

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

;; name topmost buffer
(setq frame-title-format (list ""
			       'invocation-name "@" 'system-name' ": %b"))

;; set PATH by evaluting bashrc - for running Emacs.app
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

(server-start)

;; puppet-mode
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
(add-hook 'puppet-mode-hook (lambda () (flymake-puppet-load)))

;; ruby-mode && flymake
(add-hook 'ruby-mode-hook (lambda () (flymake-ruby-load)))

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

;; ido mode + flx-ido
(require 'flx-ido)
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-use-faces nil)

;; ack-and-a-half
(require 'ack-and-a-half)
;; Create shorter aliases
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

;; flymake-cursor - put flymake errors in the minibuffer
(require 'flymake-cursor)

;; disable the toolbar
(tool-bar-mode -1)

;; gc less often - https://github.com/lewang/flx told me to
(setq gc-cons-threshold 20000000)

(global-font-lock-mode 1)
(setq transient-mark-mode t)
(setq cperl-indent-level 4
      cperl-indent-parens-as-block 1
      cperl-close-paren-offset -4
      cperl-continued-statment-offset 4
      cperl-indent-parens-as-block t
      cperl-tab-always-indent t
      flyspell-default-dictionary "english"
      ispell-dictionary "english"
      indent-tabs-mode nil
      next-line-add-newlines nil
      diff-command "diff -u"
      diff-switches '("-up")
      vc-diff-switches '("-up")
      c-default-style "linux"
      c-basic-offset 4)

;; line and column number
(setq line-number-mode 1)
(setq column-number-mode 1)


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
