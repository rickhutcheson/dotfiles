(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cdlatex-math-modify-prefix 47 t)
 '(column-number-mode t)
 '(company-c-headers-path-user
   '("/opt/homebrew/include" "/opt/homebrew/include/CUnit" "/Users/rick/Repositories/learningc/cii/include"))
 '(company-clang-arguments
   '("-I/rick/Repositories/resC/src" "-I/rick/Repositories/resC/src/base" "-I/rick/Repositories/kilo/src/components"))
 '(cscope-browse-without-preview t)
 '(cscope-indexer-suffixes '("*.[chlysS]" "*.[ch]xx" "*.[ch]pp" "*.cc" "*.hh") nil nil "Allow assembly files too")
 '(custom-safe-themes
   '("6fc9e40b4375d9d8d0d9521505849ab4d04220ed470db0b78b700230da0a86c1" "296da7c17c698e963c79b985c6822db0b627f51474c161d82853d2cb1b90afb0" "a22b002b3b0946b8ab8e156b74929ec88252b385c868e1be934631f56535ae1d" "262589c790e262af5fa62d59838f40d0e23bc6455e267aca1816eda86c936c8c" "c20728f5c0cb50972b50c929b004a7496d3f2e2ded387bf870f89da25793bb44" "d2ab3d4f005a9ad4fb789a8f65606c72f30ce9d281a9e42da55f7f4b9ef5bfc6" "daa27dcbe26a280a9425ee90dc7458d85bd540482b93e9fa94d4f43327128077" "297e7e10121ab4ae4320a1a50a2cbd4eabf8db045d170aa002e46ab24f045873" "046a2b81d13afddae309930ef85d458c4f5d278a69448e5a5261a5c78598e012" "d445c7b530713eac282ecdeea07a8fa59692c83045bf84dd112dd738c7bcad1d" "a5270d86fac30303c5910be7403467662d7601b821af2ff0c4eb181153ebfc0a" "7b8f5bbdc7c316ee62f271acf6bcd0e0b8a272fdffe908f8c920b0ba34871d98" "41020bc5a5547dbc5eaf2554d188f516cc5d3b80fd5d5ad804444135a6abf5f4" "f149d9986497e8877e0bd1981d1bef8c8a6d35be7d82cba193ad7e46f0989f6a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "90a6f96a4665a6a56e36dec873a15cbedf761c51ec08dd993d6604e32dd45940" "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1" "7661b762556018a44a29477b84757994d8386d6edee909409fabe0631952dad9" "83e0376b5df8d6a3fbdfffb9fb0e8cf41a11799d9471293a810deb7586c131e6" "d14f3df28603e9517eb8fb7518b662d653b25b26e83bd8e129acea042b774298" "b89ae2d35d2e18e4286c8be8aaecb41022c1a306070f64a66fd114310ade88aa" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "8f97d5ec8a774485296e366fdde6ff5589cf9e319a584b845b6f7fa788c9fa9a" "8d805143f2c71cfad5207155234089729bb742a1cb67b7f60357fdd952044315" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" default))
 '(ede-project-directories '("/Users/rick/Repositories/learningc/kilo"))
 '(mode-line-format
   '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position "  " mode-line-misc-info mode-line-modes
     (vc-mode vc-mode)
     mode-line-end-spaces))
 '(mode-line-percent-position nil)
 '(mode-line-position-column-line-format '("%l:%c"))
 '(package-selected-packages
   '(lsp-treemacs treemacs treemacs-magit treemacs-projectile flycheck-rtags rtags flycheck-clang-analyzer systemd quelpa basic-mode direnv darktooth-theme kanagawa-themes kuronami-theme dts-mode ivy-hydra flx counsel ivy swiper "ivy" clang-format backup-walker gnu-elpa-keyring-update sr-speedbar xcscope lsp-ui bats-mode buffer-move pdf-tools timu-rouge-theme company-auctex cdlatex auctex graphviz-dot-mode bison-mode c-eldoc project xref lsp-mode flycheck-clang-tidy material-theme speed-type scala-mode graphql-mode yaml-mode python-black company-jedi tern-auto-complete tern darkroom kotlin-mode spacemacs-theme spacegray-theme jedi python-environment auto-complete js2-mode go-mode slime-company slime solarized-theme gruvbox-theme company-c-headers company sublimity writeroom-mode csv-mode sphinx-doc sphinx-mode flycheck-pycheckers pyvenv ein color-theme-sanityinc-tomorrow web-beautify lua-mode smex web-mode simp railscasts-theme php-mode pandoc-mode markdown-mode magit less-css-mode flycheck-pos-tip))
 '(safe-local-variable-values
   '((c-offsets-alist
      (arglist-close . c-lineup-arglist-tabs-only)
      (arglist-cont-nonempty c-lineup-gcc-asm-reg c-lineup-arglist-tabs-only)
      (arglist-intro . +)
      (brace-list-intro . +)
      (c . c-lineup-C-comments)
      (case-label . 0)
      (comment-intro . c-lineup-comment)
      (cpp-define-intro . +)
      (cpp-macro . -1000)
      (cpp-macro-cont . +)
      (defun-block-intro . +)
      (else-clause . 0)
      (func-decl-cont . +)
      (inclass . +)
      (inher-cont . c-lineup-multi-inher)
      (knr-argdecl-intro . 0)
      (label . -1000)
      (statement . 0)
      (statement-block-intro . +)
      (statement-case-intro . +)
      (statement-cont . +)
      (substatement . +))
     (c-label-minimum-indentation . 0)
     (current-c-project-directory . "/home/rick/Repositories/linux")
     (current-c-project-directory . "/data/Projects/bootlin-course/linux")
     (current-c-project-directory "/data/Projects/bootlin-course/linux")
     (markdown-command . "pandoc --metadata title=cstdlib
                          --from=markdown+grid_tables
                          --toc --highlight-style=kate
                          --to=html --standalone
                          --css=cstdlib.css
                          --self-contained --")))
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-header-face-1 ((t (:inherit markdown-bold :foreground "SpringGreen1" :height 1.0))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face-1 :foreground "SeaGreen4" :height 1.0))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face-1 :foreground "PaleGreen3" :height 1.0))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face-1 :foreground "DarkSeaGreen2" :height 1.0))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face-1 :foreground "DarkSeaGreen3" :height 1.0))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face-1 :foreground "DarkSeaGreen4" :height 1.0)))))
