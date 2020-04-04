;; Configure packaging
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Install 'use-package' if necessary
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use-package
(eval-when-compile
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package auto-compile
  :config (auto-compile-on-load-mode))

(setq load-prefer-newer t)

;; Load 'sensible-defaults.el'
;; cloned into place by hand -
;;   git clone https://github.com/hrs/sensible-defaults.el ~/.emacs.d/pkg/sensible-defaults.el
(load-file "~/.emacs.d/pkg/sensible-defaults.el/sensible-defaults.el")
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)

;; Stop custom pooping state in this file
(let ((droppings "~/.emacs.d/custom.el"))
  (setq custom-file droppings)
  (when (file-exists-p droppings)
    (load droppings)))

;; Turn off some decorations
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode -1)
(set-window-scroll-bars (minibuffer-window) nil nil)

;; prettyify-symbols, differentiates some ambiguous symbols
(global-prettify-symbols-mode t)

;; use the spacemacs theme
(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-dark t))

;; set a bigger font size.  height is in 10th points
(set-face-attribute 'default nil :height 150)

;; more fancy modeline
(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

;; list enabled minor modes
(use-package minions
  :config
  (setq minions-mode-line-lighter ""
        minions-mode-line-delimiters '("" . ""))
  (minions-mode 1))

;; don't scroll about so jerkily
(setq scroll-conservatively 100)

;; Gently highlight the current line
(global-hl-line-mode)

;; show matching parens mode
(require 'paren)
(show-paren-mode 1)

;; diff-hl
(use-package diff-hl
  :config
  (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
  (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode))

(use-package deadgrep)

(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

(global-set-key (kbd "M-/") 'company-complete-common)

;; dumb-jump
(use-package dumb-jump
	:bind
	(("M-." . dumb-jump-go))
  :config
  (setq dumb-jump-selector 'ivy))

;; flycheck
(use-package let-alist)
(use-package flycheck)

;; projectile, emulting a ctrl-p
(use-package projectile
  :bind
  (("C-c v" . deadgrep)
	 ("C-p" . projectile-find-file))

  :config
  (setq projectile-completion-system 'ivy)
  (setq projectile-switch-project-action 'projectile-dired)
  (setq projectile-require-project-root nil))


(setq frame-title-format '((:eval (projectile-project-name))))
(projectile-global-mode)

;; good undo stuff
(use-package undo-tree
	:config
	(global-undo-tree-mode))

;; Programming mode defaults
(setq-default tab-width 2)
(setq compilation-scroll-output t)

;; C/C++ indenting rules
(setq c-default-style "linux"
      c-basic-offset 4)

;; never tabs, unless it's a Makefile
(setq-default indent-tabs-mode nil)
(add-hook 'makefile-mode-hook
          (lambda () (setq indent-tabs-mode t)))

;; line and column number
(setq line-number-mode 1)
(setq column-number-mode 1)


(use-package racket-mode)

;; Silver surfer
(use-package ag)

(use-package rainbow-delimiters
  :config
	(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

	;; call out unmatched delimiters with error face
	(set-face-attribute 'rainbow-delimiters-unmatched-face nil
											:foreground 'unspecified
											:inherit 'error
											:strike-through t)

	;; bold outermost set
	(set-face-attribute 'rainbow-delimiters-depth-1-face nil
											:weight 'bold))

(use-package magit
	:bind
	(("C-x g" . magit-status))
	:config
  (use-package with-editor)
  (setq git-commit-summary-max-length 50)
  (with-eval-after-load 'magit-remote
    (magit-define-popup-action 'magit-push-popup ?P
      'magit-push-implicitly--desc
      'magit-push-implicitly ?p t))
	(add-hook 'magit-log-edit-mode-hook
						(lambda ()
							(setq fill-column 72)
							(turn-on-auto-fill))))


;; Writing words
;; spellchecking

(use-package flyspell
  :config
  (add-hook 'text-mode-hook 'turn-on-auto-fill)
  (add-hook 'git-commit-mode-hook 'flyspell-mode))

;; Markdown with GitHub Flavoured Markdown

(use-package markdown-mode
  :commands gfm-mode

  :mode (("\\.md$" . gfm-mode))

  :config
  (setq markdown-command "pandoc --standalone --mathjax --from=markdown")
  (custom-set-faces
   '(markdown-code-face ((t nil)))))


;; File management

(use-package dired-hide-dotfiles
  :config
  (dired-hide-dotfiles-mode)
  (define-key dired-mode-map "." 'dired-hide-dotfiles-mode))

(setq-default dired-listing-switches "-lhvA")

(use-package async
  :config
  (dired-async-mode 1))

;; Save your place in a file
(save-place-mode t)

(use-package which-key
  :config (which-key-mode))


;; Ivy, Counsel.   Completion framework

(use-package counsel
  :bind
  ("M-x" . 'counsel-M-x)
  ("C-s" . 'swiper)

  :config
  (use-package flx)
  (use-package smex)

  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t . ivy--regex-fuzzy))))
