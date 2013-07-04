;;; cweb-mode.el --- major mode for editing CWEB sources

;; Authors: 2005, 2007 Sergey Poznyakoff,
;;;         2013       Rick Hutcheson
;; Version:  1.1
;; Keywords: CWEB TeX C
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

;; This package provides a major mode for editing CWEB sources under
;; GNU Emacs.

;; Since the three major parts of a CWEB file (limbo, TeX section and
;; C section) differ considerably in their syntax, the mode uses a
;; strategy similar to that of po-mode:
;;  1. The source file is made read-only,
;;  2. Special keys are provided that determine syntax and the scope
;;     of the region where the point resides and open an edit window
;;     for this particular syntax. Any number of such windows can be
;;     opened simultaneously.
;;  3. Upon exit from the edit window its contents replaces the original
;;     region in the CWEB file.

;;; Installation:

;; You may wish to use precompiled version of the module. To create it
;; run:
;;    emacs -batch -f batch-byte-compile cweb-mode.el
;;
;; Copy the file cweb-mode.el (and cweb-mode.elc, if you created it)
;; somewhere GNU Emacs will find it, add the following lines to your
;; .emacs file:
;;
;; (require 'cweb-mode)
;; (setq auto-mode-alist (cons '("\\.w" . cweb-mode) auto-mode-alist))

;;; Code:

;; CWEB buffers are kept read-only to prevent random modifications.
;; CWEB-READ-ONLY holds the value of the read-only flag before CWEB mode
;; was entered.
(defvar cweb-read-only)
(defvar cweb-base-mode 'tex-mode
  "Mode for overall view.")
(defvar cweb-code-mode 'c-mode
  "Mode for editing code.")
(defvar cweb-doc-mode 'tex-mode
  "Mode for editing documentation.")

(defvar cweb-mode-map ()
  "Keymap used in cweb-mode buffers.")

(unless cweb-mode-map
  (setq cweb-mode-map (make-sparse-keymap))
  (define-key cweb-mode-map "\C-c\C-t" 'cweb-edit-tex)
  (define-key cweb-mode-map "\C-c\C-c" 'cweb-edit-c)
  (define-key cweb-mode-map "\C-c\C-m" 'cweb-edit-section)
  (define-key cweb-mode-map "\C-c\C-n" 'cweb-create-section)
  (define-key cweb-mode-map "\C-c\C-d" 'cweb-remove-section)
  (define-key cweb-mode-map "\C-c\C-e" 'cweb-toggle-editable)
; (define-key cweb-mode-map "\C-n\C-l" 'cweb-create-limbo)
; Navigational Shortcuts
  (define-key cweb-mode-map "n" 'cweb-next-entry)
  (define-key cweb-mode-map "p" 'cweb-previous-entry)
  (define-key cweb-mode-map "N" 'cweb-next-major-entry)
  (define-key cweb-mode-map "P" 'cweb-previous-major-entry)
  (define-key cweb-mode-map "q" 'cweb-confirm-and-quit)
  (define-key cweb-mode-map "Q" 'cweb-quit)
  (define-key cweb-mode-map "u" 'cweb-undo))
  ;FIXME: menu entries

(defvar cweb-subedit-map ()
  "Keymap used in cweb-mode subedit buffers.")

(unless cweb-subedit-map
  (setq cweb-subedit-map (make-sparse-keymap))
  (define-key cweb-subedit-map "\C-c\C-c" 'cweb-subedit-exit)
  (define-key cweb-subedit-map "\C-c\C-k" 'cweb-subedit-abort))

(defconst cweb-subedit-message
  "Type 'C-c C-c' once done, or 'C-c C-k' to abort edit"
  "Message to post in the minibuffer when an edit buffer is displayed.")

;; In a string edit buffer, BACK-POINTER points to one of the slots of the
;; list EDITED-FIELDS kept in the CWEB buffer.  See its description elsewhere.
(defvar cweb-subedit-back-pointer)

;; A list of pending edits. Each entry is of the form:
;; (BEG END MARKER BUFFER NEW-CONTEXT-TYPE)
;; FIXME: Currently only one entry is allowed
(defvar cweb-pending-edits)


(defun cweb-line-syntax ()
  "Determine current line syntax. Point should stay at the beginnig of line."
  (cond
   ((looking-at "[ \t]*@[ *]")
    'tex-section)
   ((looking-at "[ \t]*@$")
    'tex-section)
   ((looking-at "[ \t]*@<.*>\+?=")
    'c-section)
   ((looking-at "[ \t]*@c")
    'c-section)
   ((looking-at "[ \t]*@p")
    'c-section)
   (t
    nil)))

(defun cweb-guess-syntax-line ()
  "Guess current syntax context. Return (cons CONTEXT START), where START is
the position where the current context started."
  (save-excursion
    (beginning-of-line)
    (let ((syntax nil))
      (while (and (null (setq syntax (cweb-line-syntax))) (not (bobp)))
	(forward-line -1))
      (if (and (eq syntax 'c-syntax) (not (bobp)))
	  (forward-line 1))
      (cons syntax (point)))))

(defun cweb-guess-syntax ()
  "Return syntax context."
  (car (cweb-guess-syntax-line)))

(defun cweb-get-syntax-scope (synt)
  "Get the scope of the current context. SYNT is the return value of
(cweb-guess-syntax-line).

Return (list CONTEXT START END), where CONTEXT is the context syntax,
START and END are the context boundaries."
  (save-excursion
    (cond
     ((null (car synt))
      ;; Limbo. Find the start of the first section, whatever it is.
      (let ((end (save-excursion
		   (goto-char (point-min))
		   (while (and (null (cweb-line-syntax)) (not (eobp)))
		     (forward-line 1))
		   (point))))
	(list nil (cdr synt) end)))
     ((eq (car synt) 'c-section)
      (list (car synt) (cdr synt)
	    (cweb-primitive-find-section 'tex-section 1)))
     ((eq (car synt) 'tex-section)
      (list (car synt) (cdr synt)
	    (cweb-primitive-find-section 'c-section 1))))))

(defun cweb-primitive-find-section (type dir &optional end-fun)
  "Find the nearest context TYPE in direction DIR (1 - forward,
-1 - backward). If the context is found, move point to its
beginning and return it. Otervise, if END-FUN is given, call it."
  (let ((limit-fun (if (> dir 0) 'eobp 'bobp)))
    (beginning-of-line)
    (forward-line dir)
    (while (and (not (eq (cweb-line-syntax) type)) (not (apply limit-fun nil)))
      (forward-line dir))
    (if (apply limit-fun nil)
	(and end-fun (funcall end-fun)))
    (point)))

(defun cweb-find-section (type dir msg)
  "Move point to the start of the nearest context TYPE in direction DIR. If not found, print MSG."
  (let ((here (point)))
    (push-mark nil t)
    (cweb-primitive-find-section type dir (function (lambda ()
						      (pop-mark)
						      (goto-char here)
						      (message msg))))))

(defun cweb-clean-out-killed-edits nil
  "Clean out any edit from cweb-pending-edits whose edit buffer has been killed."
  (let ((cursor cweb-pending-edits))
    (while cursor
      (let ((slot (car cursor)))
	(setq cursor (cdr cursor))
	(unless (buffer-name (nth 3 slot))
	  (setq cweb-pending-edits (delete slot cweb-pending-edits)))))))

(defun cweb-check-for-pending-edit (position)
  "Resume any pending edit at POSITION.  Return nil if such edit exists."
  (cweb-clean-out-killed-edits)
  (let ((marker (make-marker)))
    (set-marker marker position)
    (let ((slot (assoc marker cweb-pending-edits)))
      (when slot
	(goto-char (nth 0 slot))
	(pop-to-buffer (nth 3 slot))
	(message cweb-subedit-message))
      (not slot))))

(defun cweb-check-all-pending-edits ()
  "Resume any pending edit.  Return nil if some remains."
  (cweb-clean-out-killed-edits)
  (or (null cweb-pending-edits)
      (let ((slot (car cweb-pending-edits)))
	(goto-char (nth 0 slot))
	(pop-to-buffer (nth 3 slot))
	(message cweb-subedit-message)
	nil)))

(defun cweb-help ()
  "Provide an help window for CWEB mode."
  (interactive)
  ;FIXME
  (message "Sorry, not yet implemented."))

(defun cweb-primitive-subedit-abort ()
  "Exit the subedit buffer and discard its contents. Used by cweb-subedit-abort
and cweb-subedit-exit."
  (let* ((edit-buffer (current-buffer))
	 (back-pointer cweb-subedit-back-pointer)
	 (marker (nth 2 back-pointer))
	 (entry-buffer (marker-buffer marker)))
    (if (null entry-buffer)
	(error "Corresponding CWEB buffer does not exist anymore")
      (or (one-window-p) (delete-window))
      (switch-to-buffer entry-buffer)
      (goto-char marker)
      (kill-buffer edit-buffer))
    (setq cweb-pending-edits (delete back-pointer cweb-pending-edits))
    back-pointer))

(defun cweb-subedit-abort ()
  "Exit the subedit buffer, merely discarding its contents."
  (interactive)
  (cweb-primitive-subedit-abort))

(defun get-tex-prologue ()
  "Get the prologue string for a TeX part."
  (let ((p (read-from-minibuffer "Tex prologue: "  "@ "))) ; FIXME: use hist
    (while (not (string-match "@[ \\*]" p))
      (setq p (read-from-minibuffer "Please enter Tex prologue: " p)))
    (insert p)))

(defun get-c-prologue ()
  "Get the prologue string for a C part."
  (let ((p (read-from-minibuffer "C prologue: "  "@c"))) ; FIXME: use hist
    (while (not (or (string-match "@<.*>\+?=\\s *" p)
		    (string-match "@c\\s *" p)))
      (setq p (read-from-minibuffer "Please enter C prologue: " p)))
    (insert p)))

(defun cweb-subedit-exit ()
  "Exit the subedit buffer, replacing the string in the CWEB buffer."
  (interactive)
  (run-hooks 'cweb-subedit-exit-hook)
  (let ((string (buffer-string))
	(back-pointer (cweb-primitive-subedit-abort)))
    (let ((new-context (nth 4 back-pointer))
	  (buffer-read-only cweb-read-only))

      ; Prepare for insertion
      (delete-region (nth 0 back-pointer)
		     (nth 1 back-pointer))
      (goto-char (nth 0 back-pointer))

      (cond
       ((eq new-context 'tex-section)
	(get-tex-prologue)
	(insert string "\n")
	(cweb-edit-scope (list 'c-section (point) (point)) 'c-section))
       ((eq new-context 'c-section)
	(get-c-prologue)
	(newline)
	(insert string "\n"))
       (t
	(insert string)))
      (goto-char (nth 0 back-pointer)))))

(defun cweb-edit-scope (syntax-scope &optional new)
  "Prepare a pop up buffer for SYNTAX-SCOPE. SYNTAX-SCOPE is a list of
following structure:

   (list SYNTAX BEG END)

where SYNTAX describes the syntax (nil for limbo, 'tex-section or c-section),
BEG and END delimit the region to be edited.

If optional NEW is non-nil, the section being edited is new.
"
  (if (cweb-check-for-pending-edit (nth 1 syntax-scope))
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
		    cweb-base-mode)
		   ((eq (car syntax-scope) 'c-section)
		    cweb-code-mode)
		   ((eq (car syntax-scope) 'tex-section)
		    cweb-doc-mode)))
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
	(setq cweb-pending-edits (cons slot cweb-pending-edits))

	(pop-to-buffer edit-buffer)
	(erase-buffer)
	(insert string)
	(goto-char pos)
	(funcall mode)
	(let ((map (copy-keymap cweb-subedit-map)))
	  (set-keymap-parent map (current-local-map))
	  (use-local-map map))
	(run-hooks 'cweb-subedit-mode-hook)
	; Prepare a 'return pointer'
	(set (make-local-variable 'cweb-subedit-back-pointer) slot)
	(message cweb-subedit-message))))

(defun cweb-edit-section ()
  "Edit current CWEB section."
  (interactive)
  (let ((syntax-scope (cweb-get-syntax-scope (cweb-guess-syntax-line))))
    (cweb-edit-scope syntax-scope)))

(defun cweb-edit-tex ()
  "Edit TeX part of the current CWEB file section."
  (interactive)
  (save-excursion
    (let (fail)
      (let ((end-fun (function (lambda () (setq fail t))))
	    (syntax (cweb-guess-syntax)))
	(cond
	 ((null syntax)
	  (cweb-primitive-find-section 'tex-section 1 end-fun))
	 ((not (eq syntax 'tex-section))
	  (cweb-primitive-find-section 'tex-section -1 end-fun)))
	(if fail
	    (message "Cannot find nearest TeX section")
	  (cweb-edit-section))))))

(defun cweb-edit-c ()
  "Edit C part of the current CWEB file section."
  (interactive)
  (save-excursion
    (let (fail)
      (let ((end-fun (function (lambda () (setq fail t))))
	    (syntax (cweb-guess-syntax)))
	(cond
	 ((null syntax)
	  (cweb-primitive-find-section 'c-section 1 end-fun))
	 ((not (eq syntax 'c-section))
	  (cweb-primitive-find-section 'c-section 1 end-fun)))
	(if fail
	    (message "Cannot find nearest C section")
	  (cweb-edit-section))))))

(defun cweb-create-section ()
    "Create a new section."
    (interactive)
    (let ((syntax-scope (cweb-get-syntax-scope (cweb-guess-syntax-line))))
      (let ((start (point)))
	(cweb-edit-scope (list 'tex-section start start) 'tex-section))))

(defun cweb-remove-section ()
  "Remove section surrounding the point."
  (interactive)
  (if (y-or-n-p "Remove current section? ")
      (let ((buffer-read-only cweb-read-only))
	(let ((syntax-scope (cweb-get-syntax-scope (cweb-guess-syntax-line))))
	  (cond
	   ((null (car syntax-scope))
	    (delete-region (nth 1 syntax-scope)
			   (nth 2 syntax-scope))
	    (goto-char (nth 1 syntax-scope)))
	   ((eq (car syntax-scope) 'c-section)
	    ; Remove the preceeding TeX part
	    (when (eq (cweb-line-syntax)  'c-section)
	      (forward-line -1))
	    (while (and (not (bobp)) (null (cweb-line-syntax)))
	      (forward-line -1))
	    ; Delete the part in question
	    (delete-region (nth 1 syntax-scope)
			   (nth 2 syntax-scope))
	    ; Remove the preceeding part
	    (if (eq (cweb-line-syntax) 'tex-section)
		(let ((sc (cweb-get-syntax-scope (cweb-guess-syntax-line))))
		  (when (eq (car sc) 'tex-section)
		    (delete-region (nth 1 sc)
				   (nth 2 sc))
		    (goto-char (nth 1 sc))))
	      (goto-char (nth 1 syntax-scope))))
	   ((eq (car syntax-scope) 'tex-section)
	    ; Remove eventual following C part
	    (when (eq (cweb-line-syntax)  'tex-section)
	      (forward-line 1))
	    (while (and (not (eobp)) (null (cweb-line-syntax)))
	      (forward-line 1))
	    (when (eq (cweb-line-syntax) 'c-section)
	      (let ((sc (cweb-get-syntax-scope (cweb-guess-syntax-line))))
		(delete-region (nth 1 sc)
			       (nth 2 sc))))
	    ; Remove the part in question
	    (delete-region (nth 1 syntax-scope)
			   (nth 2 syntax-scope))
	    (goto-char (nth 1 syntax-scope))))))))

(defun cweb-undo ()
  "Undo the last change to the CWEB file."
  (interactive)
  (let ((buffer-read-only cweb-read-only))
    (undo)))

(defun cweb-next-entry ()
  "Find next section part of the same part as the current one"
  (interactive)
  (let ((syntax (cweb-guess-syntax)))
    (if syntax
	(cweb-find-section syntax 1 "No more sections")
      (message "In limbo"))))

(defun cweb-previous-entry ()
  "Find previous section part of the same part as the current one"
  (interactive)
  (let ((syntax (cweb-guess-syntax)))
    (if syntax
	(cweb-find-section syntax -1 "On the first section")
      (message "In limbo"))))

(defun cweb-next-major-entry ()
  (interactive)
  ;FIXME
  (message "Sorry, not yet implemented."))

(defun cweb-previous-major-entry ()
  ;FIXME
  (message "Sorry, not yet implemented."))

(defun cweb-toggle-editable ()
  "Toggle the buffer's editability, allowing for simple changes."
  (interactive)
  (if (cweb-check-all-pending-edits)
      (progn
	(setq buffer-read-only (not buffer-read-only))
	(message "Toggle edits again with C-c C-e."))
    (message "Save pending edits first!.")))

(defun cweb-quit ()
  "Save the CWEB file and kill buffer."
  (interactive)
  (cweb-check-all-pending-edits)
  (message "")
  (save-buffer)
  (kill-buffer (current-buffer)))

(defun cweb-confirm-and-quit ()
  "Confirm if quit should be attempted and then, do it."
  (when (cweb-check-all-pending-edits)
    (if (and (buffer-modified-p)
	     (y-or-n-p "Really quit editing this CWEB file? "))
	(cweb-quit))
    (message "")))

(defun cweb-mode ()
  "Major mode for editing cweb sources.
Key bindings:
\\{cweb-mode-map}
"
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'cweb-mode mode-name "CWEB")
  (setq buffer-read-only t)
  (set (make-local-variable 'cweb-read-only) buffer-read-only)
  (set (make-local-variable 'cweb-pending-edits) nil)
  (use-local-map cweb-mode-map))
(provide 'cweb-mode)

;;; End of cweb-mode.el
