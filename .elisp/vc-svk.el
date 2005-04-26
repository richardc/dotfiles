
;;; vc-svk.el --- non-resident support for SVK version-control

;; Based upon vc-svn.el
;; Quick hack--most things are very slow/may work improperly.
;; But it's enough for my basic use.

;; Copyright (C) 1995, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005
;;           Free Software Foundation, Inc.

;; Author:      FSF (see vc.el for full credits)

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This is preliminary support for Subversion (http://subversion.tigris.org/).
;; It started as `sed s/cvs/svk/ vc.cvs.el' (from version 1.56)
;; and hasn't been completely fixed since.

;; Sync'd with Subversion's vc-svk.el as of revision 5801.

;;; Bugs:

;; - VC-dired is (really) slow.
;; - (svk) Most other commands are, too.

;;; Code:

(eval-when-compile
  (require 'vc))

;;;
;;; Customization options
;;;

(defcustom vc-svk-global-switches nil
  "*Global switches to pass to any SVK command."
  :type '(choice (const :tag "None" nil)
		  (string :tag "Argument String")
		   (repeat :tag "Argument List"
			    :value ("")
			     string))
  :version "21.4"
  :group 'vc)

(defcustom vc-svk-register-switches nil
  "*Extra switches for registering a file into SVK.
A string or list of strings passed to the checkin program by
\\[vc-register]."
  :type '(choice (const :tag "None" nil)
		  (string :tag "Argument String")
		   (repeat :tag "Argument List"
			    :value ("")
			     string))
  :version "21.4"
  :group 'vc)

(defcustom vc-svk-diff-switches
  t   ;`svk' doesn't support common args like -c or -b.
  "String or list of strings specifying extra switches for svk diff under VC.
If nil, use the value of `vc-diff-switches'.
If you want to force an empty list of arguments, use t."
  :type '(choice (const :tag "Unspecified" nil)
		  (const :tag "None" t)
		   (string :tag "Argument String")
		    (repeat :tag "Argument List"
			     :value ("")
			      string))
  :version "21.4"
  :group 'vc)

(defcustom vc-svk-header (or (cdr (assoc 'SVK vc-header-alist)) '("\$Id\$"))
  "*Header keywords to be inserted by `vc-insert-headers'."
  :version "21.4"
  :type '(repeat string)
  :group 'vc)

(defconst vc-svk-use-edit nil
  ;; Subversion does not provide this feature (yet).
  "*Non-nil means to use `svk edit' to \"check out\" a file.
This is only meaningful if you don't use the implicit checkout model
\(i.e. if you have $SVKREAD set)."
  ;; :type 'boolean
  ;; :version "21.4"
  ;; :group 'vc
  )

;;;
;;; State-querying functions
;;;

;;;###autoload (add-to-list 'vc-handled-backends 'SVK)
;;;###autoload (defun vc-svk-registered (file)
;;;###autoload   (when (string-match
;;;###autoload  "^Checkout Path:"
;;;###autoload  (shell-command-to-string (concat "svk info "
;;;###autoload   (expand-file-name file))))
;;;###autoload     (setq file nil)
;;;###autoload     (load "vc-svk")
;;;###autoload     (vc-svk-registered file)))

(add-to-list 'vc-handled-backends 'SVK)
(defun vc-svk-registered (file)
  "Check if FILE is SVK registered."
  (when (vc-svk-co-path-p file)
    (with-temp-buffer
      (cd (file-name-directory file))
      (condition-case nil
	    (vc-svk-do-status)
	;; We can't find an `svk' executable.  We could also deregister SVK.
	(file-error nil))
      (vc-svk-parse-status t)
      (eq 'SVK (vc-file-getprop file 'vc-backend)))))

