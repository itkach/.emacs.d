;; Do not show the startup screen.
(setq inhibit-startup-message t)

(fset 'yes-or-no-p 'y-or-n-p)                    ;replace y-e-s by y

(when (window-system)
  (set-frame-font "Fira Code"))

(setq-default frame-title-format '("%f"))

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Highlight current line.
(global-hl-line-mode t)

(show-paren-mode 1)



(global-set-key [f5] 'refresh-file)
(global-set-key [f6] 'sort-lines)
(global-set-key [f8] 'linum-mode)

;; because Mac
(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end] 'move-end-of-line)

;; Copy-Cut-Paste from clipboard with Super-C Super-X Super-V
(global-set-key (kbd "s-x") 'clipboard-kill-region) ;;cut
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save) ;;copy
(global-set-key (kbd "s-v") 'clipboard-yank) ;;paste

(global-set-key (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "M-<down>") 'forward-paragraph)


(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file "~/.emacs.d/custom-file.el")

;; Assuming that the code in custom-file is execute before the code
;; ahead of this line is not a safe assumption. So load this file
;; proactively.
(load custom-file 'noerror)

(setq auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
(column-number-mode t)
(delete-selection-mode t)

;;no tabs
(setq-default indent-tabs-mode nil)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Require and initialize `package`.
(require 'package)
(package-initialize)

;; Add `melpa` to `package-archives`.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;(require 'use-package-ensure)
;(setq use-package-always-ensure t)

;; Additional packages and their configurations

(use-package delight)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :config (doom-modeline-mode 1)
  (setq doom-modeline-buffer-file-name-style 'truncate-except-project))

(use-package iedit
  :bind ("C-c ;" . iedit-mode))

(use-package company
  ;; Navigate in completion minibuffer with `C-n` and `C-p`.
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  ;; Provide instant autocompletion.
  (setq company-idle-delay 0.3)

  ;; Use company mode everywhere.
  (global-company-mode t))

(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'character)
  ;; Indent character samples: | ┆ ┊
  (setq highlight-indent-guides-character ?\|)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;; Display possible completions at all places
(use-package ido-completing-read+
  :config
  ;; This enables ido in all contexts where it could be useful, not just
  ;; for selecting buffer and file names
  (ido-mode t)
  (ido-everywhere t)
  ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
  (setq ido-enable-flex-matching t)
  (setq ido-use-filename-at-point nil)
  ;; Includes buffer names of recently opened files, even if they're not open now.
  (setq ido-use-virtual-buffers t)
  :diminish nil)

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Git integration for Emacs
(use-package magit
  :bind ("C-x g" . magit))

(use-package ag
  :bind ("C-o" . ag))

(use-package goto-last-change
  :bind ("C-q" . goto-last-change-with-auto-marks))

(use-package fill-column-indicator
  :config
  (add-hook 'prog-mode-hook 'fci-mode)
  (add-hook 'markdown-mode 'fci-mode))

(use-package markdown-mode
  :config
  (set-fill-column 80)
  (fci-mode 1))

(use-package dockerfile-mode)
(use-package yaml-mode)
(use-package thrift)
(use-package json-mode)
(use-package pyvenv)

(use-package smartparens
  :demand t
  :delight smartparens-mode
  :bind (:map smartparens-mode-map
              ("H-z" . sp-kill-symbol)
              ("C-)" . sp-forward-slurp-sexp)
              ("C-}" . sp-forward-barf-sexp)
              ("C-(" . sp-backward-slurp-sexp)
              ("C-{" . sp-backward-barf-sexp))
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (sp-use-smartparens-bindings)))


(use-package js2-mode :ensure t :defer 20
  :mode
  (("\\.js\\'" . js2-mode))
  :custom
  (js2-include-node-externs t)
  (js2-global-externs '("customElements"))
  (js2-highlight-level 3)
  (js2r-prefer-let-over-var t)
  (js2r-prefered-quote-type 2)
  (js-indent-align-list-continuation t)
  (global-auto-highlight-symbol-mode t)
  :config
  (setq js-indent-level 2)
  ;; patch in basic private field support
  (advice-add #'js2-identifier-start-p
            :after-until
            (lambda (c) (eq c ?#)))
  (add-hook 'js2-mode-hook #'setup-tide-mode))


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  ;;(company-mode +1)
  )

(use-package typescript-mode
  :init
  (setq typescript-indent-level 2)
  :bind
  (:map typescript-mode-map
   ("C-i" . company-indent-or-complete-common)
   ("C-M-i" . company-indent-or-complete-common)))

(use-package tide
  :after typescript-mode
  :hook ((before-save . tide-format-before-save)
         (typescript-mode . setup-tide-mode)))


(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-indentation nil)
  (when (string-equal "tsx" (file-name-extension buffer-file-name))
    (setup-tide-mode))
  (when (string-equal "jsx" (file-name-extension buffer-file-name))
    (setup-tide-mode)))

(use-package web-mode
  :init
  (add-hook 'web-mode-hook #'my-web-mode-hook)
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode)))

(use-package rainbow-mode
  :delight
  :hook prog-mode)

(use-package flycheck
  :init (global-flycheck-mode))

(use-package prettier-js
  :config
    (add-hook 'web-mode-hook 'prettier-js-mode)
    (add-hook 'typescript-mode-hook 'prettier-js-mode)
    (add-hook 'js2-mode-hook 'prettier-js-mode)
    (add-hook 'js-mode-hook 'prettier-js-mode)
    (add-hook 'rjsx-mode-hook 'prettier-js-mode))

(defun refresh-file ()
  "Re-read file from disk."
  (interactive)
  (revert-buffer t t t)
)

(global-set-key [f5] 'refresh-file)
(global-set-key [f6] 'sort-lines)
(global-set-key [f8] 'linum-mode)

;; because Mac
(global-set-key [home] 'move-beginning-of-line)
(global-set-key [end] 'move-end-of-line)

;; Copy-Cut-Paste from clipboard with Super-C Super-X Super-V
(global-set-key (kbd "s-x") 'clipboard-kill-region) ;;cut
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save) ;;copy
(global-set-key (kbd "s-v") 'clipboard-yank) ;;paste

(global-set-key (kbd "M-<up>") 'backward-paragraph)
(global-set-key (kbd "M-<down>") 'forward-paragraph)


(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

;; Do not use `init.el` for `custom-*` code - use `custom-file.el`.
(setq custom-file "~/.emacs.d/custom-file.el")

;; Assuming that the code in custom-file is execute before the code
;; ahead of this line is not a safe assumption. So load this file
;; proactively.
(load custom-file 'noerror)

(setq auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
(column-number-mode t)
(delete-selection-mode t)

;;no tabs
(setq-default indent-tabs-mode nil)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Add `melpa` to `package-archives`.
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))

;; Additional packages and their configurations

(use-package delight)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :config (doom-modeline-mode 1))

(use-package iedit
  :bind ("C-c ;" . iedit-mode))

(use-package company
  ;; Navigate in completion minibuffer with `C-n` and `C-p`.
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  ;; Provide instant autocompletion.
  (setq company-idle-delay 0.3)

  ;; Use company mode everywhere.
  (global-company-mode t))

(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'character)
  ;; Indent character samples: | ┆ ┊
  (setq highlight-indent-guides-character ?\|)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;; Display possible completions at all places
(use-package ido-completing-read+
  :config
  ;; This enables ido in all contexts where it could be useful, not just
  ;; for selecting buffer and file names
  (ido-mode t)
  (ido-everywhere t)
  ;; This allows partial matches, e.g. "uzh" will match "Ustad Zakir Hussain"
  (setq ido-enable-flex-matching t)
  (setq ido-use-filename-at-point nil)
  ;; Includes buffer names of recently opened files, even if they're not open now.
  (setq ido-use-virtual-buffers t)
  :diminish nil)

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; Git integration for Emacs
(use-package magit
  :bind ("C-x g" . magit))

(use-package ag
  :bind ("C-o" . ag))

(use-package goto-last-change
  :bind ("C-q" . goto-last-change-with-auto-marks))

(use-package fill-column-indicator
  :config
  (add-hook 'prog-mode-hook 'fci-mode)
  (add-hook 'markdown-mode 'fci-mode))

(use-package markdown-mode
  :config
  (set-fill-column 80)
  (fci-mode 1))

(use-package dockerfile-mode)
(use-package yaml-mode)
(use-package thrift)
(use-package json-mode)
(use-package pyvenv)

(use-package smartparens
  :demand t
  :delight smartparens-mode
  :bind (:map smartparens-mode-map
              ("H-z" . sp-kill-symbol)
              ("C-)" . sp-forward-slurp-sexp)
              ("C-}" . sp-forward-barf-sexp)
              ("C-(" . sp-backward-slurp-sexp)
              ("C-{" . sp-backward-barf-sexp))
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (sp-use-smartparens-bindings)))


(use-package js2-mode :ensure t :defer 20
  :mode
  (("\\.js\\'" . js2-mode))
  :custom
  (js2-include-node-externs t)
  (js2-global-externs '("customElements"))
  (js2-highlight-level 3)
  (js2r-prefer-let-over-var t)
  (js2r-prefered-quote-type 2)
  (js-indent-align-list-continuation t)
  (global-auto-highlight-symbol-mode t)
  :config
  (setq js-indent-level 2)
  ;; patch in basic private field support
  (advice-add #'js2-identifier-start-p
            :after-until
            (lambda (c) (eq c ?#)))
  (add-hook 'js2-mode-hook #'setup-tide-mode))


(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  ;;(company-mode +1)
  )

(use-package typescript-mode
  :init
  (setq typescript-indent-level 2)
  :bind
  (:map typescript-mode-map
   ("C-i" . company-indent-or-complete-common)
   ("C-M-i" . company-indent-or-complete-common)))

(use-package tide
  :after typescript-mode
  :hook ((before-save . tide-format-before-save)
         (typescript-mode . setup-tide-mode)))


(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-indentation nil)
  (when (string-equal "tsx" (file-name-extension buffer-file-name))
    (setup-tide-mode))
  (when (string-equal "jsx" (file-name-extension buffer-file-name))
    (setup-tide-mode)))

(use-package web-mode
  :init
  (add-hook 'web-mode-hook #'my-web-mode-hook)
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode)))

(use-package rainbow-mode
  :delight
  :hook prog-mode)

(use-package flycheck
  :init (global-flycheck-mode))

(use-package prettier-js
  :config
    (add-hook 'web-mode-hook 'prettier-js-mode)
    (add-hook 'typescript-mode-hook 'prettier-js-mode)
    (add-hook 'js2-mode-hook 'prettier-js-mode)
    (add-hook 'js-mode-hook 'prettier-js-mode)
    (add-hook 'rjsx-mode-hook 'prettier-js-mode))


(use-package lsp-mode
    :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
           (sh-mode . lsp)
           (yaml-mode . lsp)
           (dockerfile-mode . lsp)
           (haskel-mode . lsp)
           (python-mode . lsp)
            ;; if you want which-key integration
           (lsp-mode . lsp-enable-which-key-integration))
    :commands lsp
    :config
    (setq lsp-keymap-prefix "s-l")
    (lsp-register-custom-settings
     '(("pyls.plugins.pyls_mypy.enabled" t t)
       ("pyls.plugins.pyls_mypy.live_mode" nil t)))
    (setq lsp-haskell-process-path-hie "hie-wrapper"))

(use-package which-key
    :config
    (which-key-mode))

(use-package highlight-symbol
  :bind (("C-, " . highlight-symbol-prev)
         ("C-. " . highlight-symbol-next)
         ("M-p " . highlight-symbol-at-point))
  :config
  (add-hook 'prog-mode-hook 'highlight-symbol-mode))

(use-package subword
  :delight
  :config
  (add-hook 'prog-mode-hook 'subword-mode))

(use-package blacken
    :config
    (add-hook 'python-mode-hook 'blacken-mode))

(use-package py-isort
  :after python
  :config (setq py-isort-options '("-sl"))
  :hook ((python-mode . pyvenv-mode)
         (before-save . py-isort-before-save)))

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package haskell-mode
  :config
  (setq haskell-font-lock-symbols t)
  :hook ((haskell-mode . turn-on-haskell-doc-mode)
         (haskell-mode . turn-on-haskell-indent)
         (haskell-mode . interactive-haskell-mode)))

(use-package hideshow
  :bind ("C-'" . hs-toggle-hiding)
  :hook ((prog-mode . hs-minor-mode)))


(use-package restclient)


;; Taken from
;; http://sachachua.com/blog/2006/09/emacs-changing-the-font-size-on-the-fly/
(defun sacha/increase-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (ceiling (* 1.10
                                  (face-attribute 'default :height)))))
(defun sacha/decrease-font-size ()
  (interactive)
  (set-face-attribute 'default
                      nil
                      :height
                      (floor (* 0.9
                                  (face-attribute 'default :height)))))
(global-set-key (kbd "C-+") 'sacha/increase-font-size)
(global-set-key (kbd "C--") 'sacha/decrease-font-size)


(provide 'init)
;;; init.el ends here
