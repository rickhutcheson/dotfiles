;; ---------------------------------------------------------------------
;; backup
;; ---------------------------------------------------------------------

(setq backup-by-copying t               ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.emacs.d/backups"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)                ; use versioned backups