(defun vc-svk-state (file &optional localp)
  "SVK-specific version of `vc-state'."
  (setq localp (or localp (vc-stay-local-p file)))
  (with-temp-buffer
    (cd (file-name-directory file))
    (vc-svk-do-status)
    (vc-svk-parse-status localp)
    (vc-file-getprop file 'vc-state)))

(defun vc-svk-state-heuristic (file)
  "SVK-specific state heuristic."
  (vc-svk-state file 'local))

(defun vc-svk-dir-state (dir &optional localp)
  "Find the SVK state of all files in DIR."
  (setq localp (or localp (vc-stay-local-p dir)))
  (let ((default-directory dir))
    ;; Don't specify DIR in this command, the default-directory is
    ;; enough.  Otherwise it might fail with remote repositories.
    (with-temp-buffer
      (vc-svk-do-status)
      (vc-svk-parse-status localp))))

(defun vc-svk-workfile-version (file)
  "SVK-specific version of `vc-workfile-version'."
  ;; There is no need to consult RCS headers under SVK, because we
  ;; get the workfile version for free when we recognize that a file
  ;; is registered in SVK.
  (vc-svk-registered file)
  (vc-file-getprop file 'vc-workfile-version))

(defun vc-svk-checkout-model (file)
  "SVK-specific version of `vc-checkout-model'."
  ;; It looks like Subversion has no equivalent of CVSREAD.
  'implicit)

;; vc-svk-mode-line-string doesn't exist because the default implementation
;; works just fine.

(defun vc-svk-dired-state-info (file)
  "SVK-specific version of `vc-dired-state-info'."
  (let ((svk-state (vc-state file)))
    (cond ((eq svk-state 'edited)
	      (if (equal (vc-workfile-version file) "0")
		         "(added)" "(modified)"))
	    ((eq svk-state 'needs-patch) "(patch)")
	      ((eq svk-state 'needs-merge) "(merge)"))))


;;;
;;; State-changing functions
;;;

(defun vc-svk-register (file &optional rev comment)
  "Register FILE into the SVK version-control system.
COMMENT can be used to provide an initial description of FILE.

`vc-register-switches' and `vc-svk-register-switches' are passed to
the SVK command (in that order)."
  (apply 'vc-svk-command nil 0 file "add" (vc-switches 'SVK 'register)))

(defun vc-svk-responsible-p (file)
  "Return non-nil if SVK thinks it is responsible for FILE."
  (file-directory-p (expand-file-name ".svk"
				            (if (file-directory-p file)
						  file
					      (file-name-directory file)))))

(defalias 'vc-svk-could-register 'vc-svk-responsible-p)
;;  "Return non-nil if FILE could be registered in SVK.  This is only possible if SVK is responsible for FILE's directory.")

(defun vc-svk-checkin (file rev comment)
  "SVK-specific version of `vc-backend-checkin'."
  (let ((status (apply
                 'vc-svk-command nil 1 file "ci"
                 (nconc (list "-m" comment) (vc-switches 'SVK 'checkin)))))
    (set-buffer "*vc*")
    (goto-char (point-min))
    (unless (equal status 0)
      ;; Check checkin problem.
      (cond
       ((search-forward "Transaction is out of date" nil t)
        (vc-file-setprop file 'vc-state 'needs-merge)
        (error (substitute-command-keys
                (concat "Up-to-date check failed: "
                        "type \\[vc-next-action] to merge in changes"))))
       (t
        (pop-to-buffer (current-buffer))
        (goto-char (point-min))
        (shrink-window-if-larger-than-buffer)
        (error "Check-in failed"))))
    ;; Update file properties
    ;; (vc-file-setprop
    ;;  file 'vc-workfile-version
    ;;  (vc-parse-buffer "^\\(new\\|initial\\) revision: \\([0-9.]+\\)" 2))
    ))

(defun vc-svk-find-version (file rev buffer)
  (apply 'vc-svk-command
	  buffer 0 file
	   "cat"
	    (and rev (not (string= rev ""))
		       (concat "-r" rev))
	     (vc-switches 'SVK 'checkout)))

(defun vc-svk-checkout (file &optional editable rev)
  (message "Checking out %s..." file)
  (with-current-buffer (or (get-file-buffer file) (current-buffer))
    (vc-call update file editable rev (vc-switches 'SVK 'checkout)))
  (vc-mode-line file)
  (message "Checking out %s...done" file))

(defun vc-svk-update (file editable rev switches)
  (if (and (file-exists-p file) (not rev))
      ;; If no revision was specified, just make the file writable
      ;; if necessary (using `svk-edit' if requested).
      (and editable (not (eq (vc-svk-checkout-model file) 'implicit))
	      (if vc-svk-use-edit
		         (vc-svk-command nil 0 file "edit")
		     (set-file-modes file (logior (file-modes file) 128))
		          (if (equal file buffer-file-name) (toggle-read-only -1))))
    ;; Check out a particular version (or recreate the file).
    (vc-file-setprop file 'vc-workfile-version nil)
    (apply 'vc-svk-command nil 0 file
	      "update"
	         ;; default for verbose checkout: clear the sticky tag so
	         ;; that the actual update will get the head of the trunk
	         (cond
		      ((null rev) "-rBASE")
		          ((or (eq rev t) (equal rev "")) nil)
			      (t (concat "-r" rev)))
		    switches)))

(defun vc-svk-delete-file (file)
  (vc-svk-command nil 0 file "remove"))

(defun vc-svk-rename-file (old new)
  (vc-svk-command nil 0 new "move" (file-relative-name old)))

(defun vc-svk-revert (file &optional contents-done)
  "Revert FILE to the version it was based on."
  (unless contents-done
    (vc-svk-command nil 0 file "revert"))
  (unless (eq (vc-checkout-model file) 'implicit)
    (if vc-svk-use-edit
        (vc-svk-command nil 0 file "unedit")
      ;; Make the file read-only by switching off all w-bits
      (set-file-modes file (logand (file-modes file) 3950)))))

(defun vc-svk-merge (file first-version &optional second-version)
  "Merge changes into current working copy of FILE.
The changes are between FIRST-VERSION and SECOND-VERSION."
  (vc-svk-command nil 0 file
                 "merge"
		  "-r" (if second-version
			   (concat first-version ":" second-version)
			       first-version))
  (vc-file-setprop file 'vc-state 'edited)
  (with-current-buffer (get-buffer "*vc*")
    (goto-char (point-min))
    (if (looking-at "C  ")
        1; signal conflict
      0))); signal success

(defun vc-svk-merge-news (file)
  "Merge in any new changes made to FILE."
  (message "Merging changes into %s..." file)
  ;; (vc-file-setprop file 'vc-workfile-version nil)
  (vc-file-setprop file 'vc-checkout-time 0)
  (vc-svk-command nil 0 file "update")
  ;; Analyze the merge result reported by SVK, and set
  ;; file properties accordingly.
  (with-current-buffer (get-buffer "*vc*")
    (goto-char (point-min))
    ;; get new workfile version
    (if (re-search-forward
	  "^\\(Updated to\\|At\\) revision \\([0-9]+\\)" nil t)
	(vc-file-setprop file 'vc-workfile-version (match-string 2))
      (vc-file-setprop file 'vc-workfile-version nil))
    ;; get file status
    (goto-char (point-min))
    (prog1
        (if (looking-at "At revision")
            0 ;; there were no news; indicate success
          (if (re-search-forward
               (concat "^\\([CGDU]  \\)?"
                       (regexp-quote (file-name-nondirectory file)))
               nil t)
              (cond
               ;; Merge successful, we are in sync with repository now
               ((string= (match-string 1) "U  ")
                (vc-file-setprop file 'vc-state 'up-to-date)
                (vc-file-setprop file 'vc-checkout-time
                                 (nth 5 (file-attributes file)))
                0);; indicate success to the caller
               ;; Merge successful, but our own changes are still in the file
               ((string= (match-string 1) "G  ")
                (vc-file-setprop file 'vc-state 'edited)
                0);; indicate success to the caller
               ;; Conflicts detected!
               (t
                (vc-file-setprop file 'vc-state 'edited)
                1);; signal the error to the caller
               )
            (pop-to-buffer "*vc*")
            (error "Couldn't analyze svk update result")))
      (message "Merging changes into %s...done" file))))


;;;
;;; History functions
;;;

(defun vc-svk-print-log (file &optional buffer)
  "Get change log associated with FILE."
  (save-current-buffer
    (vc-setup-buffer buffer)
    (let ((inhibit-read-only t))
      (goto-char (point-min))
      ;; Add a line to tell log-view-mode what file this is.
      (insert "Working file: " (file-relative-name file) "\n"))
    (vc-svk-command
     buffer
     (if (and (vc-stay-local-p file) (fboundp 'start-process)) 'async 0)
     file "log")))

(defun vc-svk-diff (file &optional oldvers newvers buffer)
  "Get a difference report using SVK between two versions of FILE."
  (unless buffer (setq buffer "*vc-diff*"))
  (if (and oldvers (equal oldvers (vc-workfile-version file)))
      ;; Use nil rather than the current revision because svk handles it
      ;; better (i.e. locally).
      (setq oldvers nil))
  (if (string= (vc-workfile-version file) "0")
      ;; This file is added but not yet committed; there is no master file.
      (if (or oldvers newvers)
	    (error "No revisions of %s exist" file)
	;; We regard this as "changed".
	;; Diff it against /dev/null.
	;; Note: this is NOT a "svk diff".
	(apply 'vc-do-command buffer
	              1 "diff" file
		             (append (vc-switches nil 'diff) '("/dev/null")))
	;; Even if it's empty, it's locally modified.
	1)
    (let* ((switches
	        (if vc-svk-diff-switches
		    (vc-switches 'SVK 'diff)
		        (list "-x" (mapconcat 'identity (vc-switches nil 'diff) " "))))
	      (async (and (not vc-disable-async-diff)
                       (vc-stay-local-p file)
		              (or oldvers newvers) ; Svk diffs those locally.
			             (fboundp 'start-process))))
      (apply 'vc-svk-command buffer
	          (if async 'async 0)
		       file "diff"
		            (append
			           switches
				         (when oldvers
					   (list "-r" (if newvers (concat oldvers ":" newvers)
							     oldvers)))))
      (if async 1      ; async diff => pessimistic assumption
	;; For some reason `svk diff' does not return a useful
	;; status w.r.t whether the diff was empty or not.
	(buffer-size (get-buffer buffer))))))

(defun vc-svk-diff-tree (dir &optional rev1 rev2)
  "Diff all files at and below DIR."
  (vc-svk-diff (file-name-as-directory dir) rev1 rev2))

;;;
;;; Snapshot system
;;;

(defun vc-svk-create-snapshot (dir name branchp)
  "Assign to DIR's current version a given NAME.
If BRANCHP is non-nil, the name is created as a branch (and the current
workspace is immediately moved to that new branch).
NAME is assumed to be a URL."
  (vc-svk-command nil 0 dir "copy" name)
  (when branchp (vc-svk-retrieve-snapshot dir name nil)))

(defun vc-svk-retrieve-snapshot (dir name update)
  "Retrieve a snapshot at and below DIR.
NAME is the name of the snapshot; if it is empty, do a `svk update'.
If UPDATE is non-nil, then update (resynch) any affected buffers.
NAME is assumed to be a URL."
  (vc-svk-command nil 0 dir "switch" name)
  ;; FIXME: parse the output and obey `update'.
  )

;;;
;;; Miscellaneous
;;;

;; Subversion makes backups for us, so don't bother.
;; (defalias 'vc-svk-make-version-backups-p 'vc-stay-local-p
;;   "Return non-nil if version backups should be made for FILE.")

(defun vc-svk-check-headers ()
  "Check if the current file has any headers in it."
  (save-excursion
    (goto-char (point-min))
    (re-search-forward "\\$[A-Za-z\300-\326\330-\366\370-\377]+\
\\(: [\t -#%-\176\240-\377]*\\)?\\$" nil t)))


;;;
;;; Internal functions
;;;

(defun vc-svk-command (buffer okstatus file &rest flags)
  "A wrapper around `vc-do-command' for use in vc-svk.el.
The difference to vc-do-command is that this function always invokes `svk',
and that it passes `vc-svk-global-switches' to it before FLAGS."
  (apply 'vc-do-command buffer okstatus "svk" file
         (if (stringp vc-svk-global-switches)
             (cons vc-svk-global-switches flags)
           (append vc-svk-global-switches
                   flags))))

(defun vc-svk-repository-hostname (dirname)
  (let ((info (vc-svk-do-info-string dirname)))
    (when (string-match "Depot Path: \\(.+$\\)" info)
      (match-string 1 info))))

(defun vc-svk-parse-status (localp)
  "Parse output of `vc-svk-do-status' in the current buffer.
Set file properties accordingly."
  (let (file status)
    (goto-char (point-min))
    (setq status (char-after (line-beginning-position)))
    (unless (eq status ??)
      (search-forward "Checkout Path: " nil t)
      (setq file (buffer-substring (point) (line-end-position)))

      (vc-file-setprop file 'vc-backend 'SVK)
      ;; Use the last-modified revision, so that searching in vc-print-log
      ;; output works.
      (search-forward "Last Changed Rev.: " nil t)
      (vc-file-setprop file 'vc-workfile-version
		              (buffer-substring (point) (line-end-position)))
      (vc-file-setprop
        file 'vc-state
	 (cond
	  ((eq status ?\ ); FIXME
	      'up-to-date)

	    ((eq status ?A)
	        (vc-file-setprop file 'vc-workfile-version "0")
		   (vc-file-setprop file 'vc-checkout-time 0)
		      'edited)

	      ((memq status '(?M ?C))
	          (if (eq (char-after (match-beginning 1)) ?*)
		             'needs-merge
		         'edited))
	        (t 'edited))))
    ))

(defun vc-svk-dir-state-heuristic (dir)
  "Find the SVK state of all files in DIR, using only local information."
  (vc-svk-dir-state dir 'local))

(defun vc-svk-valid-symbolic-tag-name-p (tag)
  "Return non-nil if TAG is a valid symbolic tag name."
  ;; According to the SVK manual, a valid symbolic tag must start with
  ;; an uppercase or lowercase letter and can contain uppercase and
  ;; lowercase letters, digits, `-', and `_'.
  (and (string-match "^[a-zA-Z]" tag)
       (not (string-match "[^a-z0-9A-Z-_]" tag))))

(defun vc-svk-valid-version-number-p (tag)
  "Return non-nil if TAG is a valid version number."
  (and (string-match "^[0-9]" tag)
       (not (string-match "[^0-9]" tag))))

(defun vc-svk-format-cache-file-name (file)
  "Get the SVK cache filename for FILE."
  (expand-file-name
   (concat "~/.svk/cache/"
	      (substitute-if ?_ (lambda (c) (eq c ?/)) file))))

(defsubst vc-svk-do-status ()
  (let ((opoint (point)))
    (vc-svk-command t 0 file "status")
    (when (eq opoint (point))
      (insert-char ?\  1)))
  (vc-svk-command t 0 file "info"))

(defsubst vc-svk-do-info-string (file)
  (shell-command-to-string (concat "svk info "
				      (expand-file-name file))))

(require 'time-date)
(defvar vc-svk-co-paths nil)
(defun vc-svk-co-paths ()
  (let ((mtime (nth 5 (file-attributes "~/.svk/config"))))
    (if (and vc-svk-co-paths
	          (time-less-p (car (last vc-svk-co-paths)) mtime))
	vc-svk-co-paths
      (setq vc-svk-co-paths (list mtime))
      (with-temp-buffer
	(insert-file-contents "~/.svk/config")
	(when (search-forward "hash:\n" nil t)
	    (while (re-search-forward
		      "^    \\(/.*\\):\n.*depotpath: \\(/.+\\)$" nil t))
	      (add-to-list 'vc-svk-co-paths (list (match-string 1)
						        (match-string 2))))))))
(defun vc-svk-co-path-p (file)
  (block nil
    (let ((pathl))
      ;; Check file and each parent dir for svk-ness
      (while (and file (not (string-equal file "/")))
	;; For both SVK and file-name-directory, dirnames must not
	;; include trailing /
	(setq file (substring file 0 (string-match "/\\'" file)))
	(if (setq path (assoc file (vc-svk-co-paths)))
	        (return t)
	    (setq file (file-name-directory file)))))))

(provide 'vc-svk)

;;; vc-svk.el ends here
