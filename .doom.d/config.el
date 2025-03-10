;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-laserwave)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type :relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! org
  (setq org-roam-directory "~/org/notes/"
        org-roam-graph-viewer "/snap/bin/vivaldi.vivaldi-stable" ; not working, files opening in /tmp, maybe snap won't let vivaldi see it?
        org-agenda-files '("~/org/agenda.org" "~/org/todo.org" "~/org/projects.org")
        org-fancy-priorities-mode 1))
(after! org-fancy-priorities
 (setq
   org-fancy-priorities-list '("[1]" "[2]" "[3]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   ;; org-fancy-priorities-list '("🟥" "🟧" "🟨")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411))
(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
          (tags "customtag"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Tasks marked with customtag:")))

          (agenda "")
          (alltodo "")))))
;; Start bringing in my old conf here:
