;; -*- Mode: Emacs-Lisp -*-
;       $Id: .emacs,v 1.18 2001/07/18 00:58:00 richardc Exp $

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

       (gnuserv-start)
       (turn-on-lazy-shot)
       (custom-set-variables
	'(load-home-init-file t t)
	'(gnuserv-program (concat exec-directory "/gnuserv"))
	'(toolbar-visible-p nil))

       (custom-set-faces
	'(info-xref ((((type x) (class color) (background light)) (:foreground "red3" :bold t :underline t)) 
		     (((type tty) (class color) (background dark)) (:foreground "brightred" :bold t))))
	'(gui-button-face ((t (:inverse-video t))) t)
	'(info-node ((((type x) (class color) (background light)) (:foreground "red3" :bold t)) 
		     (((type tty) (class color) (background dark)) (:foreground "brightred" :bold t))))
	'(dired-face-directory ((t (:foreground "blue" :bold t))))
	'(font-lock-string-face ((((type x) (class color) (background dark)) (:foreground "tan")) 
				 (((type x) (class color) (background light)) (:foreground "green4")) 
				 (((type x) (class grayscale) (background light)) (:foreground "DimGray" :italic t)) 
				 (((type x) (class grayscale) (background dark)) (:foreground "LightGray" :italic t)) 
				 (((type tty) (class color)) (:foreground "green")) (t (:bold t))))
	'(dired-face-permissions ((t (:foreground "black" :background "cyan"))))
	'(font-lock-reference-face ((((type tty) (class color)) (:foreground "brightyellow")) 
				    (((class color) (background dark)) (:foreground "cadetblue2")) 
				    (((class color) (background light)) (:foreground "red3")) 
				    (((class grayscale) (background light)) (:foreground "LightGray" :bold t :underline t)) 
				    (((class grayscale) (background dark)) (:foreground "Gray50" :bold t :underline t))))
	'(font-lock-doc-string-face ((((type tty) (class color)) (:foreground "brightgreen")) 
				     (((class color) (background dark)) (:foreground "light coral")) 
				     (((class color) (background light)) (:foreground "green4")) (t (:bold t))))
	'(font-lock-preprocessor-face ((((type tty) (class color)) (:foreground "brightblue")) 
				       (((class color) (background dark)) (:foreground "steelblue1")) 
				       (((class color) (background light)) (:foreground "blue3")) (t (:underline t))))
	'(font-lock-variable-name-face ((((type tty) (class color)) (:foreground "brightcyan")) 
					(((class color) (background dark)) (:foreground "cyan3")) 
					(((class color) (background light)) (:foreground "magenta4")) 
					(((class grayscale) (background light)) (:foreground "Gray90" :bold t :italic t)) 
					(((class grayscale) (background dark)) (:foreground "DimGray" :bold t :italic t)) (t (:underline t))))
	'(paren-match ((((type x) (class color)) (:background "seagreen1")) 
		       (((type tty) (class color)) (:foreground "white" :background "green"))) t)
	'(font-lock-warning-face ((((type tty) (class color)) (:foreground "brightred")) 
				  (((class color) (background light)) (:foreground "Red" :bold t)) 
				  (((class color) (background dark)) (:foreground "Pink" :bold t)) (t (:bold t :inverse-video t))))
	'(font-lock-keyword-face ((((type tty) (class color)) (:foreground "brightwhite")) 
				  (((class color) (background light)) (:foreground "red4" :bold t))))
	'(font-lock-type-face ((((type tty) (class color)) (:foreground "brightmagenta")) 
			       (((class color) (background dark)) (:foreground "wheat")) 
			       (((class color) (background light)) (:foreground "steelblue")) 
			       (((class grayscale) (background light)) (:foreground "Gray90" :bold t)) 
			       (((class grayscale) (background dark)) (:foreground "DimGray" :bold t)) (t (:bold t))))
	'(font-lock-other-type-face ((((type x) (class color)) (:foreground "blue3")) (t (:foreground "brightblue"))) t)
	'(font-lock-comment-face ((((type tty) (class color)) (:foreground "yellow")) 
				  (((class color) (background dark)) (:foreground "gray80")) 
				  (((class color) (background light)) (:foreground "blue4")) 
				  (((class grayscale) (background light)) (:foreground "DimGray" :bold t :italic t)) 
				  (((class grayscale) (background dark)) (:foreground "LightGray" :bold t :italic t)) (t (:bold t))))
	'(dired-face-executable ((((type x) (class color) (background light)) (:foreground "green4" :bold t)) 
				 (((type tty) (class color) (background dark)) (:foreground "green" :bold t))))
	'(font-lock-function-name-face ((((type tty) (class color)) (:foreground "blue")) 
					(((class color) (background dark)) (:foreground "aquamarine")) 
					(((class color) (background light)) (:foreground "brown4")) (t (:bold t :underline t))))
	'(modeline ((((type x) (class color) (background light)) (:background "grey80")) 
		    (((type tty) (class color)) (:foreground "black" :background "cyan"))) t)
	'(dired-face-symlink ((((type x) (class color)) (:foreground "cyan4")) 
			      (((type tty) (class color)) (:foreground "cyan")) (t (:bold t))))
	'(yellow ((((type x) (class color) (background light)) (:foreground "yellow4")) 
		  (((type tty) (class color)) (:foreground "brightyellow"))) t)
	'(green ((((type x) (class color)) (:foreground "green4")) (t (:foreground "green"))) t)
	)
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

