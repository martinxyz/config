;;; -*- Emacs-Lisp -*-
;;; regadhoc.el -- ad-hoc extension of register.el --
;;; Author : Quasihiko Tsuruse <quasi@kc4.so-net.ne.jp> 
;;; http://www003.upp.so-net.ne.jp/quasi/
;;; Created: 2003/01/23
;;; $Id: regadhoc.el,v 1.1 2003/12/15 19:47:57 mrenold Exp $

;;; Note:
;;; Simple and ad-hoc extension of register.el.
;;; Because I have no good rule to define register's name, 
;;; I can't remember where the register points. Then, I create this small elisp.
;;; However, I still believe someone has created better elisp or naming rule. If you know, please tell me!

;;; Function:
;;; 1. Show register's line in minibuffer('regadhoc-jump-to-registers).
;;;    Don't mind about register's point. If you type SPC in minibuffer, jump to the latest register.
;;; 2. Add register automatically('regadhoc-register).
;;;    Don't mind to name a register!

;;; Usage:
;;; Add to your .emacs like this:
;;; (load "regadhoc")
;;; (global-set-key "\C-xrj" 'regadhoc-jump-to-registers)
;;; (global-set-key "\C-x/" 'regadhoc-register)
;;; (setq regadhoc-register-char-list (list ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9)) ;; optional
;;; 'regadhoc-register-char-list is list of your "favorite" register's char.

;;; TODO:
;;; care about \n in message (just my negligence. is there function like chomp in perl?).
;;; treat rectangle (do you use it? really?)
;;; delete register

(defvar regadhoc-register-char-list
  (list ?a ?b ?c ?d ?e ?f ?g)
  "list of register name(char).")

(defun regadhoc-delete-register (name alist)
  "Delq register in alist.
alist is like register-alist. See register.el"
  (let ((elt (assoc (string-to-char name) alist)))
	(if elt	(delq elt alist))))

(defun regadhoc-clear-register ()
  "Clear all register."
  (interactive)
  ;; TODO
  (setq register-alist nil))

(defun regadhoc-register (&optional arg)
  "Register automatically."
  (interactive "P")
  (let ((r (or (regadhoc-next-register-char regadhoc-register-char-list register-alist)
			   (read-char (format 
						   "All register is used. Point to (new) register:\n %s" 
						   (cdr (regadhoc-registers-info register-alist)))))))
	(message "Set Register %s:%s %s" (char-to-string r) (buffer-name) (thing-at-point 'line))
	(point-to-register r arg)))

(defun regadhoc-next-register-char (l r)
  "Return element of l if it's not used in r."
  (cond 
   ((null l) nil)
   ((not (assoc (car l) r))	(car l))
   (t (regadhoc-next-register-char (cdr l) r))))

(defun regadhoc-line-at-marker (marker)
  "Return line at marker."
  (if marker
	  (save-excursion
		(set-buffer (marker-buffer marker))
		(goto-char (marker-position marker))
		(thing-at-point 'line))))

(defun regadhoc-register-marker (contents)
  "Return marker of register."
  (cond
   ((markerp contents) contents)
   ((and (consp contents) (frame-configuration-p (car contents)) (markerp (cadr contents)))
	(cadr contents))
   (t nil)))

(defun regadhoc-registers-info (alist)
  "Return marker register(s) info. (head . msg).
alist is like register-alist. See register.el"
  (let (elt head msg name marker)
	(while alist
	  (setq elt (car alist)) ;; (NAME . CONTENTS)
	  (setq name (car elt))
	  (setq marker (regadhoc-register-marker (cdr elt)))
	  (cond 
	   ((null marker) nil)
	   ((marker-buffer marker)
 		(setq head (cons (char-to-string name) head))
 		(setq msg (cons (regadhoc-register-format name marker) msg))))
	  (setq alist (cdr alist)))
	(cons (mapconcat 'concat head " ") (mapconcat 'concat msg ""))))

(defun regadhoc-show-registers ()
  (interactive)
  (let* ((msg (regadhoc-registers-info register-alist)))
	(message "%s\n%s" (car msg) (cdr msg))))

(defun regadhoc-register-format (name marker)
  "Return register info."
  (format "%s:%s %s"
		  (char-to-string name) 
		  (if marker (buffer-name (marker-buffer marker)))
		  (regadhoc-line-at-marker marker)))

(defun regadhoc-jump-to-registers (register)
  "Jump to registers."
  (interactive
   (let* ((msg (regadhoc-registers-info register-alist))
		  (r (read-char-exclusive (concat "Jump to register(SPC is the latest): " (car msg) "\n" (cdr msg)))))
	 (list r)))
  (cond
   ((equal (string-to-char " ") register)
	(jump-to-register (caar register-alist))
	(message "Jump to the latest register."))
   (t
	(if (get-register register)
		(jump-to-register register)
	  (message "Oops. No such register.")))))


;;;

