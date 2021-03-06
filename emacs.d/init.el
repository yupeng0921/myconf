;; global settings
(setq x-select-enable-clipboard t)      ; support copy and paste between emacs and X window
(column-number-mode t)                  ; show column
(show-paren-mode t)                     ; show parenthese
(setq show-paren-style 'parenthesis)    ; when sho parenthese, cursor do not jump
(fset 'yes-or-no-p 'y-or-n-p)           ; use y/n indicate yes/no
(setq scroll-margin 0 scroll-step 0 scroll-conservatively most-positive-fixnum) ; roll smootly
(setq next-screen-context-lines 5)  ; let scroll up and scroll down show more context
(setq inhibit-startup-message t)                   ; remove emacs start picture
(setq gnus-inhibit-startup-message t)              ; remove gnu start picture
(global-auto-revert-mode 1)             ; re-load file if the file is modified by other program
(global-eldoc-mode -1)
(delete-selection-mode 1)               ; select region can be kill when type <del> or insert character
(put 'scroll-left 'disabled nil)        ; agree scroll left
(put 'scroll-right 'disabled nil)       ; agree scroll right
(setq default-tab-width 4)              ; tab width equal to 4 blank
(setq frame-title-format "%f")          ; display file name on frame title
(setq resize-mini-windows t)            ; minibuffer can shrink automatically
(tool-bar-mode -1)                     ; disable tool bar, must be -1, nil will caust toggle
(scroll-bar-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode 0)                  ; cursor blinking disable
(setq default-truncate-lines t)         ; do not fold line default
(electric-pair-mode 1)
(windmove-default-keybindings)          ; use shift + array to move in windows
(put 'dired-find-alternate-file 'disabled nil)      ; can use 'a' command in dir mode
(setq-default indent-tabs-mode nil)
(setq-default auto-save-default nil)
(setq vc-handled-backends nil)                      ; do not use version control, it make emacs slow
(setq frame-title-format "%f")                              ; show file path in title bar
(setq backup-directory-alist '(("." . "~/.emacs.d/.emacsfilebak"))) ; set the default backup file directory
(setq bookmark-default-file "~/.emacs.d/.emacs.bmk")        ; bookmark default save directory
;; let emacs doesn't ask any question when kill buffer or kill session
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(remove-hook 'kill-emacs-query-functions 'server-kill-emacs-query-function)
(setq compilation-scroll-output t)
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "")
(setq custom-file "~/.emacs.d/custom.el")

;; enable buildin packages
(require 'hl-line)                      ; high light current line
(global-set-key (kbd "C-c x") 'hl-line-mode)
(defface yp-hl-face '((t (:background "#6a7758"))) ; Try also (:underline "Yellow")
  "Face to use for `hl-line-face'." :group 'hl-line)
(setq hl-line-face 'yp-hl-face)

(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-after-kill-buffer-p t) ; rename after killing uniquified

;; set directory must before load ido, or it only save .ido.last
;; to that directory, but can not read when start up
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(require 'ido)
(ido-mode t)
(ido-everywhere 1)
(setq ido-auto-merge-work-directories-length -1)

(require 'cc-mode)

(setq c-default-style
      '((java-mode . "cc-mode") (c-mode . "linux")))
(c-set-offset 'arglist-cont-nonempty '+)
(c-set-offset 'label 0)

(add-hook 'c-mode-hook
          '(lambda ()
             (setq indent-tabs-mode t)))

(require 'sh-script)
(require 'asm-mode)

(hide-ifdef-mode 1)

;; configure external packages
(require 'package)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.milkbox.net/packages/") t)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
        (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; Declare packages
(setq my-packages
      '(yasnippet
        smartrep
        yaml-mode
        json-mode
        protobuf-mode
        go-mode
        jinja2-mode
        rust-mode
        highlight-symbol
        browse-kill-ring
        ggtags
        zenburn-theme
        company
        yafolding
        undo-tree
        grep-a-lot))

;; Iterate on packages and install missing ones
(dolist (pkg my-packages)
  (unless (package-installed-p pkg)
    (package-refresh-contents)
    (package-install pkg)))

(require 'yasnippet)
(yas-global-mode 1)

;; enable company mode
(add-hook 'after-init-hook 'global-company-mode)
(setq company-backends '(company-capf))
(setq company-idle-delay nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-preview ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common ((t (:inherit company-preview))))
 '(company-tooltip ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-common ((((type x)) (:inherit company-tooltip :weight bold)) (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection ((((type x)) (:inherit company-tooltip-selection :weight bold)) (t (:inherit company-tooltip-selection))))
 '(company-tooltip-selection ((t (:background "steelblue" :foreground "white")))))
(global-set-key (kbd "M-'") 'company-complete)

;; sequential command interface library
(require 'smartrep)

;; highlight symbol
(require 'highlight-symbol)
(smartrep-define-key
    global-map "C-c" '(("n" . (highlight-symbol-next))
                       ("p" . (highlight-symbol-prev))))
(global-set-key (kbd "C-c j") 'highlight-symbol-at-point)

(require 'browse-kill-ring)
(global-set-key (kbd "C-c k") 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

(require 'yafolding)
(define-globalized-minor-mode my-global-yafolding-mode yafolding-mode
  (lambda () (yafolding-mode 1)))
(my-global-yafolding-mode 1)
(global-set-key (kbd "<backtab>") 'yafolding-toggle-element)

(require 'undo-tree)
(global-undo-tree-mode)
(setq undo-tree-auto-save-history nil)

(require 'grep-a-lot)
(grep-a-lot-setup-keys)

(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))
(setq ggtags-highlight-tag nil)
(setq ggtags-enable-navigation-keys nil)

(require 'json-mode)
(add-to-list 'auto-mode-alist '("\\.json$" . json-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(require 'protobuf-mode)
(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))

(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

;; custom macroes and functions
(fset 'yp-select-bracket
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("\225 \216" 0 "%d")) arg)))

(defun yp-goto-next-line ()
  "document"
  (interactive)
  (end-of-line)
  (newline-and-indent))

(defun yp-goto-prev-line ()
  "document"
  (interactive)
  (beginning-of-line)
  (newline-and-indent)
  (beginning-of-line 0)
  (indent-according-to-mode))

(defun yp-scroll-up ()
  (interactive)
  (scroll-up 2))

(defun yp-scroll-down ()
  (interactive)
  (scroll-down 2))

(defun yp-scroll-left ()
  (interactive)
  (scroll-left 2))

(defun yp-scroll-right ()
  (interactive)
  (scroll-right 2))

(defun yp-copy (&optional arg)
  "switch action by whether mark is active"
  (interactive "P")
  (if mark-active
      (kill-ring-save (region-beginning) (region-end))
    (let ((beg (progn (back-to-indentation) (point)))
          (end (line-end-position arg)))
      (copy-region-as-kill beg end))))

(defun yp-kill (&optional arg)
  "switch action by whether mark is active"
  (interactive "P")
  (if mark-active
      (kill-region (region-beginning) (region-end))
    (kill-whole-line arg)))

(defun yp-mark-line (&optional arg)
  (interactive "P")
  (if (region-active-p)
      (progn
        (goto-char (line-end-position 2)))
    (progn
      (back-to-indentation)
      (set-mark (point))
      (goto-char (line-end-position))))
  (setq arg (if arg (prefix-numeric-value arg)
              (if (< (mark) (point)) -1 1)))
  (if (and arg (> arg 1))
      (progn
        (goto-char (line-end-position arg)))))

(defun yp-hif-toggle-block ()
  "toggle hide/show-ifdef-block --lgfang"
  (interactive)
  (require 'hideif)
  (let* ((top-bottom (hif-find-ifdef-block))
         (top (car top-bottom)))
    (push-mark)
    (goto-char top)
    (hif-end-of-line)
    (setq top (point))
    (if (hif-overlay-at top)
        (show-ifdef-block)
      (hide-ifdef-block))))

(defun hif-overlay-at (position)
  "An imitation of the one in hide-show --lgfang"
  (let ((overlays (overlays-at position))
        ov found)
    (while (and (not found) (setq ov (car overlays)))
      (setq found (eq (overlay-get ov 'invisible) 'hide-ifdef)
            overlays (cdr overlays)))
    found))

(defun yp-mark-symbol (arg)
  (interactive "P")
  (unless arg
    (setq arg 1))
  (skip-syntax-backward "_w")
  (set-mark (point))
  (forward-symbol arg))

(setq-default case-fold-search t)
(defun yp-case-sensitive-toggle ()
  (interactive)
  (if case-fold-search
    (progn
      (setq-default case-fold-search nil)
      (message "case sensitive TRUE"))
    (progn
      (setq-default case-fold-search t)
      (message "case sensitive FALSE"))))

;; key define
(global-set-key (kbd "M-i") 'yp-goto-next-line)
(global-set-key (kbd "M-u") 'yp-goto-prev-line)
(global-set-key (kbd "M-c") 'pop-to-mark-command)
(global-set-key (kbd "M-(") 'beginning-of-defun)
(global-set-key (kbd "M-&") '(lambda() (interactive) (beginning-of-defun -1)))
(global-set-key (kbd "M-)") 'end-of-defun)
(global-set-key (kbd "M-N") 'yp-scroll-up)
(global-set-key (kbd "M-P") 'yp-scroll-down)
(global-set-key (kbd "M-H") 'yp-scroll-right)
(global-set-key (kbd "M-L") 'yp-scroll-left)
(global-set-key (kbd "M-J") 'enlarge-window)
(global-set-key (kbd "M-K") 'enlarge-window-horizontally)
(global-set-key (kbd "C-x C-k i") 'insert-kbd-macro)
(global-set-key (kbd "M-C-y") 'yp-select-bracket)
(global-set-key (kbd "C-c z") 'toggle-truncate-lines)
(global-set-key (kbd "C-c a") 'linum-mode);;line number
(global-set-key (kbd "C-c v") 'view-mode)
(global-set-key (kbd "M-w") 'yp-copy)
(global-set-key (kbd "C-w") 'yp-kill)
(global-set-key (kbd "M-z") 'yp-mark-line)
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(global-set-key (kbd "M-s j") 'yp-case-sensitive-toggle)
(global-set-key (kbd "M-s r") 'rgrep)
(global-set-key (kbd "M-s l") 'lgrep)
(global-set-key (kbd "C-c C-q") 'yp-hif-toggle-block)
(global-set-key (kbd "C-c o") 'yp-mark-symbol)

(defun yp-hexl-mode-init ()
  (define-key hexl-mode-map (kbd "M-i") 'hexl-insert-hex-string))
(add-hook 'hexl-mode-hook 'yp-hexl-mode-init)

(defun yp-shell-insert ()
  (interactive)
  (executable-set-magic "/bin/bash\n")
  (goto-char (point-max)))

(defun yp-awk-insert ()
  (interactive)
  (executable-set-magic "/usr/bin/awk -f\n")
  (goto-char (point-max)))

(defun yp-python-insert ()
  (interactive)
  (executable-set-magic "/usr/bin/env python\n")
  (goto-char (point-max)))

(define-auto-insert "\\.sh$" 'yp-shell-insert)
(define-auto-insert "\\.awk$" 'yp-awk-insert)
(define-auto-insert "\\.py$" 'yp-python-insert)

(require 'autoinsert)
(auto-insert-mode)  ;;; Adds hook to find-files-hook
(setq auto-insert-query nil) ;;; If you don't want to be prompted before insertion

;; config org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock)  ; must enable it, or plain list can nor work correct
; add DOING and CANCEL state in todo function
(setq org-todo-keywords
      '((sequence "TODO(t!)" "DOING(i!)" "PENDING(p!)" "|" "DONE(d!)" "CANCELED(c!)")))

(add-to-list 'auto-mode-alist '("\\.dra\\'" . text-mode)) ; my draft file
(add-to-list 'auto-mode-alist '(".*config$" . conf-mode))

(autoload 'systemtap-mode "systemtap-mode")
(add-to-list 'auto-mode-alist '("\\.stp$" . systemtap-mode))

;; (autoload 'protobuf-mode "protobuf-mode")
(add-to-list 'auto-mode-alist '("\\.proto" . protobuf-mode))

(when window-system
  (load-theme 'zenburn t)
  (desktop-save-mode 1)
  )
