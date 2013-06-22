;;; resc-mode.el --- A derived mode for RESOLVE/C code.
;; -*- Emacs-Lisp -*-
;; Author           : C Matthew Curtin <cmcurtin@interhack.net>
;; Created On       : <1999/04/26 17:22:40 cmcurtin>
;; Last Modified By : Rick Hutcheson
;; Last Modified On : Date: 2013/02/10 21:14:26
;; Version          : Revision: 0.1
;; Maintainer       : rick+resolve@statemachine.co
;; Status           : Experimental

;; Copyright (C) 2013 Rick Hutcheson (http://statemachine.co/about)
;; Copyright (C) 2000 Interhack Corporation
;; Copyright (C) 1999 Matt Curtin <http://www.interhack.net/people/cmcurtin/>
;; Copyright (C) 1999 The Ohio State University

;; resc-mode is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; resc-mode is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with Emacs; see the file COPYING.  If not, write to the Free
;; Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:
;;
;; RESOLVE/C is a disciplined approach to C development based on the
;; excellent RESOLVE/C++ discipline.  (http://www.cse.ohio-state.edu/rsrg/)
;;
;; This mode was first developed for use at The Ohio State University's
;; Computer and Information Science Department, by both students and
;; researchers.  More information about Resolve can be found at the
;; OSU Reusable Software Research Group's web page at
;; http://www.cse.ohio-state.edu/rsrg/.
;;

;; Code:

(require 'font-lock)
(require 'cc-mode)
;;; Code:

(c-initialize-cc-mode)
(defvar resc-mode-syntax-table nil
  "Syntax table used in resc-mode buffers.")

(if resc-mode-syntax-table
    ()
  (setq resc-mode-syntax-table (make-syntax-table))
  (c-populate-syntax-table resc-mode-syntax-table))

(defvar resc-version "0.1")

(setq c-version
      (concat c-version " with resc-mode " resc-version " derived mode"))

(setq auto-mode-alist
      (append
       (list
	'("\\.c$" . resc-mode)
	'("\\.h$" . resc-mode))
       auto-mode-alist))

(defun resc-mode ()
  "Major mode for developing Resolve/C code."
  nil)

(define-derived-mode resc-mode c-mode "RESC"
  "Major mode for editing Resolve/C code.
\\{resc-mode-map}"
  ;; set up some default look and feel
  (c-set-style "bsd")
  (setq c-basic-offset 4)
  ;;  (make-local-variable 'compile-command)
  ;;  (setq compile-command "/class/sce/bin/resc-make")
  ;;  (delete-menu-item '("C++")) ; kill the C++ menu from C++ Mode.
  ;; Replace the killed C++ menu with the Resolve/C++ menu, defined thusly:
  ;;  (add-submenu nil
  ;;	       '("Resolve/C++"
  ;;		 ["Comment Out Region"     comment-region (mark)]
  ;;		 ["Uncomment Region"
  ;;		  (comment-region (region-beginning) (region-end) '(4))
  ;;		  (mark)]
  ;;		 ["Fill Comment Paragraph" c-fill-paragraph t]
  ;;		 "---"
  ;;		 ["Indent Region Automatically" c-indent-line-or-region t]
  ;;		 ["Indent Region More"
  ;;                  (indent-rigidly (region-beginning) (region-end) '4)
  ;;                  t]
  ;;		 ["Indent Region Less"
  ;;                  (indent-rigidly (region-beginning) (region-end) '-4)
  ;;                  t]
  ;;		 "---"
  ;;		 ["Build Project"          compile t]
  ;;		 ["First Error"            first-error t]
  ;;		 ["Next Error"             next-error t]
  ;;		 ["Previous Error"         previous-error t]
  ;;		 ["Run Program"            resc-run-program t]
  ;;		 ))

  (set-syntax-table resc-mode-syntax-table)
  (setq major-mode 'resc-mode
	mode-name "RESC"
	local-abbrev-table resc-mode-abbrev-table)
  (use-local-map resc-mode-map))

(defvar resolve-c-keywords '("abstract_template"
			     "abstract_instance"
			     "aliases" ;; EXPERIMENTAL
			     "alters"
			     "and"
			     "are_distinct_objects"
			     "assert"
			     "breakpoint"
			     "case_select"
			     "catalyst"
			     "checking_assert"
			     "checks"
			     "command_line_arguments"
			     "concrete_instance"
			     "concrete_template"
			     "cond_breakpoint"
			     "cond_debug"
			     "consumes"
			     "current"
			     "custom_comparison_operators"
			     "custom_equality_operators"
			     "debug"
			     "default_value"
			     "employs"
			     "encapsulates"
			     "end_user_command_line"
			     "enumeration"
			     "extends"
			     "field_name"
			     "function"
			     "function_body"
			     "global_function"
			     "global_function_body"
			     "global_procedure"
			     "global_procedure_body"
			     "implements"
			     "instantiates"
			     "is_abstract"
			     "local_function"
			     "local_procedure"
			     "local_function_body"
			     "local_procedure_body"
			     "local_utility_function_body"
			     "local_utility_procedure_body"
			     "m_pi"
			     "m_e"
			     "mod"
			     "no_parameters"
			     "not"
			     "number_of_displayable_fields"
			     "number_of_fields"
			     "or"
			     "point_to" ;; EXPERIMENTAL
			     "preserves"
			     "produces"
			     "procedure"
			     "procedure_body"
			     "program_body"
			     "rep_field_name"
			     "serr"
			     "self"
			     "specializes"
			     "standard_abstract_operations"
			     "standard_assignment_operator"
			     "standard_comparison_operators"
			     "standard_concrete_operations"
			     "standard_equality_operators"
			     "trace"
			     "utility_class"
			     "utility_function"
			     "utility_function_body"
			     "utility_procedure"
			     "utility_procedure_body"
			     "object"
			     "utility_object"
			     "Abs"
			     "Accessor_Position"
			     "Arc_Cos"
			     "Arc_Sin"
			     "Arc_Tan"
			     "Boolean"
			     "Boolean_Constant"
			     "Can_Convert_To_Boolean"
			     "Can_Convert_To_Character"
			     "Can_Convert_To_Integer"
			     "Can_Convert_To_Real"
			     "Ceiling"
			     "Character"
			     "Character_Constant"
			     "Character_IStream"
			     "Character_OStream"
			     "Character_Error_OStream"
			     "Cos"
			     "Cosh"
			     "Delete"
			     "Exp"
			     "Floor"
			     "Integer"
			     "Integer_Constant"
			     "Ln"
			     "Log"
			     "Maximum_Character"
			     "Minimum_Character"
			     "Maximum_Integer"
			     "Minimum_Integer"
			     "Maximum_Real"
			     "Minimum_Real"
			     "New"
			     "NULL"
			     "Pointer"
			     "Pointer_C"
			     "Power"
			     "Real"
			     "Real_Constant"
			     "Record"
			     "Representation"
			     "Sign"
			     "Sin"
			     "Sinh"
			     "Sqr"
			     "Sqrt"
			     "Tan"
			     "Tanh"
			     "Text"
			     "Text_Constant"
			     "To_char"
			     "To_int"
			     "To_double"
			     "To_Boolean"
			     "To_Character"
			     "To_Integer"
			     "To_Real"
			     "To_Text")
  "Resolve/C keywords to highlight with font locking.")

(defvar keyword-regexp (regexp-opt resolve-c-keywords `keywords))
; Clear Memory
(setq resolve-c-keywords nil)

; Setup a list compatible with font-lock-mode
; Big thanks to http://ergoemacs.org/emacs/elisp_syntax_coloring.html
(setq resolve-font-lock-keywords
      `(
	(,keyword-regexp . font-lock-keyword-face)))

(font-lock-add-keywords nil '(resolve-font-lock-keywords ))

;(defvar resc-font-lock-keywords-1 c-font-lock-keywords-1 /*     */
;  "Subdued level highlighting for resc-mode.")		    /*   */

;(defvar resc-font-lock-keywords-2	/*	       */
;  (append c-font-lock-keywords-2 (list (cons /*       */
;					  (concat /*   */
;					   "\\<\\(" resolve-things "\\)\\>") /*	  */
;					  font-lock-keyword-face))) /*   */
 ; "Medium level highlighting for resc-mode.") /*   */

;(defvar resc-font-lock-keywords-3 c-font-lock-keywords-3 /*     */
;  "Gaudy level highlighting for resc-mode.")		    /*   */

;(defvar resc-font-lock-keywords	/*	       */
;  (append c-font-lock-keywords		  /*	       */
;	  resc-font-lock-keywords-1	    /*	       */
;	  resc-font-lock-keywords-2	      /*       */
;	  resc-font-lock-keywords-3)		/*     */
 ; "Keywords for resc-mode.")			  /*   */

;(define-key resc-mode-map [return] 'newline-and-indent) /*   */

;; (defun resc-run-program (&optional prog-name)
;;    "Interactively run an executable program in a separate shell buffer.
;; This command will be run in the same directory as the file
;; contained in the current buffer.  If an executable with the same base
;; name as the current file exists, it will be run; otherwise, the user
;; will be prompted for the name of the executable to run."
;;     (interactive)
;;     (let ((explicit-shell-file-name
;;	   (substring (buffer-file-name) 0
;;		      (string-match "\\." (buffer-file-name)))))
;;      (shell)))


;; HISTORY
;; $Log: resc-mode.el,v $
;; Revision 0.1  2013/02/07 hutcheso (Rick Hutcheson)
;; Modified RESOLVE/C++ to RESOLVE/C mode


;; $Log: rcpp-mode.el,v $
;; Revision 0.7  2007/08/27 weide
;; Minor updates...
;; Revision 0.6  2000/11/10 21:14:26  cmcurtin
;; Checking in rowland update to fix a bug that was overriding the
;; indentation preferences badly...  Also includes some keyword changes
;; per RSRG.
;;
;; Revision 0.3  1999/05/31 13:24:07  cmcurtin
;; Minor cleanup: addition of provide clause, "ends-here" comment, and
;; pointer to the official distribution point.
;;
;; Revision 0.2  1999/05/26 02:13:26  cmcurtin
;; First complete implementation.
;;
;; Revision 0.1  1999/04/27 14:25:39  cmcurtin
;; *** empty log message ***
;;

(provide 'resc-mode)
;;; resc-mode.el ends here
