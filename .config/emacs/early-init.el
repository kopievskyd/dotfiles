;;; early-init.el -*- lexical-binding: t -*-

;;; Performance
(setq gc-cons-threshold (* 128 1024 1024)) ; increase GC threshold
(setq read-process-output-max (* 1024 1024)) ; larger subprocess reads

;;; Appearance
(menu-bar-mode -1) ; hide menu bar
(tool-bar-mode -1) ; hide tool bar
(scroll-bar-mode -1) ; hide scroll bar
(context-menu-mode 1) ; enable context menu
(pixel-scroll-mode 1) ; enable pixel-based scrolling
(add-to-list 'default-frame-alist '(font . "SF Mono-13")) ; font family and size
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t)) ; enable transparent title bar
(set-face-attribute 'fringe nil :background 'unspecified) ; blend fringe with background

;;; Directories
(defvar cache-dir
  (expand-file-name "emacs/"
                    (or (getenv "XDG_CACHE_HOME")
                        (expand-file-name "~/.cache"))))
(defvar data-dir
  (expand-file-name "emacs/"
                    (or (getenv "XDG_DATA_HOME")
                        (expand-file-name "~/.local/share"))))
(defvar state-dir
  (expand-file-name "emacs/"
                    (or (getenv "XDG_STATE_HOME")
                        (expand-file-name "~/.local/state"))))

;; Ensure cache, data and state directories exist
(dolist (dir (list cache-dir data-dir state-dir))
  (make-directory dir t))

;;; Packages
(setq package-user-dir (expand-file-name "elpa/" data-dir)) ; keep packages in data dir

;; Package sources
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

;;; Native compilation
;; Keep eln cache in cache directory
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache (expand-file-name "eln/" cache-dir)))
(setenv "MACOSX_DEPLOYMENT_TARGET" "27.0") ; pin macOS target
(setq native-comp-async-env-modifier-form '(require 'json)) ; load json in async process

;;; Frame state
(defvar frame-state (expand-file-name "frame-state.eld" state-dir)) ; frame state file

(defun save-frame-state ()
  (when (display-graphic-p)
    (with-temp-file frame-state
      (prin1 `((left . ,(frame-parameter nil 'left))
               (top . ,(frame-parameter nil 'top))
               (width . (text-pixels . ,(frame-text-width)))
               (height . (text-pixels . ,(frame-text-height))))
             (current-buffer)))))

(defun restore-frame-state ()
  (when (file-readable-p frame-state)
    (with-temp-buffer
      (insert-file-contents frame-state)
      (dolist (parameter (read (current-buffer)))
        (add-to-list 'default-frame-alist parameter)))))

(setq frame-resize-pixelwise t) ; resize frame by pixels
(add-hook 'kill-emacs-hook #'save-frame-state) ; save frame state on exit
(when initial-window-system (restore-frame-state)) ; restore frame state at startup

;;; Welcome screen
(defun welcome-buffer (&optional window)
  (let* ((buffer (get-buffer-create "*Welcome*"))
         (window (or window (selected-window)))
         (width (window-body-width window))
         (height (window-body-height window))
         (padding (max 0 (/ (- height 3) 2)))
         (inhibit-read-only t))
    (with-current-buffer buffer
      (erase-buffer)
      (setq-local
       fill-column width
       cursor-type nil
       vertical-scroll-bar nil
       horizontal-scroll-bar nil
       mode-line-format nil
       buffer-read-only t)
      (insert-char ?\n padding)
      (let ((start (point)))
        (insert
         (propertize "GNU Emacs" 'face 'bold)
         (format " version %d.%d\n" emacs-major-version emacs-minor-version)
         (propertize "A free/libre editor" 'face 'shadow))
        (center-region start (point)))
      (goto-char (point-min)))
    buffer))

(defun welcome-buffer--redraw (frame)
  (when-let* ((window (get-buffer-window "*Welcome*" frame)))
    (welcome-buffer window)))

(defun welcome-buffer--cleanup (_frame)
  (when-let* ((buffer (get-buffer "*Welcome*")))
    (unless (get-buffer-window buffer t)
      (kill-buffer buffer))))

(setq initial-buffer-choice #'welcome-buffer) ; display welcome buffer at startup
(add-hook 'window-size-change-functions #'welcome-buffer--redraw) ; redraw welcome buffer on window resize
(add-hook 'window-buffer-change-functions #'welcome-buffer--cleanup) ; auto-kill welcome buffer
