; ======================================================================
; Environment Variables
; ======================================================================
(setenv "PATH" (concat ".:/usr/bin:/usr/texbin:/opt/local/bin" (getenv "PATH")))
(setq exec-path (append exec-path '("/usr/bin" "/usr/texbin" "/opt/local/bin")))

; ======================================================================
; Appearance
; ======================================================================
; Fonts
; -----
; The default font, used on any non-OSX platform.
(add-to-list 'default-frame-alist '(font . "Inconsolata-13:antialias=false"))

; Display Column and Line Numbers
; -------------------------------
(setq column-number-mode t)
(setq line-number-mode t)

; ======================================================================
; Global Behavior
; ======================================================================

;; Place all backups into the same directory; cuts down on clutter.
(setq backup-directory-alist `(("." . "~/.backups")))

;; Setup whitespace-mode
(global-whitespace-mode t)

; ======================================================================
; Per-Environment Behavior
; ======================================================================

(when (eq system-type 'darwin) ; mac-specific
  (setq mac-option-modifier 'alt) ;Set 'Option' key to ALT
  (setq mac-command-modifier 'meta) ;Set 'CMD' key to 'M'
  (add-to-list 'default-frame-alist '(font . "Monaco-13"))
  (setq mac-allow-anti-aliasing nil))

; ======================================================================
; Custom Modes
; ======================================================================

; Setup custom directories
(add-to-list 'load-path "~/.emacs.d")           ; Single-file modes
(add-to-list 'load-path "~/.emacs.d/libc-info")
(add-to-list 'load-path "~/.emacs.d/scala-mode")

; Markdown/MMD Mode [2.14.13]
(load "markdown-mode")
(load "multimarkdown-mode")
(setq auto-mode-alist
      (cons '("\\.md" . multimarkdown-mode) auto-mode-alist))

; Scala Mode [2.22.13]
(require 'scala-mode2)

; Sage Mode (TODO: Set conditional)
(add-to-list 'load-path
	     (expand-file-name "/Applications/Sage.app/Contents/Resources/sage/local/share/emacs"))
(require 'sage "sage")
(setq sage-command "/Applications/Sage.app/Contents/Resources/sage/sage")

; Template Mode [1.20.13]
(require 'template)
(template-initialize)

; Quack Mode (Scheme Support) [2.16.13]
(require 'quack)

; Additions to the Info Manuals [2.06.13]
(eval-after-load 'info
  '(progn
     (push "~/.emacs.d/libc-info" Info-default-directory-list)))

; Additions for latex-mode [2.14.13]
(setq LaTeX-mode-hook `turn-on-auto-fill)

;; RESOLVE/C Mode Settings
; resc-Mode [2.09.13]
(load "resc-mode")
(add-hook 'resc-mode-hook 'setup-resc-colors)

(defun setup-resc-colors ()
  "Setup Resolve/C Color Settings"

  ;; Use auto-fill-mode, which is good for writing comments
  (setq resc-mode-hook 'turn-on-auto-fill))

  ;; ;; Font-Lock Colors for RESOLVE/C Programming
  ;; (custom-set-faces
  ;;  '(default ((t (:size "14pt" :background "WhiteSmoke"))) t)
  ;;  '(dired-face-permissions
  ;;    ((t (:foreground "black" :background "grey80"))))
  ;;  '(dired-face-executable
  ;;    ((((class color)) nil)))
  ;;  '(font-lock-comment-face
  ;;    ((t (:italic t :foreground "LightSkyBlue4"))))
  ;;  '(font-lock-doc-string-face
  ;;    ((((class color) (background light)) (:foreground "SeaGreen"))))
  ;;  '(font-lock-function-name-face
  ;;    ((((class color) (background light)) (:foreground "DodgerBlue4"))))
  ;;  '(font-lock-keyword-face
  ;;    ((t (:bold t :foreground "blue"))))
  ;;  '(font-lock-preprocessor-face
  ;;    ((t (:bold t :foreground "black"))))
  ;;  '(font-lock-string-face
  ;;    ((((class color) (background light)) (:foreground "SeaGreen"))))
  ;;  '(font-lock-type-face
  ;;    ((t (:bold t :foreground "black"))))
  ;;  '(font-lock-variable-name-face
  ;;    ((t (:foreground "blue4"))))

  ;;  '(list-mode-item-selected ((t (:background "gray80"))) t)
  ;;  '(dired-face-symlink ((((class color)) (:foreground "blue"))))
  ;;  '(zmacs-region ((t (:background "gray80"))) t)
  ;;  '(dired-face-marked ((((class color)) (:background "gray80"))))))


; Custom Variables, set by Emacs ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(quack-global-menu-p nil)
 '(whitespace-style (quote (face trailing space-before-tab empty space-after-tab lines))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
