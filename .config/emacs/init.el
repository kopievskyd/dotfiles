;;; init.el -*- lexical-binding: t -*-

;;; Startup
(setq inhibit-startup-echo-area-message "kopievskyd") ; hide echo area startup message
(setq initial-scratch-message nil) ; empty *scratch*

;;; Bell
(setq ring-bell-function #'ignore) ; no audible bell

;;; Scrolling
(setq scroll-margin 10) ; scroll offset
(setq scroll-conservatively 101) ; never recenter cursor

;;; Files and backups
(setq make-backup-files nil) ; no backup files
(setq auto-save-default nil) ; no auto-save files
(setq auto-save-list-file-prefix nil) ; no auto-save session lists

;;; Completion
(global-completion-preview-mode 1) ; show completion preview
(setq completion-styles '(flex basic)) ; fuzzy matching
(setq completion-show-help nil) ; hide help text

;;; Editing
(setq-default tab-width 4) ; tab size
(global-visual-line-mode 1) ; wrap at words
(electric-pair-mode 1) ; auto-close brackets
(delete-selection-mode 1) ; typing replaces selection
(global-auto-revert-mode 1) ; auto-revert buffers when files change

;; Insert blank lines above
(defun blank-line-above (count)
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (insert (make-string count ?\n))))

;; Insert blank lines below
(defun blank-line-below (count)
  (interactive "p")
  (save-excursion
    (end-of-line)
    (insert (make-string count ?\n))))

;;; Project
(setq project-list-file (expand-file-name "projects.eld" state-dir)) ; keep project list in state dir
(setq project-switch-commands #'project-find-file) ; find file after switching project

;;; Org mode
(setq org-directory "~/Documents/Notes/") ; org notes directory

;; Warm up org-mode
(run-with-idle-timer 0.1 nil
                     (lambda ()
                       (require 'org-tempo)
                       (with-temp-buffer (org-mode))))

;;; Packages
(setq use-package-always-ensure t) ; install missing packages

;; Packages to keep installed
(setq package-selected-packages
      '(gruvbox-theme
        undo-fu-session
        reverse-im
        olivetti
        vertico
        evil
        evil-org))

;; Color scheme
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox-dark-hard t)
  (set-face-background 'internal-border nil))

;; Persistent undo history
(use-package undo-fu-session
  :defer 0.1
  :init
  (setq undo-fu-session-directory
        (expand-file-name "undo/" state-dir))
  :config
  (undo-fu-session-global-mode))

;; Reverse mapping for non-default system layouts
(use-package reverse-im
  :defer 0.1
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :bind
  ("C-c r" . reverse-im-translate-word)
  :config
  ;; Hide loading message
  (let ((inhibit-message t)
        (message-log-max nil))
    (reverse-im-mode 1)))

;; Centered text
(use-package olivetti
  :hook
  (text-mode . olivetti-mode)
  :custom
  (olivetti-body-width 100))

;; Vertical completion
(use-package vertico
  :init
  (vertico-mode))

;; Vim emulation
(use-package evil
  :defer 0.1
  :init
  (setq evil-undo-system 'undo-redo) ; native undo/redo
  (setq evil-want-C-u-scroll t) ; C-u scrolls up
  (setq evil-respect-visual-line-mode t) ; j/k move by visual lines
  (setq evil-split-window-below t) ; :split and :new open below
  (setq evil-vsplit-window-right t) ; :vsplit and :vnew open right
  :config
  (evil-mode)
  (advice-add 'evil-ex-echo :override #'ignore) ; silence ex-command echo
  (evil-define-key 'normal global-map
    (kbd "<escape>") #'keyboard-quit
    (kbd "[ SPC") #'blank-line-above
    (kbd "] SPC") #'blank-line-below)
  ;; Hide cursor in *Welcome* buffer
  (when-let* ((buffer (get-buffer "*Welcome*")))
    (with-current-buffer buffer
      (setq-local evil-normal-state-cursor '(nil))
      (setq-local evil-motion-state-cursor '(nil))
      (setq-local evil-emacs-state-cursor '(nil))
      (setq-local cursor-type nil))))

;; Vim keybindings for org mode
(use-package evil-org
  :vc (:url "https://github.com/doomelpa/evil-org-mode")
  :after
  (evil org)
  :hook
  (org-mode . evil-org-mode))

;;; Keybindings
(define-key minibuffer-local-map (kbd "<escape>") #'abort-minibuffers) ; quit minibuffer with esc

;;; Language settings
;; Elisp
(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (setq-local indent-tabs-mode nil))) ; spaces in elisp

;; Org mode
(add-hook
 'org-mode-hook
 (lambda ()
   ;; Don't pair "<"
   (setq-local electric-pair-inhibit-predicate
               (lambda (char)
                 (or (eq char ?<)
                     (electric-pair-default-inhibit char))))))
