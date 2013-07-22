;;; lit-mode.el --- major mode for editing LIT sources

;; Authors: 2005, 2007 Sergey Poznyakoff,
;;;         2013       Rick Hutcheson
;; Version:  0.1
;; Keywords: LaTeX TeX Literate
;; $Id$

;; Copyright (C) 2005, 2007 Sergey Poznyakoff,
;                2013       Rick Hutcheson

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides a major mode for editing CWEB and noweb
;; literate program sources. It is derived from the cweb-mode.el
;; major mode written by Sergey Ponzyakoff.

;; Since the three major parts of a LIT file (limbo, Doc section and
;; C section) differ considerably in their syntax, the mode uses a
;; strategy similar to that of po-mode:
;;  1. The source file is made read-only,
;;  2. Special keys are provided that determine syntax and the scope
;;     of the region where the point resides and open an edit window
;;     for this particular syntax. Any number of such windows can be
;;     opened simultaneously.
;;  3. Upon exit from the edit window its contents replaces the original
;;     region in the LIT file.

;;; Installation:

;; You may wish to use precompiled version of the module. To create it
;; run:
;;    emacs -batch -f batch-byte-compile lit-mode.el
;;
;; Copy the file lit-mode.el (and lit-mode.elc, if you created it)
;; somewhere GNU Emacs will find it, add the following lines to your
;; .emacs file:
;;
;; (require 'lit-mode)
;; (setq auto-mode-alist (cons '("\\.w" . lit-mode) auto-mode-alist))

;;; Code:

;; LIT buffers are kept read-only to prevent random modifications.
;; LIT-READ-ONLY holds the value of the read-only flag before LIT mode
;; was entered.
(define-minor-mode lit-keymap-minor-mode
  "A mode to let our settings to override those of the other mode"
  :lighter " literate keys"
  :init-value nil
  :keymap  '(("\C-c\C-c" . lit-subedit-exit)
	     ("\C-c\C-k" . lit-subedit-abort)))

(defvar lit-mode-map ()
  "Keymap used in lit-mode buffers.")

;;; Customization Options
(defgroup lit nil
  "Major mode for editing literate programs with WEB, CWEB or noweb."
  :prefix "lit-"
  :group 'wp
  :link '(url-link "http://TODO.com/"))

(defcustom lit-base-mode 'doc-mode
  "Basic mode for file navigation, not editing."
  :group 'lit)

(defcustom lit-code-mode 'c-mode
  "Mode used for editing program buffers."
  :group 'lit)

(defcustom lit-doc-mode 'doc-mode
  "Mode used for editing documentation buffers."
  :group 'lit)

(unless lit-mode-map
  (setq lit-mode-map (make-sparse-keymap))
  (define-key lit-mode-map "\C-c\C-t" 'lit-edit-doc)
  (define-key lit-mode-map "\C-c\C-c" 'lit-edit-code)
  (define-key lit-mode-map "\C-c\C-m" 'lit-edit-section)
  (define-key lit-mode-map "\C-c\C-n" 'lit-create-section)
  (define-key lit-mode-map "\C-c\C-d" 'lit-remove-section)
  (define-key lit-mode-map "\C-c\C-e" 'lit-toggle-editable)
; (define-key lit-mode-map "\C-n\C-l" 'lit-create-limbo)
; Navigational Shortcuts
  (define-key lit-mode-map "n" 'lit-next-entry)
  (define-key lit-mode-map "p" 'lit-previous-entry)
  (define-key lit-mode-map "N" 'lit-next-major-entry)
  (define-key lit-mode-map "P" 'lit-previous-major-entry)
  (define-key lit-mode-map "q" 'lit-confirm-and-quit)
  (define-key lit-mode-map "Q" 'lit-quit)
  (define-key lit-mode-map "u" 'lit-undo))
  ;FIXME: menu entries

(defconst lit-subedit-message
  "Type 'C-c C-c' once done, or 'C-c C-k' to abort edit"
  "Message to post in the minibuffer when an edit buffer is displayed.")

;; In a string edit buffer, BACK-POINTER points to one of the slots of the
;; list EDITED-FIELDS kept in the LIT buffer.  See its description elsewhere.
(defvar lit-subedit-back-pointer)

;; A list of pending edits. Each entry is of the form:
;; (BEG END MARKER BUFFER NEW-CONDOCT-TYPE)
;; FIXME: Currently only one entry is allowed
(defvar lit-pending-edits)

(defun lit-line-syntax ()
  "Determine current line syntax. Point should stay at the beginning of line."
  (cond
   ((looking-at "[ \t]*@[ *]")
    'doc-section)
   ((looking-at "[ \t]*@$")
    'doc-section)
   ((looking-at "[ \t]*@<.*>\+?=")
    'c-section)
   ((looking-at "[ \t]*@c")
    'c-section)
   ((looking-at "[ \t]*@p")
    'c-section)
   ((looking-at "[ \t]*<<.*>>=")
    'c-section)
   (t
    nil)))

(defun lit-guess-syntax-line ()
  "Guess current syntax condoct. Return (cons CONDOCT START), where START is
the position where the current condoct started."
  (save-excursion
    (beginning-of-line)
    (let ((syntax nil))
      (while (and (null (setq syntax (lit-line-syntax))) (not (bobp)))
	(forward-line -1))
      (if (and (eq syntax 'c-syntax) (not (bobp)))
	  (forward-line 1))
      (cons syntax (point)))))

(defun lit-guess-syntax ()
  "Return syntax condoct."
  (car (lit-guess-syntax-line)))

(defun lit-get-syntax-scope (synt)
  "Get the scope of the current condoct. SYNT is the return value of
(lit-guess-syntax-line).

Return (list CONDOCT START END), where CONDOCT is the condoct syntax,
START and END are the condoct boundaries."
  (save-excursion
    (cond
     ((null (car synt))
      ;; Limbo. Find the start of the first section, whatever it is.
      (let ((end (save-excursion
		   (goto-char (point-min))
		   (while (and (null (lit-line-syntax)) (not (eobp)))
		     (forward-line 1))
		   (point))))
	(list nil (cdr synt) end)))
     ((eq (car synt) 'c-section)
      (list (car synt) (cdr synt)
	    (lit-primitive-find-section 'doc-section 1)))
     ((eq (car synt) 'doc-section)
      (list (car synt) (cdr synt)
	    (lit-primitive-find-section 'c-section 1))))))

(defun lit-primitive-find-section (type dir &optional end-fun)
  "Find the nearest condoct TYPE in direction DIR (1 - forward,
-1 - backward). If the condoct is found, move point to its
beginning and return it. Otervise, if END-FUN is given, call it."
  (let ((limit-fun (if (> dir 0) 'eobp 'bobp)))
    (beginning-of-line)
    (forward-line dir)
    (while (and (not (eq (lit-line-syntax) type)) (not (apply limit-fun nil)))
      (forward-line dir))
    (if (apply limit-fun nil)
	(and end-fun (funcall end-fun)))
    (point)))

(defun lit-find-section (type dir msg)
  "Move point to the start of the nearest condoct TYPE in direction DIR. If not found, print MSG."
  (let ((here (point)))
    (push-mark nil t)
    (lit-primitive-find-section type dir (function (lambda ()
						      (pop-mark)
						      (goto-char here)
						      (message msg))))))

(defun lit-clean-out-killed-edits nil
  "Clean out any edit from lit-pending-edits whose edit buffer has been killed."
  (let ((cursor lit-pending-edits))
    (while cursor
      (let ((slot (car cursor)))
	(setq cursor (cdr cursor))
	(unless (buffer-name (nth 3 slot))
	  (setq lit-pending-edits (delete slot lit-pending-edits)))))))

(defun lit-check-for-pending-edit (position)
  "Resume any pending edit at POSITION.  Return nil if such edit exists."
  (lit-clean-out-killed-edits)
  (let ((marker (make-marker)))
    (set-marker marker position)
    (let ((slot (assoc marker lit-pending-edits)))
      (when slot
	(goto-char (nth 0 slot))
	(pop-to-buffer (nth 3 slot))
	(message lit-subedit-message))
      (not slot))))

(defun lit-check-all-pending-edits ()
  "Resume any pending edit.  Return nil if some remains."
  (lit-clean-out-killed-edits)
  (or (null lit-pending-edits)
      (let ((slot (car lit-pending-edits)))
	(goto-char (nth 0 slot))
	(pop-to-buffer (nth 3 slot))
	(message lit-subedit-message)
	nil)))

(defun lit-help ()
  "Provide an help window for LIT mode."
  (interactive)
  ;FIXME
  (message "Sorry, not yet implemented."))

(defun lit-primitive-subedit-abort ()
  "Exit the subedit buffer and discard its contents. Used by lit-subedit-abort
and lit-subedit-exit."
  (let* ((edit-buffer (current-buffer))
	 (back-pointer lit-subedit-back-pointer)
	 (marker (nth 2 back-pointer))
	 (entry-buffer (marker-buffer marker)))
    (if (null entry-buffer)
	(error "Corresponding sub-buffer does not exist anymore")
      (or (one-window-p) (delete-window))
      (switch-to-buffer entry-buffer)
      (goto-char marker)
      (kill-buffer edit-buffer))
    (setq lit-pending-edits (delete back-pointer lit-pending-edits))
    back-pointer))

(defun lit-subedit-abort ()
  "Exit the subedit buffer, merely discarding its contents."
  (interactive)
  (lit-primitive-subedit-abort))

(defun get-doc-prologue ()
  "Get the prologue string for a Doc part."
  (let ((p (read-from-minibuffer "Doc prologue: "  "@ "))) ; FIXME: use hist
    (while (not (string-match "@[ \\*]" p))
      (setq p (read-from-minibuffer "Please enter Doc prologue: " p)))
    (insert p)))

(defun get-c-prologue ()
  "Get the prologue string for a C part."
  (let ((p (read-from-minibuffer "C prologue: "  "@c"))) ; FIXME: use hist
    (while (not (or (string-match "@<.*>\+?=\\s *" p)
		    (string-match "@c\\s *" p)))
      (setq p (read-from-minibuffer "Please enter code prologue: " p)))
    (insert p)))

(defun lit-subedit-exit ()
  "Exit the subedit buffer, replacing the string in the LIT buffer."
  (interactive)
  (run-hooks 'lit-subedit-exit-hook)
  (let ((string (buffer-string))
	(back-pointer (lit-primitive-subedit-abort)))
    (let ((new-condoct (nth 4 back-pointer))
	  (buffer-read-only lit-read-only))

      ; Prepare for insertion
      (delete-region (nth 0 back-pointer)
		     (nth 1 back-pointer))
      (goto-char (nth 0 back-pointer))

      (cond
       ((eq new-condoct 'doc-section)
	(get-doc-prologue)
	(insert string "\n")
	(lit-edit-scope (list 'c-section (point) (point)) 'c-section))
       ((eq new-condoct 'c-section)
	(get-c-prologue)
	(newline)
	(insert string "\n"))
       (t
	(insert string)))
      (goto-char (nth 0 back-pointer)))))

(defun lit-edit-scope (syntax-scope &optional new)
  "Prepare a pop up buffer for SYNTAX-SCOPE. SYNTAX-SCOPE is a list of
following structure:

   (list SYNTAX BEG END)

where SYNTAX describes the syntax (nil for limbo, 'doc-section or c-section),
BEG and END delimit the region to be edited.

If optional NEW is non-nil, the section being edited is new.
"
  (if (lit-check-for-pending-edit (nth 1 syntax-scope))
      (let* ((beg (let ((start (nth 1 syntax-scope)))
		    (if (and (not new) (eq (car syntax-scope) 'c-section))
			(save-excursion
			  (goto-char start)
			  (let ((bound (save-excursion
					 (forward-line 1)
					 (point))))
			    (or
			     (re-search-forward "[ \t]*@<.*>\+?=[ \t]*"
						bound t)
			     (re-search-forward "[ \t]*@c[ \t]*" bound t)
			     start)))
		      start)))
	     (pos (+ (- (point) beg) 1))
	     (marker (make-marker))
	     (string (buffer-substring
		      beg
		      (nth 2 syntax-scope)))
	    (mode (cond
		   ((null (car syntax-scope))
		    lit-base-mode)
		   ((eq (car syntax-scope) 'c-section)
		    lit-code-mode)
		   ((eq (car syntax-scope) 'doc-section)
		    lit-doc-mode)))
	    (edit-buffer (generate-new-buffer
			  (concat "*" (buffer-name) "*")))
	    (edit-coding buffer-file-coding-system)
	    (buffer (current-buffer))
	    slot)

	(set-marker marker (point))
	(setq slot
	      (append (list beg)
		      (cddr syntax-scope)
		      (list marker edit-buffer new)))
	(setq lit-pending-edits (cons slot lit-pending-edits))
	(pop-to-buffer edit-buffer)
	(erase-buffer)
	(insert string)
	(goto-char pos)
	(funcall mode)
	(run-hooks 'lit-subedit-mode-hook)
	(lit-keymap-minor-mode)
	; Prepare a 'return pointer'
	(set (make-local-variable 'lit-subedit-back-pointer) slot)
	(message lit-subedit-message))))

(defun lit-edit-section ()
  "Edit current LIT section."
  (interactive)
  (let ((syntax-scope (lit-get-syntax-scope (lit-guess-syntax-line))))
    (lit-edit-scope syntax-scope)))

(defun lit-edit-doc ()
  "Edit Doc part of the current LIT file section."
  (interactive)
  (save-excursion
    (let (fail)
      (let ((end-fun (function (lambda () (setq fail t))))
	    (syntax (lit-guess-syntax)))
	(cond
	 ((null syntax)
	  (lit-primitive-find-section 'doc-section 1 end-fun))
	 ((not (eq syntax 'doc-section))
	  (lit-primitive-find-section 'doc-section -1 end-fun)))
	(if fail
	    (message "Cannot find nearest Doc section")
	  (lit-edit-section))))))

(defun lit-edit-code ()
  "Edit C part of the current LIT file section."
  (interactive)
  (save-excursion
    (let (fail)
      (let ((end-fun (function (lambda () (setq fail t))))
	    (syntax (lit-guess-syntax)))
	(cond
	 ((null syntax)
	  (lit-primitive-find-section 'c-section 1 end-fun))
	 ((not (eq syntax 'c-section))
	  (lit-primitive-find-section 'c-section 1 end-fun)))
	(if fail
	    (message "Cannot find nearest C section")
	  (lit-edit-section))))))

(defun lit-create-section ()
    "Create a new section."
    (interactive)
    (let ((syntax-scope (lit-get-syntax-scope (lit-guess-syntax-line))))
      (let ((start (point)))
	(lit-edit-scope (list 'doc-section start start) 'doc-section))))

(defun lit-remove-section ()
  "Remove section surrounding the point."
  (interactive)
  (if (y-or-n-p "Remove current section? ")
      (let ((buffer-read-only lit-read-only))
	(let ((syntax-scope (lit-get-syntax-scope (lit-guess-syntax-line))))
	  (cond
	   ((null (car syntax-scope))
	    (delete-region (nth 1 syntax-scope)
			   (nth 2 syntax-scope))
	    (goto-char (nth 1 syntax-scope)))
	   ((eq (car syntax-scope) 'c-section)
	    ; Remove the preceeding Doc part
	    (when (eq (lit-line-syntax)  'c-section)
	      (forward-line -1))
	    (while (and (not (bobp)) (null (lit-line-syntax)))
	      (forward-line -1))
	    ; Delete the part in question
	    (delete-region (nth 1 syntax-scope)
			   (nth 2 syntax-scope))
	    ; Remove the preceeding part
	    (if (eq (lit-line-syntax) 'doc-section)
		(let ((sc (lit-get-syntax-scope (lit-guess-syntax-line))))
		  (when (eq (car sc) 'doc-section)
		    (delete-region (nth 1 sc)
				   (nth 2 sc))
		    (goto-char (nth 1 sc))))
	      (goto-char (nth 1 syntax-scope))))
	   ((eq (car syntax-scope) 'doc-section)
	    ; Remove eventual following C part
	    (when (eq (lit-line-syntax)  'doc-section)
	      (forward-line 1))
	    (while (and (not (eobp)) (null (lit-line-syntax)))
	      (forward-line 1))
	    (when (eq (lit-line-syntax) 'c-section)
	      (let ((sc (lit-get-syntax-scope (lit-guess-syntax-line))))
		(delete-region (nth 1 sc)
			       (nth 2 sc))))
	    ; Remove the part in question
	    (delete-region (nth 1 syntax-scope)
			   (nth 2 syntax-scope))
	    (goto-char (nth 1 syntax-scope))))))))

(defun lit-undo ()
  "Undo the last change to the LIT file."
  (interactive)
  (let ((buffer-read-only lit-read-only))
    (undo)))

(defun lit-next-entry ()
  "Find next section part of the same part as the current one"
  (interactive)
  (let ((syntax (lit-guess-syntax)))
    (if syntax
	(lit-find-section syntax 1 "No more sections")
      (message "In limbo"))))

(defun lit-previous-entry ()
  "Find previous section part of the same part as the current one"
  (interactive)
  (let ((syntax (lit-guess-syntax)))
    (if syntax
	(lit-find-section syntax -1 "On the first section")
      (message "In limbo"))))

(defun lit-next-major-entry ()
  (interactive)
  ;FIXME
  (message "Sorry, not yet implemented."))

(defun lit-previous-major-entry ()
  ;FIXME
  (message "Sorry, not yet implemented."))

(defun lit-toggle-editable ()
  "Toggle the buffer's editability, allowing for simple changes."
  (interactive)
  (if (lit-check-all-pending-edits)
      (progn
	(setq buffer-read-only (not buffer-read-only))
	(message "Toggle edits again with C-c C-e."))
    (message "Save pending edits first!.")))

(defun lit-quit ()
  "Save the LIT file and kill buffer."
  (interactive)
  (lit-check-all-pending-edits)
  (message "")
  (save-buffer)
  (kill-buffer (current-buffer)))

(defun lit-confirm-and-quit ()
  "Confirm if quit should be attempted and then, do it."
  (when (lit-check-all-pending-edits)
    (if (and (buffer-modified-p)
	     (y-or-n-p "Really quit editing this file? "))
	(lit-quit))
    (message "")))

;;;###autoload
(define-derived-mode lit-mode doct-mode "LITERATE"
  "Major mode for editing lit sources."
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'lit-mode mode-name "LITERATE")
  (set (make-local-variable 'lit-read-only) buffer-read-only)
  (set (make-local-variable 'lit-code-mode) 'c-mode)
  (set (make-local-variable 'lit-base-mode) 'tex-mode)
  (set (make-local-variable 'lit-doc-mode) 'tex-mode)
  (setq buffer-read-only t)
  (set (make-local-variable 'lit-pending-edits) nil)
  (use-local-map lit-mode-map)
  (run-hooks 'lit-mode-hook))

(provide 'lit-mode)

;;; End of lit-mode.el
