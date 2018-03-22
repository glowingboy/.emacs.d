;;; init.el --- fs emacs init.el

;;; Commentary:
;; run Emacs with arg --fs-init when first time for dependencies setup
;; 

;;; Code:

;; Setup emacs dependencies

;; run sudo command

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(defun fs-sudo-shell-command (cmd)
  "Run sudo command.
Argument CMD shell cmd"
  (interactive "scmd:")
  (shell-command (concat "echo "
			 (read-passwd "sudo password:")
			 " | sudo -S " cmd)
		 "fs-sudo-shell-command-output"))

(defun fs-init-setup ()
  "Init setup."
  (fs-sudo-shell-command
   (substitute-in-file-name "$HOME/.emacs.d/fs/setup.sh")))

;; removed because this hook function will be called after init.el done,
;; and this is not what I want
;; (setq command-switch-alist
;;       '(("-fs-init" . fs-init-setup)))

(defconst fs-init-fs-option-alist
  '(
    ("--fs-init" fs-init-setup)
    )
  "My custom command line args option.")


(defun fs-init-fs-option ()
  "Processing --fs-* custom options."
  (let ((idx 0)
	(lstLen (safe-length fs-init-fs-option-alist)))
    ;; iterate through fs-init-fs-option-alist
    (while (< idx lstLen)
      (let* ((fs-opt (nth idx fs-init-fs-option-alist))
	     (fs-opt-name (car fs-opt))
	     (fs-opt-cb (car-safe (cdr-safe fs-opt))))
	(when (and fs-opt-cb (member fs-opt-name command-line-args))
	    ;; if callback is not nill and a opt is given
	      ;; delete from command-line-args
	      (delete fs-opt-name command-line-args)
	      (funcall fs-opt-cb)))
      (setq idx (1+ idx)))))

(fs-init-fs-option)

;;; normal init.el begins here
(add-to-list 'load-path
	     (substitute-in-file-name "$HOME/.emacs.d/fs"))

(let (
      ;; optimizing for setup
      ;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
      (file-name-handler-alist nil)
      (gc-cons-threshold most-positive-fixnum)
      )
  (require 'fs-package)
  (require 'fs-misc)
  (require 'fs-company)
  (require 'fs-cc-mode)
  (require 'fs-lua)
  (require 'fs-glsl)
  )

;;;; optimization

;; GC threshold
(defconst fs-init-gc-cons-threshold-default
  gc-cons-threshold
  "Default GC threashold value.")

;; see http://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold
(defun fs-init-gc-cons-threshold-tweaks (ismax)
  "Argument ISMAX if going to set gc-cons-threashold to max."
  (if ismax
      (setq gc-cons-threshold most-positive-fixnum)
    (setq gc-cons-threshold fs-init-gc-cons-threshold-default)
    ))

(add-hook 'minibuffer-setup-hook
	  (lambda ()
	    (fs-init-gc-cons-threshold-tweaks t)))

(add-hook 'minibuffer-exit-hook
	  (lambda ()
	    (fs-init-gc-cons-threshold-tweaks nil)))

;;(emacs-init-time)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company-glsl glsl-mode lua-mode company-c-headers company flycheck rainbow-delimiters ace-window smartparens markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "white"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "white"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "blue"))))
 '(rainbow-delimiters-mismatched-face ((t (:foreground "red"))))
 '(rainbow-delimiters-unmatched-face ((t (:foreground "red")))))
