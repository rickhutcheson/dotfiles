;;; git-emacs.el --- Emacs configuration for use with git

;; auto-enable auto-fill-mode for commit messages
(add-to-list 'auto-mode-alist '("COMMIT_EDITMSG\\'" . auto-fill-mode))

