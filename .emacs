;; -*- Mode: Emacs-Lisp -*-
;       $Id: .emacs,v 1.9 2000/07/19 20:43:49 richardc Exp $

(setq load-path (cons (expand-file-name "~/.stuff/elisp") load-path))

(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; there must be a better way to achieve this
(if running-xemacs
    (defun hacking-emacs-specific ()
      "what to do for xemacs"
      (load "vc")

      (turn-on-lazy-shot)
      )
  
  (defun hacking-emacs-specific ()
    "what to do for gnuish emacs"
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

(hacking-emacs-specific)

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

