(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/"))
      aindent-tabs-mode nil
      python-indent-offset 4  
      use-package-always-ensure t
      visible-bell t           
      history-length 25
      global-auto-revert-mode 1
      select-enable-clipboard t
      org-agenda-window-setup 'current-window
      ;; inhibit-startup-message t  // after you finish reading the manual..
      ;; or customize the startup message.
      )
(require 'package)
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))
(unless (package-installed-p 'use-package) ;;; Pretty sure this bit installs package, then use-package? unless it's already installed? 
   (package-install 'use-package))
(require 'use-package)     

(setq custom-file (locate-user-emacs-file "custom-vars.el")) 
(load custom-file 'noerror 'nomessage)                       
(add-to-list 'default-frame-alist
	     '(font . "MesloLGSDZ Nerd Font Mono"))
(menu-bar-mode 1)  
(tool-bar-mode 1)
(scroll-bar-mode -1)
(hl-line-mode 1)
(column-number-mode)
(global-display-line-numbers-mode 1)
(use-package material-theme)
(load-theme 'material t)
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
(global-set-key (kbd "M-<up>")    'backward-paragraph)
(global-set-key (kbd "M-<down>")  'forward-paragraph)

(global-set-key (kbd "<prior>") 'scroll-down-command)  ;; PgUp
(global-set-key (kbd "<next>")  'scroll-up-command)    ;; PgDn

(global-set-key (kbd "C-c a") 'my/org-agenda-week)

;; Unbind the original keybindings for the movement commands
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



;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook)) ; not working for shell
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(require 'whitespace)
(setq whitespace-line-column 80)
(setq whitespace-style '(face lines-tail))
(defun enable-whitespace-mode ()
  (whitespace-mode 1))
(add-hook 'prog-mode-hook #'enable-whitespace-mode)

(use-package company)


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

;; (use-package forge) ;; Read the docs and setup a token

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
(setq python-shell-interpreter-args "--simple-prompt -i")
(setq python-shell-completion-native-enable t)
(setq python-shell-completion-native-output-timeout 0.5)

;; Org Mode Setup
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1)
  (setq evil-auto-indent nil))

(defun my/org-agenda-week ()
  (interactive)
  (org-agenda nil "a"))

(use-package org
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers 1
        org-agenda-start-with-log-mode t
        org-log-done 'time
        org-log-into-drawer t
        org-agenda-files '((directory-files-recursively "~/src/" "*.org"))
        org-habit-graph-column 60
        org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (require 'ox-md)
  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

          ("W" "Work Tasks" tags-todo "+work-email")

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files))))))))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "▶" "○" "●" "○" "●")))

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
  (set-face-attribute (car face) nil :font "MesloLGSDZ Nerd Font Mono" :weight 'regular :height (cdr face)))


;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
(put 'narrow-to-region 'disabled nil)



