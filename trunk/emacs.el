;; .emacs von Martin Renold
;; Aus verschiedenen Quellen zusammenkopiert,
;; neuere Dinge am Schluss.

;; wohin die "customize"-Einstellungen gespeichert werden
(setq custom-file "~/elisp/emacs-custom")
(load "~/elisp/emacs-custom" t t)

;; ??
;(add-hook  'dired-load-hook  (function  (lambda  ()  (load  "dired-x"))))
;(setq  dired-omit-files-p  t)

;;(global-set-key  [f1]  'dired)
;; F1 zeigt die Manpage zum Wort unter dem cursor
(global-set-key [(f1)] (lambda () (interactive) (manual-entry (current-word))))
;; ??, scheint nicht zu funktionnieren.
(global-set-key [(f2)] (lambda () (interactive) 
                         (let ((word-at-point (current-word))) 
                                 (Info-query "libc")
                                 (Info-index word-at-point))))
;;(global-set-key  [f2]  'dired-omit-toggle)

;;(global-set-key  [f3]  'find-file)
(global-set-key  [f4]  'next-error)
(global-set-key  [f5]  'delete-other-windows)
(global-set-key  [f6]  'next-multiframe-window)
(global-set-key  [f7]  'switch-to-other-buffer)
(global-set-key  [f8]  'compile)
(global-set-key  [f9]  'recompile)
(global-set-key  [f12]  'add-change-log-entry-other-window)

(global-set-key "\C-z" 'undo)

;; ;; This adds additional extensions which indicate files normally
;; ;; handled by cc-mode.
;; (setq auto-mode-alist
;;       (append '(("\\.C$"  . c++-mode)
;; 		("\\.cc$" . c++-mode)
;; 		("\\.hh$" . c++-mode)
;; 		("\\.c$"  . c-mode)
;; 		("\\.h$"  . c-mode)
;; 		("\\.html\\.in$" . html-mode))
;; 	      auto-mode-alist))

;; do more syntax-highlighting
;;(setq-default font-lock-maximum-decoration t)
;;(setq-default font-menu-ignore-scaled-fonts nil)

;; hungry delete, DEL loescht beim C programmieren
;; gleich alle Leerschlaege
(add-hook 'c-mode-common-hook
          '(lambda () 
	     (c-set-style "gnu")
	     (c-toggle-auto-state -1)
	     (c-toggle-hungry-state 1)))                  

;;setq compile-command '("gmake"))
;;setq compile-command '("gmake" . 4))

;; highlight matching parenthesis
(show-paren-mode t)

;; start viper on startup (vim keybindings)
(setq viper-mode t)
(require 'viper)

(defun linux-c-mode ()
       "C mode with adjusted defaults for use with the Linux kernel."
       (interactive)
       (c-mode)
       (setq c-indent-level 8)
       (setq c-brace-imaginary-offset 0)
       (setq c-brace-offset -8)
       (setq c-argdecl-indent 8)
       (setq c-label-offset -8)
       (setq c-continued-statement-offset 8)
       (setq indent-tabs-mode nil)
       (setq tab-width 8))

;; Martin C mode (??)
;; TODO: irgendwie funktionniert das nicht so richtig...
(defun martin-c-mode ()
  "Linux C coding style"
  (interactive)
  ;; (c-mode)
;  (c-set-style "K&R")
  ;; (setq c-basic-offset 1)
  )

(defun stratagus-c-mode ()
  "Stratagus C coding style"
  (interactive)
  (c-mode)
  (c-set-style "stroustrup")
  )

;; Programmierstil. 
;; TODO: Im c-mode beim Laden einer Datei 
;; den fremden Stil erkennen und automatisch einstellen.
(setq auto-mode-alist 
      (cons '("/usr/src/linux.*/.*\\.[ch]$" . linux-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/stratagus/.*/.*\\.[ch]$" . stratagus-c-mode)
          auto-mode-alist))

;; Add my directories to load-path.
(setq load-path (append
                 '("~/elisp")
                 load-path))

; Color-themes package.  Headers in source file:
; Author: Jonadab the Unsightly One <jonadab@bright.net>
; Maintainer: Alex Schroeder <alex@gnu.org>
; URL: http://www.emacswiki.org/cgi-bin/wiki.pl?ColorTheme

(require 'color-theme)
;(color-theme-sitaramv-solaris)
(color-theme-dark-laptop)

;;yntax highlighting
;;cond (window-system
;;      (setq hilit-mode-enable-list  '(not text-mode)
;;     hilit-background-mode   'light
;;     hilit-inhibit-hooks     nil
;;     hilit-inhibit-rebinding nil)))

;;font-lock-mode t)
(global-font-lock-mode t)

;; Don't wrap long lines.
(set-default 'truncate-lines t)
;; M-x wrap-all-lines schaltet das ein und aus
(defun wrap-all-lines ()
  "Toggle line wrapping"
(interactive) ;this makes the function a command too
(setq truncate-lines (if truncate-lines nil t))
)

;;Default is text mode with auto-fill on
(setq default-major-mode 'text-mode)
(setq text-mode-hook
      '(lambda () (auto-fill-mode 1) ) )
(setq c-mode-hook
      '(lambda () (auto-fill-mode 1) ) )

;; Disable menu bar
(menu-bar-mode 0)

;; groessere Schrift
(set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")

;; Enter soll im c-modus auto-indent machen
(setq viper-auto-indent t)

;; Neuerdings druecke ich Ctrl-x-c aus versehen...
(defun ask-before-quit ()
  "Ask if the user really wants to quit Emacs."
  (interactive)
  (yes-or-no-p "Really quit emacs? "))
(add-hook 'kill-emacs-query-functions 'ask-before-quit)

;; disable the cursed startup message
(setq inhibit-startup-message t)

;; set C-tab to switch frames
(global-set-key [(control tab)] `other-window)


