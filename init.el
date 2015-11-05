;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa" . "http://melpa-stable.milkbox.net/packages/")))


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;;
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")




;; Window Size
(add-to-list 'default-frame-alist '(height . 45))
(add-to-list 'default-frame-alist '(width . 135))


;; Font
(set-face-attribute 'default nil :font  "Inconsolata" )
(set-face-attribute 'default t :font  "Inconsolata" )
(set-face-attribute 'default nil :height 150)


;; Scroll one line
(setq scroll-conservatively most-positive-fixnum)
(setq scroll-margin 10)

(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; Emmet
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indent-after-insert nil)))
(setq emmet-move-cursor-between-quotes t) ;; default


;; Multiple Cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Powerline 2.0
(require 'powerline)
(powerline-default-theme)

;; NeoTree
;; (add-to-list 'load-path "~/.emacs.d/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; FlyCheck
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Company Mode
(setq company-idle-delay 0)

;; Emmet
(global-set-key [C-tab] 'emmet-expand-line)

;; Projectile
(setq projectile-indexing-method 'native)
(setq projectile-enable-caching t)
(global-set-key (kbd "C-c f") 'projectile-find-file)

;; Nyan Mode
(require 'nyan-mode)
(nyan-mode 1)
(setq nyan-wavy-trail t)
(nyan-start-animation)

;; Expand Region
(global-set-key (kbd "C-x C-b") 'er/expand-region)

;; Guide Key
(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x" "C-c"))
(guide-key-mode 1)  ; Enable guide-key-mode

;; Tabs use Spaces
(setq-default indent-tabs-mode nil)

;; Fuzzy
(require 'auto-complete-config)
(ac-config-default)
(define-key ac-completing-map "\t" nil)
(define-key ac-completing-map [tab] nil)

;; Emacs Theme
(load-theme 'seti t)

;; Unindent by 2 Spaces(global-set-key (kbd "<S-tab>") 'un-indent-by-removing-4-spaces)
(global-set-key (kbd "<backtab>") 'un-indent-by-removing-4-spaces)
(defun un-indent-by-removing-4-spaces ()
  "remove 4 spaces from beginning of of line"
  (interactive)
  (save-excursion
    (save-match-data
      (beginning-of-line)
      ;; get rid of tabs at beginning of line
      (when (looking-at "^\\s-+")
        (untabify (match-beginning 0) (match-end 0)))
      (when (looking-at "^  ")
        (replace-match "")))))

(setq default-tab-width 2)
(global-auto-revert-mode t)
(setq css-indent-offset 2)
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

;; Highlight current line
(global-hl-line-mode 1)
(set-face-background 'hl-line "#4A5BBA")
(set-face-foreground 'highlight nil)


;; Highlight 80 column
(require 'fill-column-indicator)
(fci-mode 1)
;; (setq fci-rule-width 1)
(setq-default fill-column 80)
  (define-globalized-minor-mode global-fci-mode fci-mode
    (lambda ()
      (if (and
           (not (string-match "^\*.*\*$" (buffer-name)))
           (not (eq major-mode 'dired-mode)))
          (fci-mode 1))))
  (global-fci-mode 1)


;; Delete selection on type
(delete-selection-mode 1)

;; Yasnippet
(require 'yasnippet)
(yas-global-mode 1)

(global-set-key (kbd "\t") 'yas-expand)
