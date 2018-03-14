;; note:
;; which ocamlmerlin should spit out:
;; /home/`user_name`/.nvm/versions/node/`some-version`/bin/ocamlmerlin
;; and in `M-x ielm` evaluating the following:
;; (expand-file-name "emacs/site-lisp" (car (process-lines "opam" "config" "var" "share")))
;; should spit out:
;; "/home/`user_name`/.opam/`some-version`/share/emacs/site-lisp"

;;; Commentary:
;; note:
;; which ocamlmerlin should spit out:
;; /home/`user_name`/.nvm/versions/node/`some-version`/bin/ocamlmerlin
;; and in `M-x ielm` evaluating the following:
;; (expand-file-name "emacs/site-lisp" (car (process-lines "opam" "config" "var" "share")))
;; should spit out:
;; "/home/`user_name`/.opam/`some-version`/share/emacs/site-lisp"
;; remember, C-h k is how you find out what a key-chord does

;; keybindings in this file:
;; M-<right>/M-<left> -> auto-highlight-symbol -> next/previous occurrence
;; C-c b --------------> helm ------------------> helm-filtered-bookmarks
;; C-x C-f ------------> helm ------------------> helm-find-files
;; C-x f --------------> helm ------------------> helm-find-files
;; C-x b --------------> helm ------------------> helm-mini
;; C-x C-b ------------> helm ------------------> helm-buffers-list
;; C-h f --------------> helm ------------------> helm-apropos
;; C-h r --------------> helm ------------------> helm-info-emacs
;; C-h C-l ------------> helm ------------------> helm-locate-library
;; C-c f --------------> helm ------------------> helm-recentf
;; C-h SPC ------------> helm ------------------> helm-all-mark-rings
;; C-c h x ------------> helm ------------------> helm-register
;; M-y ----------------> helm ------------------> helm-show-kill-ring
;; M-x ----------------> helm ------------------> helm-M-x
;; C-c C-l ------------> helm ------------------> helm-minibuffer-history
;; C-s ----------------> helm-swoop ------------> helm-swoop-without-pre-input
;; C-r ----------------> helm-swoop ------------> helm-previous-line
;; C-s ----------------> helm-swoop ------------> helm-next-line
;; M-. ----------------> merlin ----------------> merlin-locate
;; M-, ----------------> merlin ----------------> merlin-pop-stack
;; C-c C-o ------------> merlin ----------------> merlin-occurrences
;; C-c C-j -> merlin :: merlin-jump
;; C-c i -> merlin :: merlin-locate-ident
;; C-c C-e -> merlin :: merlin-iedit-occurrences))

