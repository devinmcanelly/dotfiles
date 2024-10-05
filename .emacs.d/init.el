
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/"))

      
      indent-tabs-mode nil
      python-indent-offset 4
      use-package-always-ensure t
      visible-bell t           
      history-length 25
      global-auto-revert-mode 1
      select-enable-clipboard t
      ;; inhibit-startup-message t  // after you finish reading the manual..
      ;; or customize the startup message.
      )
      
(menu-bar-mode 1)  ; Leave this one on if you're a beginner!
(tool-bar-mode 1)

(scroll-bar-mode -1)
(hl-line-mode 1)
(column-number-mode)
(global-display-line-numbers-mode 1)
(load-theme 'wombat)
(save-place-mode 1)
(savehist-mode 1)
(global-auto-revert-mode 1)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; Bind arrow keys to C-b(ackward), C-f(orward), C-n(ext), C-p(revious)
(global-set-key (kbd "<left>")  'backward-char)
(global-set-key (kbd "<right>") 'forward-char)
(global-set-key (kbd "<up>")    'previous-line)
(global-set-key (kbd "<down>")  'next-line)

(global-set-key (kbd "M-<left>")  'backward-word)
(global-set-key (kbd "M-<right>") 'forward-word)
(global-set-key (kbd "M-<Up>")    'backward-paragraph)
(global-set-key (kbd "M-<down>")  'forward-paragraph)

(global-set-key (kbd "<prior>") 'scroll-down-command)  ;; PgUp
(global-set-key (kbd "<next>")  'scroll-up-command)    ;; PgDn

;; Unbind the original keybindings
(global-unset-key (kbd "C-b"))  
(global-unset-key (kbd "C-f"))  
(global-unset-key (kbd "C-n"))  
(global-unset-key (kbd "C-p"))  
(global-unset-key (kbd "M-b"))  
(global-unset-key (kbd "M-f"))  
(global-unset-key (kbd "M-a"))  
(global-unset-key (kbd "M-e"))  
(global-unset-key (kbd "C-v")) 
(global-unset-key (kbd "M-v"))  

(setq custom-file (locate-user-emacs-file "custom-vars.el")) ; Using this, emacs can boot into my config
(load custom-file 'noerror 'nomessage)                       ; from a fresh-install

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(require 'package)

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

(unless (package-installed-p 'use-package) ;;; Pretty sure this bit installs package, then use-package? unless it's already installed? 
   (package-install 'use-package))

(require 'use-package)

;; General Packages: 
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package ivy-rich
  :init
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package lsp-mode
  :ensure t
  :hook ((python-mode . lsp)
         (go-mode . lsp)
         (html-mode . lsp)
         (css-mode . lsp)
         (js-mode . lsp)
         (json-mode . lsp)
         (yaml-mode . lsp)
         (markdown-mode . lsp))
  :commands lsp)


;; Python
(use-package pyvenv
  :ensure t)
 
;; Hook to activate venv and lsp-mode when I open a python file:
(defun activate-venv-in-dir (dir)
  "Activate virtualenv in the given DIR if .venv exists."
  (let ((venv-dir (locate-dominating-file dir ".venv")))
    (when venv-dir
      (pyvenv-activate (expand-file-name ".venv" venv-dir))))) ;; ngl this one was all Chat Gippity
      ;; locate-dominating-file returns the directory containing
      ;; .venv, expand-file-name appends .venv to venv-dir
(defun activate-venv-and-lsp ()
  "Activate virtualenv and LSP in Python buffers."
  (activate-venv-in-dir default-directory)
  (lsp))

(defun activate-venv-for-shell ()
  "Activate virtualenv when opening a shell in a directory with a .venv."
  (activate-venv-in-dir default-directory))

(add-hook 'python-mode-hook #'activate-venv-and-lsp)
(add-hook 'eshell-directory-change-hook #'activate-venv-for-shell)
(add-hook 'eshell-mode-hook #'activate-venv-for-shell)
(add-hook 'shell-mode-hook #'activate-venv-for-shell)
(setq python-shell-interpreter "ipython")
(setq python-shell-interpreter-args "--pylab")


;; Org Mode
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; Replace list hyphen with dot
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'org-indent)

(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Liberation Mono" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available


;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
