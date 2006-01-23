;; .emacs von Martin Renold
;; Aus verschiedenen Quellen zusammenkopiert,
;; neuere Dinge am Schluss.

;; wohin die "customize"-Einstellungen gespeichert werden
(setq custom-file "~/config/elisp/emacs-custom")
(load "~/config/elisp/emacs-custom" t t)

; scheint auch ohne zu gehen, aber so ist es gleich von Anfang an geladen
(require 'cc-mode)

;; ??
;(add-hook  'dired-load-hook  (function  (lambda  ()  (load  "dired-x"))))
;(setq  dired-omit-files-p  t)

;; F1 zeigt die Manpage zum Wort unter dem cursor (alle SDL Funkionen haben z.B. eine Manpage)
(global-set-key [(f1)] (lambda () (interactive) (manual-entry (current-word))))
;; ??, scheint nicht zu funktionnieren.
;(global-set-key [(f2)] (lambda () (interactive) 
;                         (let ((word-at-point (current-word))) 
;                                 (Info-query "libc")
;                                 (Info-index word-at-point))))

;;(global-set-key  [f3]  'find-file)

;; Uralte Gewohnheiten aus Borland-Produkten
(global-set-key  [f4]  'next-error)
(global-set-key  [f5]  'delete-other-windows)
(global-set-key  [f6]  'next-multiframe-window)
;(global-set-key  [f7]  'switch-to-other-buffer)
(global-set-key  [f8]  'compile)
(global-set-key  [f9]  (lambda () (interactive) 
                         (if compilation-in-progress (kill-compilation)) 
                         (run-at-time 0.1 nil 'recompile)))
;(global-set-key  [f12]  'add-change-log-entry-other-window)

;(global-set-key "\C-z" 'undo)

; Kleineres Fenster für die Fehlermeldungen
;(setq compilation-window-height 8)

;;setq compile-command '("gmake"))
;;setq compile-command '("gmake" . 4))

;; Compilierfenster entfernen bei Erfolg
;; Quelle: http://www.bloomington.in.us/~brutt/emacs-c-dev.html
(setq compilation-finish-function
      (lambda (buf str)
        (if (string-match "exited abnormally" str)
            ;;there were errors
            ;(message "compilation errors, press C-x ` to visit")
            (message "ERRORs while compiling.")
          ;;no errors, make the compilation window go away in 0.5 seconds
          (run-at-time 0.5 nil 'delete-windows-on buf)
          (message "Compilation done."))))


;; passende Klammer anzeigen wenn man eine schliesst
(show-paren-mode t)

;; start viper on startup (vim keybindings), siehe auch viper.el
(setq viper-mode t)
(require 'viper)

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

;; Programmierstil. 

(defun linux-c-mode ()
       "C mode with adjusted defaults for use with the Linux kernel."
       (interactive)
       (c-mode)
       (setq c-basic-offset 8)
       (setq c-indent-level 8)
       (setq c-brace-imaginary-offset 0)
       (setq c-brace-offset -8)
       (setq c-argdecl-indent 8)
       (setq c-label-offset -8)
       (setq c-continued-statement-offset 8)
       (setq indent-tabs-mode t)
       ;; Note: figure those out with C-c C-o (o=offset)
       (c-set-offset 'substatement-open 0)
       (setq tab-width 8))

(defun stratagus-c-mode ()
  "Stratagus C coding style"
  (interactive)
  (c-mode)
  (c-set-style "stroustrup")
  )

(defun gtk-gnutella-c-mode ()
  "Gtk-gnutella C coding style"
  (interactive)
  (c-mode)
  (setq tab-width 4)
  (set-variable 'tab-width 4)
  (setq c-tab-width 4)
  )

(defun nil-c-mode ()
  "nil C coding style"
  (interactive)
  (asdlfkjvasdera)
  (set-variable 'tab-width 2)
  (c-mode)
  ;; Help! Does all not work, only manually "M-x set-variable tab-with 2" does
  (set-variable 'tab-width 2)
  (setq-default tab-width 2)
  ;(set-variable tab-width 2)

  
  (setq tab-stop 2 t)
  (setq tab-stop-list (quote (2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32)))
  (setq tab-width 2)

  (setq c-basic-offset 2)
  (setq c-indent-level 2)
  (setq indent-tabs-mode t)
  (setq tab-width 2)
  (setq c-tab-width 2)
  )

;; TODO: Im c-mode beim Laden einer Datei 
;; den fremden Stil erkennen und automatisch einstellen.
(setq auto-mode-alist 
      (cons '(".*/linux.*/.*\\.[ch]$" . linux-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/stratagus/.*/.*\\.[ch]$" . stratagus-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/gtk-gnutella.*/.*/.*\\.[ch]$" . gtk-gnutella-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/nil/.*(cpp|h)$" . nil-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*\\.mas$" . python-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*\\.java$" . java-mode)
          auto-mode-alist))

;; Add my directories to load-path.
(setq load-path (append
                 '("~/config/elisp")
                 load-path))

; Color-themes package. 
; URL: http://www.emacswiki.org/cgi-bin/wiki.pl?ColorTheme
(require 'color-theme)
;(color-theme-sitaramv-solaris)
(color-theme-dark-laptop)

; syntax highlighting on
(global-font-lock-mode t)
;; do more syntax-highlighting
;;(setq-default font-lock-maximum-decoration t)
;;(setq-default font-menu-ignore-scaled-fonts nil)

;; don't wrap long lines.
(set-default 'truncate-lines t)
;; M-x wrap-all-lines schaltet das ein und aus
(defun wrap-all-lines ()
  "Toggle line wrapping"
  (interactive) ;make the function a command too
  (setq truncate-lines (if truncate-lines nil t)))

;; default text mode is with auto-fill on
(setq default-major-mode 'text-mode)
(setq text-mode-hook
      '(lambda () (auto-fill-mode 1) ) )

;; disable menu bar
(menu-bar-mode 0)

;; groessere Schrift
(set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")

;; Neuerdings druecke ich Ctrl-x-c aus versehen...
(defun ask-before-quit ()
  "Ask if the user really wants to quit Emacs."
  (interactive)
  (yes-or-no-p "Really quit emacs? "))
(add-hook 'kill-emacs-query-functions 'ask-before-quit)

;; disable the cursed startup message
(setq inhibit-startup-message t)

;; ?? WAS macht das?
(load "regadhoc")
(global-set-key "\C-xrj" 'regadhoc-jump-to-registers)
(global-set-key "\C-x/" 'regadhoc-register)
;;; (setq regadhoc-register-char-list (list ?1 ?2 ?3 ?4 ?5 ?6 ?7 ?8 ?9)) ;; optional
;;; 'regadhoc-register-char-list is list of your "favorite" register's char.

(add-hook 'c-mode-common-hook
  (lambda () 
    ; keine automatischen newlines wenn man ; drueckt
    ;(c-toggle-auto-newline-state -1)
    (c-toggle-auto-state -1)
    ; hungry delete loescht alle leerzeichen auf einmal
    (c-toggle-hungry-state 1)
    (c-set-style "gnu")
    ;(setq tab-width 2)
    ))

; Der Octave-Mode braucht eine extraaufforderung den viper zu benutzen
(add-hook 'octave-mode-hook
  (lambda () 
    (viper-mode) ))

; Tabs fuer eclipse java zeugs
(add-hook 'java-mode-hook
  (lambda () 
    (setq indent-tabs-mode t)
    (setq tab-width 4)))


; Ich glaube das ist damit mal ein file.c.bz2 direkt editieren kann
(auto-compression-mode t)

(global-set-key "\M- " 'pop-global-mark)

(column-number-mode t)

; macht nur dass cut&paste von einem xterm nicht mehr geht
;(setq x-select-enable-clipboard t)

; Nützlich für "Search & Replace" in einer Region
(put 'narrow-to-region 'disabled nil)

; indent with spaces, never tabs (for details google "emacs tabs")
(setq-default indent-tabs-mode nil)

;; Enter soll im c-modus auto-indent machen
(setq viper-auto-indent t)
(custom-set-variables
 '(viper-auto-indent t))

;; always use viper for a buffer if appropriate
(setq viper-always t)

;; Buffer Wechseln mit Tastatur
; Paket swbuff von: http://perso.wanadoo.fr/david.ponce/more-elisp.html
(require 'swbuff)
; keine internen buffer *scratch* *help* etc. (regex aus doku)
(setq-default swbuff-exclude-buffer-regexps '("^ " "^\*.*\*" "TAGS"))
(define-key viper-vi-local-user-map "q" 'swbuff-switch-to-next-buffer)
;(define-key viper-vi-local-user-map "f" 'swbuff-switch-to-next-buffer)
(define-key viper-vi-local-user-map "Q" 'swbuff-switch-to-previous-buffer)
;(define-key viper-vi-local-user-map "F" 'swbuff-switch-to-previous-buffer)
;(define-key viper-vi-local-user-map "s" 'swbuff-switch-to-previous-buffer)

;; insert a new comment with space
(defun martin-insert-comment ()
  (interactive)
  (comment-dwim nil)
  (viper-insert nil))
  ;; (viper-change-state-to-insert)))
;(define

; for outline-mode
;(define-key viper-vi-local-user-map " " 'hs-toggle-hiding)
;(define-key viper-vi-local-user-map "-" 'hs-hide-all)
;(define-key viper-vi-local-user-map "+" 'hs-show-all)

(define-key viper-vi-local-user-map "*" 'pop-tag-mark)
(define-key viper-vi-local-user-map "," 'tags-search)

;(define-key viper-vi-local-user-map "W" 'kill-region)
(define-key viper-vi-local-user-map "W" 'copy-region-as-kill)
(define-key viper-vi-local-user-map " " 'set-mark-command)
;(define-key viper-vi-local-user-map "F" 'pop-global-mark)
(define-key viper-vi-local-user-map "M" 'delete-other-windows)
(define-key viper-vi-local-user-map "D" 'kill-this-buffer)
(define-key viper-vi-local-user-map "K" 'kill-this-buffer)
;(define-key viper-vi-local-user-map "P" 'yank-pop)
;(define-key viper-vi-local-user-map "ä" 'viper-bol-and-skip-white)

; better scrolling
; http://user.it.uu.se/~mic/emacs.html
(require 'pager)

(defun pager-some-rows-down ()
  (interactive)
  (pager-row-down)
  (pager-row-down)
  (pager-row-down)
  )
(defun pager-some-rows-up ()
  (interactive)
  (pager-row-up)
  (pager-row-up)
  (pager-row-up)
  )

(define-key viper-vi-basic-map "\C-u" 'pager-page-up)
(define-key viper-vi-basic-map "\C-d" 'pager-page-down)

(global-set-key [next] 	   'pager-page-down)
(global-set-key [prior]	   'pager-page-up)

; scroll text (cursor fixed)
(global-set-key "\M-k"  'pager-some-rows-up)
(global-set-key "\M-j"  'pager-some-rows-down)
(define-key c-mode-base-map "\M-j"  'pager-some-rows-down)

; speichert liste von zuletzt geoeffneten dateien beim Beenden
(require 'recentf)
(recentf-mode 1)

; damit hungry delete auch in viper-insert mode geht
(define-key viper-insert-global-user-map [backspace] 'c-electric-backspace)

(defun w3m-copy-url-as-kill ()
  (interactive)
  "paste w3m link location into kill ring"
  (kill-new (w3m-anchor)) )

(autoload 'wikipedia-mode "wikipedia-mode.el"
  "Major mode for editing documents in Wikipedia markup." t)

; UTF-8 files:
; C-x RET c runs the command universal-coding-system-argument
;    Execute an I/O command using the specified coding system.

; From the Unicode-HOWTO:
;; (if (not (string-match "XEmacs" emacs-version))
;;   (progn
;;     (require 'unicode)
;;     ;(setq unicode-data-path "..../UnicodeData-3.0.0.txt")
;;     (if (eq window-system 'x)
;;       (progn
;;         (setq fontset12
;;           (create-fontset-from-fontset-spec
;;             "-misc-fixed-medium-r-normal-*-12-*-*-*-*-*-fontset-standard"))
;;         (setq fontset13
;;           (create-fontset-from-fontset-spec
;;             "-misc-fixed-medium-r-normal-*-13-*-*-*-*-*-fontset-standard"))
;;         (setq fontset14
;;           (create-fontset-from-fontset-spec
;;             "-misc-fixed-medium-r-normal-*-14-*-*-*-*-*-fontset-standard"))
;;         (setq fontset15
;;           (create-fontset-from-fontset-spec
;;             "-misc-fixed-medium-r-normal-*-15-*-*-*-*-*-fontset-standard"))
;;         (setq fontset16
;;           (create-fontset-from-fontset-spec
;;             "-misc-fixed-medium-r-normal-*-16-*-*-*-*-*-fontset-standard"))
;;         (setq fontset18
;;           (create-fontset-from-fontset-spec
;;             "-misc-fixed-medium-r-normal-*-18-*-*-*-*-*-fontset-standard"))
;;        ; (set-default-font fontset15)
;;         ))))

; from http://www.tbray.org/ongoing/When/200x/2003/09/27/UniEmacs
;you can force it to use UTF-8 when it saves, like so:
;(set-language-environment "UTF-8")
; try M-x ucs-insert

; ... funktionniert alles nicht. Egal, ich lasse es mal da.

;; Transparentes editieren über ssh, sudo, ftp, samba, ...
;; Einfach eine Datei mit folgendem Namen oeffnen:
;; ssh   /remotehost:filename
;; sudo  /sudo::/etc/X11/XF86Config-4
;; sonst /method:user@remotehost:filename
; ACHTUNG: macht scheinbar wegen history immer ssh-verbindungen
; nur schon beim emacs-start auf...
; ... passiert auch ohne (require 'tramp), also nur rein damit.
;(require 'tramp)

;; ; not a mode, but I search for tramp-mode anyway when I want it
;; (defun tramp-mode ()
;;        "Load tramp mode, display helptext."
;;        (interactive)
;;        (require 'tramp)
;;        (message "now open /remotehost:filename"))

(put 'upcase-region 'disabled nil)

;; TODO: try to configure "semantic" / "cedet" to work fast enough here
;;   it reparses the buffer automatically on changes, cool! but too slow.
