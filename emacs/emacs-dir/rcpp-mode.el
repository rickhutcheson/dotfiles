;;                                    -*- Emacs-Lisp -*-
;; Author          : C Matthew Curtin <cmcurtin@interhack.net>
;; Created On      : <1999/04/26 17:22:40 cmcurtin>
;; Last Modified By: Rick Hutcheson
;; Last Modified On: Date: 2000/11/10 21:14:26 $
;; Version         : Revision: 0.6 $
;; Maintainer      : cmcurtin+rcpp-mode@interhack.net
;; Status          : Functional

;; Copyright (C) 2000 Interhack Corporation
;; Copyright (C) 1999 Matt Curtin <http://www.interhack.net/people/cmcurtin/>
;; Copyright (C) 1999 The Ohio State University

;; rcpp-mode is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 2, or (at your
;; option) any later version.

;; rcpp-mode is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with XEmacs; see the file COPYING.  If not, write to the Free
;; Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;; Commentary:

;; Resolve/C++ (aka RCPP) is a discipline for component-based software
;; engineering in C++.  The discipline is enforced in a variety of
;; tools that colletively comprise the RCPP development environment.
;; Resolve functionality is given to C++ through the use of templates
;; which textend the language in various ways to make it more suited
;; to the task of building software in components.  This is a major
;; mode that will provide a useful Resolve/C++ editing environment,
;; adding Resolve keywords to the known keywords while maintaining all
;; of the other cool stuff that comes from the excellent "CC Mode", of
;; which this is a derived mode.
;;
;; If you're unfamiliar with the concept of a "derived mode", you can
;; get hip to the idea one of two ways:
;;  o Learn how it really works by checking the Emacs help on major
;;    modes, particularly the bit about derived modes.
;;  o Believe me when I say that it's an Emacs-Lisp sort of inheritance.
;;
;; This mode was developed for use at The Ohio State University's
;; Computer and Information Science Department, by both students and
;; researchers.  More information about Resolve can be found at the
;; OSU Reusable Software Research Group's web page at
;; http://www.cis.ohio-state.edu/rsrg/.
;;
;; The latest and greatest release of rcpp-mode is available on the
;; web at http://www.interhack.net/projects/rcpp-mode/.

;; Code:

