;;; setup.el --- emacs setup

;;; Commentary:
;; 


;;; Code:

;;; real init.el begins here

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
  (require 'fs-org)
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

(when (file-exists-p custom-file)
  (load custom-file))
;;; init.el ends here


(provide 'setup)

;;; setup.el ends here
