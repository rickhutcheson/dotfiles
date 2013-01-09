; Display Column and Line Numbers
(setq column-number-mode t)
(setq line-number-mode t)

;; key bindings (from emacswiki.org/emacs/EmacsForMacOS)
(when (eq system-type 'darwin) ;; mac-specific
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta)
  (global-set-key [kp-delete] 'delete-char) ;; sets fn-delete to be right-delete
)

; Behavior ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq backup-directory-alist `(("." . "~/.backups")))

; Custom Modes ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Markdown Mode [12.13.12]
(add-to-list 'load-path "~/.emacs.d")
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode) auto-mode-alist))

; Environment Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight thin :height 140 :width normal :foundry "apple" :family "Inconsolata"))))
 '(font-latex-bold-face ((t (:inherit bold :foreground "DeepSkyBlue4"))))
 '(font-latex-italic-face ((t (:inherit italic :foreground "DeepSkyBlue4"))))
 '(font-latex-math-face ((t (:foreground "gray0")))))