(require 'font-lock)
(require 'cc-mode)
(c-initialize-cc-mode)

(defvar rcpp-mode-syntax-table nil
  "Syntax table used in rcpp-mode buffers.")

(if rcpp-mode-syntax-table
    ()
  (setq rcpp-mode-syntax-table (make-syntax-table))
  (c-populate-syntax-table rcpp-mode-syntax-table))
  
(defvar rcpp-version
  (substring (substring "$Revision: 0.6 $" 10) -2 1))

(setq c-version
  (concat c-version " with rcpp-mode " rcpp-version " derived mode"))

(setq auto-mode-alist
      (append
       (list
	'("\\.cc$"   	           . rcpp-mode)
	'("\\.C$"   	           . rcpp-mode)
	'("\\.cpp$"  	           . rcpp-mode)
	'("\\.h[r]?[0-9]*[a-z]?$"  . rcpp-mode))
       auto-mode-alist))

(defun rcpp-mode ()
  "Major mode for developing Resolve/C++ code."
  nil)

(define-derived-mode rcpp-mode c++-mode "RCPP"
  "Major mode for editing Resolve/C++ code.
\\{rcpp-mode-map}"
  ;; set up some default look and feel
  (c-set-style "bsd")
  (setq c-basic-offset 4)
  (make-local-variable 'compile-command)
  (setq compile-command "/class/sce/bin/rcpp-make")
  (delete-menu-item '("C++")) ; kill the C++ menu from C++ Mode.
  ;; Replace the killed C++ menu with the Resolve/C++ menu, defined thusly:
  (add-submenu nil 
	       '("Resolve/C++"
		 ["Comment Out Region"     comment-region (mark)]
		 ["Uncomment Region"
		  (comment-region (region-beginning) (region-end) '(4))
		  (mark)]
		 ["Fill Comment Paragraph" c-fill-paragraph t]
		 "---"
		 ["Indent Region Automatically" c-indent-line-or-region t]
		 ["Indent Region More"
                  (indent-rigidly (region-beginning) (region-end) '4)
                  t]
		 ["Indent Region Less"
                  (indent-rigidly (region-beginning) (region-end) '-4)
                  t]
		 "---"
		 ["Build Project"          compile t]
		 ["First Error"            first-error t]
		 ["Next Error"             next-error t]
		 ["Previous Error"         previous-error t]
		 ["Run Program"            rcpp-run-program t]
		 ))

  (set-syntax-table rcpp-mode-syntax-table)
  (setq major-mode 'rcpp-mode
	mode-name "RCPP"
	local-abbrev-table rcpp-mode-abbrev-table)
  (use-local-map rcpp-mode-map))

(defvar resolve-things (concat (regexp-opt '("abstract_template"
					     "concrete_template"
					     "abstract_instance"
					     "concrete_instance"
					     "utility_class"
					     "implements"
					     "extends"
					     "checks"
					     "instantiates"
					     "encapsulates"
					     "specializes"
					     "employs"
					     "program_body"
					     "procedure"
					     "function"
					     "is_abstract"
					     "global_procedure"
					     "global_function"
					     "local_procedure"
					     "local_function"
					     "utility_procedure"
					     "utility_function"
					     "alters"
					     "consumes"
					     "preserves"
					     "produces"
					     "procedure_body"
					     "function_body"
					     "global_procedure_body"
					     "global_function_body"
					     "local_procedure_body"
					     "local_function_body"
					     "utility_procedure_body"
					     "utility_function_body"
					     "local_utility_procedure_body"
					     "local_utility_function_body"
					     "object"
					     "utility_object"
					     "catalyst"
					     "and"
					     "or"
					     "not"
					     "mod"
					     "enumeration"
					     "Boolean_constant"
					     "Character_constant"
					     "Integer_constant"
					     "Real_constant"
					     "Text_constant"
					     "self"
					     "NULL"
					     "default_value"
					     "no_parameters"
					     "standard_abstract_operations"
					     "standard_concrete_operations"
					     "field_name"
					     "rep_field_name"
					     "number_of_fields"
					     "number_of_displayable_fields"
					     "standard_assignment_operator"
					     "standard_equality_operators"
					     "custom_equality_operators"
					     "standard_comparison_operators"
					     "custom_comparison_operators"
					     "case_select"
					     "Accessor_Position"
					     "current"
					     "assert"
					     "checking_assert"
					     "are_distinct_objects"
					     "debug"
					     "breakpoint"
					     "cond_debug"
					     "cond_breakpoint"
					     "trace"
					     "serr"
					     "Can_Convert_To_Boolean"
					     "Can_Convert_To_Character"
					     "Can_Convert_To_Integer"
					     "Can_Convert_To_Real"
					     "To_char"
					     "To_int"
					     "To_double"
					     "To_Boolean"
					     "To_Character"
					     "To_Integer"
					     "To_Real"
					     "To_Text"
					     "Boolean"
					     "Character"
					     "Integer"
					     "Real"
					     "Text"
					     "Character_IStream"
					     "Character_OStream"
					     "Character_Error_OStream"
					     "Record"
					     "Representation"
					     "Pointer"
					     "Pointer_C"
					     "New"
					     "Delete"
					     "m_pi"
					     "m_e"
					     "Minimum_Character"
					     "Maximum_Character"
					     "Minimum_Integer"
					     "Maximum_Integer"
					     "Minimum_Real"
					     "Maximum_Real"
					     "Sin"
					     "Cos"
					     "Tan"
					     "Arc_Sin"
					     "Arc_Cos"
					     "Arc_Tan"
					     "Sinh"
					     "Cosh"
					     "Tanh"
					     "Abs"
					     "Sign"
					     "Exp"
					     "Power"
					     "Ln"
					     "Log"
					     "Sqr"
					     "Sqrt"
					     "Ceiling"
					     "Floor"
					     "end_user_command_line"
					     "command_line_arguments")))
  "Resolve/C++ keywords to highlight with font locking.")

(defvar rcpp-font-lock-keywords-1 c++-font-lock-keywords-1
  "Subdued level highlighting for rcpp-mode.")

(defvar rcpp-font-lock-keywords-2 
  (append c++-font-lock-keywords-2 (list (cons 
					  (concat
					   "\\<\\(" resolve-things "\\)\\>")
					  font-lock-keyword-face)))
  "Medium level highlighting for rcpp-mode.")

(defvar rcpp-font-lock-keywords-3 c++-font-lock-keywords-3
  "Gaudy level highlighting for rcpp-mode.")

(defvar rcpp-font-lock-keywords 
  (append c++-font-lock-keywords
	  rcpp-font-lock-keywords-1
	  rcpp-font-lock-keywords-2
	  rcpp-font-lock-keywords-3)
  "Keywords for rcpp-mode.")

(define-key rcpp-mode-map [return] 'newline-and-indent)

(defun rcpp-run-program (&optional prog-name)
    "Interactively run an executable program in a separate shell
buffer.  This command will be run in the same directory as the file
contained in the current buffer.  If an executable with the same base
name as the current file exists, it will be run; otherwise, the user
will be prompted for the name of the executable to run."
    (interactive)
    (let ((explicit-shell-file-name
	   (substring (buffer-file-name) 0
		      (string-match "\\." (buffer-file-name)))))
      (shell)))

;; HISTORY 
;; $Log: rcpp-mode.el,v $
;; Revision 0.7  2007/08/27 weide
;; Minor updates...
;;
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

(provide 'rcpp-mode)
;;; rcpp-mode.el ends here
