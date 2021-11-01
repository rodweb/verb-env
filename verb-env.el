;;; verb-env.el --- Add environments to verb-mode -*- lexical-binding: t -*-

;; Author: Rodrigo Campos <rod.apd@gmail.com>
;; Maintainer: Rodrigo Campos <rod.apd@gmail.com>
;; Homepage: https://github.com/rodweb/verb-env
;; Keywords: tools
;; Package-Version: 0.1.0
;; Package-Requires: ((emacs "25.1") (verb "2.14.0"))

;; This file is NOT part of GNU Emacs.

;; verb-env is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; verb-env is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with verb-env.  If not, see http://www.gnu.org/licenses.

;;; Commentary:

;; verb-env is a package that adds environments to verb-mode.

;;; Code:

(require 'verb)

(defgroup verb-env nil
  "Environments for `verb-mode'."
  :prefix "verb-env-"
  :group 'tools)

(defcustom verb-env-environments nil
  "List of variables by environment."
  :type '(list (cons string (list (cons string string)))))

(defcustom verb-env-always-unset-vars t
  "Always unset variables when changing environments."
  :type 'boolean)

(defcustom verb-env-default nil
  "Default environment."
  :type 'string)

(defun verb-env-select (&optional use-default)
  "Set verb variables for the selected environment.
   If USE-DEFAULT is non nil, select `verb-env-default'."
  (interactive)
  (verb--ensure-verb-mode)
  (when verb-env-always-unset-vars
    (verb-unset-vars))
  (let* ((environments (mapcar (lambda (env) (car env)) verb-env-environments))
         (selected (if use-default verb-env-default (completing-read "Environment: " environments nil t)))
         (variables (cdr (assoc selected verb-env-environments))))
    (dolist (var variables)
      (let ((key (car var))
            (value (cdr var)))
        (eval `(verb-var ,key ""))
        (verb-set-var key value)))))

(defun verb-env--select-default ()
  "Select the `verb-env-default' environment."
  (verb-env-select t))

(define-minor-mode verb-env-mode
  "Minor mode to manage sets of related variables for `verb-mode'."
  :lighter " verb-env"
  :group 'verb-env
  (if verb-env-mode
      (progn
        (define-key verb-command-map (kbd "C-a") #'verb-env-select)
        (when verb-env-default
          (verb-env--select-default)))
    (define-key verb-command-map (kbd "C-a") nil)))

(provide 'verb-env)
;;; verb-env.el ends here
