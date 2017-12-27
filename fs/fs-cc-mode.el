;;; fs-cc-mode.el --- c/c++ setup

;;; Commentary:
;; 

;;; Code:

(require 'cc-mode)

;; should added before cc-mode enabled
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; gcc system include path
;; g++ -E -x c++ - -v
(defconst fs-cc-mode-gcc-sys-include-path
  '("/usr/include/c++/5"
    "/usr/include/x86_64-linux-gnu/c++/5"
    "/usr/include/c++/5/backward"
    "/usr/lib/gcc/x86_64-linux-gnu/5/include"
    "/usr/local/include"
    "/usr/lib/gcc/x86_64-linux-gnu/5/include-fixed"
    "/usr/include/x86_64-linux-gnu"
    "/usr/include"
    ))

(defvar fs-cc-mode-addtional-sys-include-path
  '(
    "/usr/local"
    )
  "Addtional system include path.")

(defvar fs-cc-mode-additional-cxx-flags
  '(
    "-std=c++11"
    "-Wno-pragma-once-outside-header"	;remove warning: pragma once in main file
    )
  "Additional cxx flags.")

(defvar fs-cc-mode-compiler-flags
  nil
  "Final compiler flags.")

(require 'company-clang)
(require 'flycheck)
(defun fs-cc-mode-refresh-compiler-flags ()
  "Evaluate compiler flags from include path& cxx flags.
And then set into company-clang-arguments and flycheck-clang-args"
  (let* ((include-path-flags (copy-tree fs-cc-mode-addtional-sys-include-path))
	(idx 0)
	(lstLen (safe-length include-path-flags)))
    (while (< idx lstLen)
      (let ((path (nth idx include-path-flags)))
	(setcar (nthcdr idx include-path-flags)
		(concat "-I" path)))
      (setq idx (1+ idx)))
    (setq fs-cc-mode-compiler-flags (append fs-cc-mode-additional-cxx-flags include-path-flags))
    (setq company-clang-arguments fs-cc-mode-compiler-flags)
    (setq flycheck-clang-args fs-cc-mode-compiler-flags)))

(require 'company-c-headers)
(defun fs-cc-mode-refresh-company-c-headers-path ()
  "Set `company-c-headers' path."
  (setq company-c-headers-path-system
	(append fs-cc-mode-gcc-sys-include-path fs-cc-mode-addtional-sys-include-path)))

;; refresh
(defun fs-cc-mode-refresh ()
  "Refresh compiler flags and company-c-headers-path-*."
  (fs-cc-mode-refresh-compiler-flags)
  (fs-cc-mode-refresh-company-c-headers-path))

;; init
(require 'company-clang)
(require 'company-c-headers)
(defun fs-cc-mode-init ()
  "Init."
  ;; coding style
  (setq c-default-style "linux"
	c-basic-offset 4)

  ;; ff-find-other-file
  (local-set-key (kbd "C-x C-o") 'ff-find-other-file)
  
  ;; company setup
  (add-to-list 'company-backends 'company-c-headers)

  ;; flycheck setup
  (flycheck-select-checker 'c/c++-clang)

  ;; gtags
  ;; (require 'fs-ggtags)
  
  ;; first refresh
  (fs-cc-mode-refresh))

(add-hook 'c-mode-common-hook
	  'fs-cc-mode-init)

;; interactive utils
(defun fs-cc-mode-add-sys-include-path (sys-path)
  "Adding system include path.
Argument SYS-PATH new system path."
  (interactive "Dnew system include path:")
  (add-to-list 'fs-cc-mode-addtional-sys-include-path sys-path)
  (fs-cc-mode-refresh))

(defconst fs-cc-mode-header-template
  "#pragma once

class %s
{

};")

(defconst fs-cc-mode-cpp-template
  "#include \"%s.h\"")

(defun fs-cc-mode-create-class (CLASS-NAME PATH)
  "Create a .h and .cpp files cooresponding to CLASS-NAME in PATH."
  (interactive "sclass-name:\nDpath:")
  (let ((header-template (format fs-cc-mode-header-template CLASS-NAME))
	(cpp-template (format fs-cc-mode-cpp-template CLASS-NAME))
	(file-name (concat PATH "/" CLASS-NAME ".")))
    (write-region cpp-template nil (concat file-name "cpp") nil nil nil t)
    (write-region header-template nil (concat file-name "h") nil nil nil t)
    (find-file (concat file-name "h"))))

(provide 'fs-cc-mode)

(require 'fs-gdb)
;;; fs-cc-mode.el ends here