;; main>------------------------------------------------------------------------
(eval-when-compile
  (require 'cl))

(electric-pair-mode t)

(set-face-attribute 'region nil :background "green")

(fset 'yes-or-no-p 'y-or-n-p)

;; make elisp bearable
(if (fboundp 'paren-set-mode)
    (paren-set-mode 'sexp)
  (defvar show-paren-style)
  (setq show-paren-style 'expression)
  (show-paren-mode t))
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)

;; use utf-8
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq buffer-file-coding-system 'utf-8)

;; two performance speedups
;; https://emacs.stackexchange.com/questions/28736/emacs-pointcursor-movement-lag/28746
(setq auto-window-vscroll nil)
;; https://www.reddit.com/r/emacs/comments/2dgy52/how_to_stop_emacs_automatically_recentering_the/
(setq scroll-step 1)

(define-globalized-minor-mode global-goto-address-mode goto-address-mode goto-address-mode)
(global-goto-address-mode)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq network-security-level 'high)

(global-font-lock-mode 1)

;; this turns certain symbols into fonts (lambda -> λ)
(global-prettify-symbols-mode 1)

(setq frame-title-format '(buffer-file-name "%f" "%b"))

(setq ring-bell-function 'ignore)
;; <main------------------------------------------------------------------------

;; packages>--------------------------------------------------------------------
(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("MELPA" . "https://melpa.org/packages/")
                         ("MELPA Stable" . "http://stable.melpa.org/packages/")))
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(if (require 'quelpa nil t)
    (quelpa-self-upgrade)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.github.com/quelpa/quelpa/master/bootstrap.el")
    (eval-buffer)))
;; <packages--------------------------------------------------------------------

;; ;; path>------------------------------------------------------------------------
(if (string-equal system-type "windows-nt")
    (progn
      (setenv "PATH" (concat
		      "C:\\Program Files\\Git\\usr\\bin" ";" ;; Unix tools
		      (getenv "PATH"))))
  (progn
    (use-package exec-path-from-shell
      :ensure t
      :config
      (when (memq window-system '(mac ns x))
	(exec-path-from-shell-initialize)))))
;; ;; <path------------------------------------------------------------------------

;; helm>------------------------------------------------------------------------
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (helm-popup-tip-mode 1)
  (helm-autoresize-mode t)
  (setq helm-autoresize-min-height 40)

  (setq helm-M-x-fuzzy-match t)
  (setq helm-buffers-fuzzy-matching t)
  (setq helm-recentf-fuzzy-match t)
  (setq helm-lisp-fuzzy-completion t)
  
  (require 'helm-eshell)
  (add-hook 'eshell-mode-hook
	    #'(lambda ()
		(define-key eshell-mode-map (kbd "M-l")  'helm-eshell-history)))
  

  ;; (global-set-key (kbd "C-s") #'helm-occur) ; using helm-swoop now
  (global-set-key (kbd "C-c b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-c C-b") #'helm-filtered-bookmarks) ; because I am an idiot
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-x b") #'helm-mini)
  (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
  (global-set-key (kbd "C-h f") 'helm-apropos)
  (global-set-key (kbd "C-h r") 'helm-info-emacs)
  (global-set-key (kbd "C-h C-l") 'helm-locate-library)
  (global-set-key (kbd "C-c f") 'helm-recentf)
  (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
  (global-set-key (kbd "C-c h x") 'helm-register)
  
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "M-x") #'helm-M-x)

  (define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)
  
  (define-key helm-map [backspace] #'backward-kill-word))

(use-package helm-swoop
  :ensure t
  :config
  (global-set-key (kbd "C-s") 'helm-swoop-without-pre-input)
  (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
  (define-key helm-swoop-map (kbd "C-s") 'helm-next-line))
;; <helm------------------------------------------------------------------------

;; ocaml>-----------------------------------------------------------------------
(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))))

(use-package ocp-indent)

(use-package tuareg
  :ensure t
  :config
  (add-hook 'before-save-hook 'ocp-indent-buffer nil t)
  (setq auto-mode-alist 
	(append '(("\\.ml[ily]?$" . tuareg-mode)
		  ("\\.topml$" . tuareg-mode))
		auto-mode-alist)))
;; <ocaml-----------------------------------------------------------------------

;; reasonml>--------------------------------------------------------------------
(defun shell-cmd (cmd)
  "Returns the stdout output of a shell command or nil if the command returned
   an error"
  (car (ignore-errors (apply 'process-lines (split-string cmd)))))

(quelpa '(reason-mode :repo "reasonml-editor/reason-mode" :fetcher github :stable t))
(use-package reason-mode
  :config
  (let* ((refmt-bin (shell-cmd "which refmt")))
    (when refmt-bin
      (setq refmt-command refmt-bin)))
  (add-hook
   'reason-mode-hook
   (lambda ()
     (add-hook 'before-save-hook 'refmt-before-save nil t)
     (setq-local merlin-command (shell-cmd "which ocamlmerlin"))
     (merlin-mode))))
;; <reasonml--------------------------------------------------------------------

;; merlin>----------------------------------------------------------------------
(use-package merlin
  :custom
  (merlin-command 'opam)
  (merlin-completion-with-doc t)
  (company-quickhelp-mode t)
  :config
  (autoload 'merlin-mode "merlin" nil t nil)
  :bind (:map merlin-mode-map
              ("M-." . merlin-locate)
              ("M-," . merlin-pop-stack)
              ("C-c C-o" . merlin-occurrences)
              ("C-c C-j" . merlin-jump)
              ("C-c i" . merlin-locate-ident)
              ("C-c C-e" . merlin-iedit-occurrences))
  :hook
  ;; Start merlin on ml files
  (reason-mode . merlin-mode)
  (tuareg-mode . merlin-mode)
  (caml-mode-hook . merlin-mode))

;; <merlin----------------------------------------------------------------------

;; utop>------------------------------------------------------------------------


(defun reason/rtop-prompt ()
  "The rtop prompt function."
  (let ((prompt (format "rtop[%d]> " utop-command-number)))
    (add-text-properties 0 (length prompt) '(face utop-prompt) prompt)
    prompt))

(use-package utop
  :config
  (autoload 'utop "utop" "Toplevel for OCaml" t)
  (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
  (defun utop-opam-utop () (progn
			     (setq-local utop-command "opam config exec -- utop -emacs")
			     utop-minor-mode))
  (defun utop-reason-cli-rtop () (progn
				     (setq-local utop-command (concat (shell-cmd "which rtop") " -emacs"))
				     (setq-local utop-prompt 'reason/rtop-prompt)
				     utop-minor-mode))
  :hook
  (tuareg-mode . utop-opam-utop)
  (reason-mode . utop-reason-cli-rtop))

;; <utop------------------------------------------------------------------------

;; company>---------------------------------------------------------------------

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0))

(use-package company-quickhelp
  :ensure t
  :config
  (company-quickhelp-mode 1)
  (define-key company-active-map (kbd "C-c h") #'company-quickhelp-manual-begin))

;; <company---------------------------------------------------------------------

;; flycheck>--------------------------------------------------------------------

;; someday these will play nicely with both reasonml and ocaml...

(use-package flycheck
  :ensure t
  :config
  (global-flycheck-mode))

(use-package flycheck-popup-tip
  :ensure t
  :config
  (flycheck-popup-tip-mode))

(use-package flycheck-ocaml
  :ensure t
  :config
  (add-hook 'tuareg-mode-hook
	    (lambda ()
	      ;; disable Merlin's own error checking
	      (setq-local merlin-error-after-save nil)    
	      ;; enable Flycheck checker
	      (flycheck-ocaml-setup))))


;; <flycheck--------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (flycheck-ocaml flycheck-popup-tip flycheck company-quickhelp company reason-mode tuareg helm-swoop helm exec-path-from-shell quelpa package-build use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
