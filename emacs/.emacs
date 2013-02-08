; ==============================================================================
; Appearance
; ==============================================================================
; Fonts
; -----
(add-to-list 'default-frame-alist '(font . "Inconsolata"))

; Display Column and Line Numbers
; -------------------------------
(setq column-number-mode t)
(setq line-number-mode t)

; key bindings (from emacswiki.org/emacs/EmacsForMacOS)
; -----------------------------------------------------
(when (eq system-type 'darwin) ;; mac-specific
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta))

; ==============================================================================
; Behavior
; ==============================================================================
(setq backup-directory-alist `(("." . "~/.backups")))

; ==============================================================================
; Custom Modes
; ==============================================================================
; Setup custom directories
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(add-to-list 'load-path "~/.emacs.d/libc-info")

; Markdown Mode [12.13.12]
(add-to-list 'load-path "~/.emacs.d")
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

; Markdown Mode [12.13.12]
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

; Template Mode [1.20.13]
(require 'template)
(template-initialize)

; Auto-Complete [2.06.13]
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/auto-complete/dict")
(ac-config-default)

; Additions to the Info Manuals [2.06.13]
(eval-after-load 'info
  '(progn
     (push "~/.emacs.d/libc-info" Info-default-directory-list)))

; ==============================================================================
; Environment Variables
; ==============================================================================
(setenv "PATH" (concat ".:/usr/bin:/usr/texbin:/opt/local/bin" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/bin" "/usr/texbin" "/opt/local/bin")))

; Custom Variables, set by Emacs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (whiteboard)))
 '(global-whitespace-mode t)
 '(whitespace-style (quote (face trailing space-before-tab empty space-after-tab lines))))
