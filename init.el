;;; init.el --- Where all the magic begins
;;
;; This file loads Org-mode and then loads the rest of our Emacs initialization from Emacs lisp
;; embedded in literate Org-mode files.

;; Load up Org Mode and (now included) Org Babel for elisp embedded in Org Mode files

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

(setq package-archives
      '(("elpa" .         "https://tromey.com/elpa/")
        ("melpa" .        "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("gnu" .          "https://elpa.gnu.org/packages/")
        ("org" .          "https://orgmode.org/elpa/")))

(package-initialize)

(setq dotfiles-dir (file-name-directory (or (buffer-file-name) load-file-name)))

(let* ((started-at (current-time))
       (org-dir (expand-file-name
                 "lisp" (expand-file-name
                         "org" (expand-file-name
                                "src" dotfiles-dir))))
       (org-contrib-dir (expand-file-name
                         "lisp" (expand-file-name
                                 "contrib" (expand-file-name
                                            ".." org-dir))))
       (load-path (append (list org-dir org-contrib-dir)
                          (or load-path nil))))
  ;; load up Org-mode and Org-babel
  (require 'org-install)
  (require 'ob-tangle)
  (message "Loaded Org Mode (%.03fs)" (float-time (time-since started-at))))

;; Load up all literate org-mode files in this directory
(mapc (lambda (filename)
        (let ((started-at (current-time)))
          (org-babel-load-file filename)
          (message "Loaded Org Babel file: %s (%.03fs)"
                   filename (float-time (time-since started-at)))))
      (directory-files dotfiles-dir t "\\.org$"))

;;; init.el ends here
