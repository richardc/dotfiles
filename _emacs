;; -*- Mode: Emacs-Lisp -*-

(require 'cl)
(require 'cl-lib)

;; configure package manager
(require 'package)
; use these repositories
(setq package-archives '(
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                        ))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

; packages to ensure on startup
(setq my-packages '(
                    ac-nrepl
                    ack-and-a-half
                    ag
                    auto-complete
                    apache-mode
                    cider
                    clojure-cheatsheet
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
                    midje-mode
                    projectile
                    puppet-mode
                    rainbow-delimiters
                    ruby-mode
                    ruby-test-mode
                    undo-tree
                    yaml-mode
                    ))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; set up basic colors - white on black
(set-face-foreground 'default "white")
(set-face-background 'default "black")

;; set a bigger font size.  height is in 10th points
(set-face-attribute 'default nil :height 150)

;; trim trailing whitespace on save, always
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; auto-complete
(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)


;; rainbow delimiters
(require 'rainbow-delimiters)
; use for all programming modes
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

; call out unmatched delimiters with error face
(set-face-attribute 'rainbow-delimiters-unmatched-face nil
                    :foreground 'unspecified
                    :inherit 'error
                    :strike-through t)

; rotate colors by level
(setq my-paren-colors
  '("hot pink" "dodger blue" "green"))

(cl-loop
 for index from 1 to rainbow-delimiters-max-face-count
 do
 (set-face-foreground
  (intern (format "rainbow-delimiters-depth-%d-face" index))
  (elt my-paren-colors (mod index (safe-length my-paren-colors)))))

; bold outermost set
(set-face-attribute 'rainbow-delimiters-depth-1-face nil
                    :weight 'bold)

;; show-paren mode
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)
; underline and ultra-bold matching paren
(set-face-attribute 'show-paren-match-face nil
                    :foreground 'unspecified
                    :background 'unspecified
                    :weight 'ultra-bold
                    :underline t)

;; cider - clojure repl
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(setq cider-repl-result-prefix ";; => ")
(setq cider-repl-history-size 1000)
(setq cider-repl-history-file "~/.cider_history")
(setq cider-repl-use-pretty-printing t)

;; midje-mode - support for midje clojure testing framework
(require 'midje-mode)
(add-hook 'clojure-mode-hook 'midje-mode)

; rainbow-delimiters in the cider repl
(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(require 'ac-nrepl)
(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-repl-mode))

;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

;; projectile - mostly from https://github.com/bbatsov/projectile/blob/master/README.md
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

;; copy the M-g default from XEmacs
(global-set-key "\M-g" 'goto-line)

;; move between windows with Cmd-arrows
(windmove-default-keybindings 'super)

;; OSX Cmd-T should be like Sublime
(global-set-key (kbd "s-t") 'projectile-find-file)

;; If running under screen, disable C-z.
(if (and (getenv "STY") (not window-system))
    (global-unset-key "\C-z"))

;; name topmost buffer
(setq frame-title-format
      (list "" 'invocation-name "@" 'system-name' ": %b"))

;; set PATH by evaluting bashrc - for running Emacs.app
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; start a server for emacsclient to connect to
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

;; never tabs, unless it's a Makefile
(setq-default indent-tabs-mode nil)
(add-hook 'makefile-mode-hook
          (lambda () (setq indent-tabs-mode t)))

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
