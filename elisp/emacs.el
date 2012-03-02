;; .emacs von Martin Renold
;; Aus verschiedenen Quellen zusammenkopiert,
;; neuere Dinge am Schluss.

;; wohin die "customize"-Einstellungen gespeichert werden
(setq custom-file "~/config/elisp/emacs-custom")
(load "~/config/elisp/emacs-custom" t t)

; scheint auch ohne zu gehen, aber so ist es gleich von Anfang an geladen
(require 'cc-mode)

(set-cursor-color "yellow")

;; C-z is usually 'iconify-or-deiconify-frame, but viper uses it to toggle
;; vi/emacs input modes, causing confusion in non-viper buffers
(global-unset-key "\C-z")
;; start viper on startup (vim keybindings), siehe auch viper.el
(setq viper-mode t)
(require 'viper)

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
(global-set-key  [(shift f4)]  'previous-error)

(defun last-error () ; useful when coding python (go to end of traceback)
  (interactive)
  (with-current-buffer next-error-last-buffer
    (setq compilation-current-error (point-max)))
  (previous-error))

(global-set-key  [f5]  'last-error)
(global-set-key  [f6]  'next-multiframe-window)
;(global-set-key  [f7]  'switch-to-other-buffer)
(global-set-key  [f8]  'compile)
(global-set-key  [f9]  (lambda () (interactive)
						 (desktop-save-in-desktop-dir)
                         (if compilation-in-progress (kill-compilation))
                         (run-at-time 0.3 nil 'recompile)))
(global-set-key  [f10]  'kill-compilation)
;(global-set-key  [f12]  'add-change-log-entry-other-window)

(define-key viper-vi-local-user-map "\C-e" 'bigterm-in-current-directory)
;(global-set-key  "\C-e" 'bigterm-in-current-directory)
(global-set-key  [F12] 'bigterm-in-current-directory)

(defun bigterm-in-current-directory ()
  "start a terminal in the current directory"
  (interactive)
  ;(start-process "terminal" nil "~/scripts/bigterm"))
  ; background it to avoid "active processes exist" question when exiting emacs
  (start-process "terminal" nil "bash" "-c" "~/scripts/bigterm" "&"))

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


(require 'compile)
; questa / vsim style errors
(add-to-list 'compilation-error-regexp-alist 'vsim)
; # ** Error: ../../source/core/queue_fifo.vhd(22): (vcom-1195) Cannot find expanded name "work.ram".
(push '(vsim "^..\\(ERROR\\|WARNING\\|\\*\\* Error\\|\\*\\* Warning\\)[^:]*: \\(\\[[0-9]+\\] \\)?\\(.+\\)(\\([0-9]+\\)):" 3 4)
      compilation-error-regexp-alist-alist)
(add-to-list 'compilation-error-regexp-alist 'vsim2)
; # Error in macro ./queue_fifo.do line 22
(push '(vsim2 "^..Error in macro \\([^ ]+\\) line \\([0-9]+\\)" 1 2)
      compilation-error-regexp-alist-alist)

; Error: Symbolic name "_clk3" is used but not defined File: /opt/altera9.1/quartus/libraries/megafunctions/altpll.tdf Line: 1376
(add-to-list 'compilation-error-regexp-alist 'quartus1)
; # Error in macro ./queue_fifo.do line 22
;(push '(quartus1 "^Error.*File: \\([^ ]+\\) Line: \\([0-9]+\\)" 1 2)
;      compilation-error-regexp-alist-alist)
(push '(quartus1 "File: \\([^ ]+\\) Line: \\([0-9]+\\)" 1 2)
      compilation-error-regexp-alist-alist)

; fix from https://bugs.launchpad.net/ubuntu/+source/emacs23/+bug/814468
(add-to-list 'compilation-error-regexp-alist 'gcc_include_fix)
(push '(gcc_include_fix "^\\(?:In file included\\|                \\) from \
+\\([^:]+\\):\\([0-9]+\\)\\(?::[0-9]+\\)?[:,]$" 1 2)
      compilation-error-regexp-alist-alist)

; own fix
;(add-to-list 'compilation-error-regexp-alist 'unresolved_reference)
;(push '(unresolved_reference "\\(^obj[^:]+[:]\\)\\([^0-9][^:]+\\)[:]\\([0-9]+\\)[:] first defined here" 2 3)
;      compilation-error-regexp-alist-alist)

; own fix
(add-to-list 'compilation-error-regexp-alist 'unresolved_reference2 t)
(push '(unresolved_reference2 "\\(^obj[^:]+[:]\\)\\([^0-9][^:]+\\)[:]\\([0-9]+\\)[:] first defined here" 2 3)
      compilation-error-regexp-alist-alist)

;; passende Klammer anzeigen wenn man eine schliesst
(show-paren-mode t)

; ;; This adds additional extensions which indicate files normally
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

;(setq-default c-electric-flag nil)
(setq-default c-brace-newlines nil)

(defun wesnoth-c-mode ()
  "Wesnoth cpp coding style"
  (interactive)
  (c++-mode)
  ; indent with tabs only.
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode t)
  )

(defun ines-c-mode ()
  "InES c coding style"
  (interactive)
  (c-mode)
  ; indent with tabs only.
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode t)
  (c-set-offset 'substatement-open 0)
  )

(defun ines-hsr-mode ()
  "InES c coding style"
  (interactive)
  (c-mode)
  (setq c-basic-offset 4
        tab-width 4)
  (c-set-offset 'substatement-open 0)
  )

(defun ines-vhdl-mode ()
  (interactive)
  (vhdl-mode)
  (viper-mode)
  (setq tab-width 4)
  )

(defun gimp-c-mode ()
  (interactive)
  (c-mode)
  ;; from developer.gimp.org FAQ:
  ;; use the GNU style for C files, spaces instead of tabs, highlight bad spaces
  (c-set-style "gnu")
  (setq indent-tabs-mode nil)
  (setq show-trailing-whitespace t)
  (setq tab-width 8)
  )

(defun gtk-c-mode ()
  (interactive)
  (c-mode)
  (c-set-style "gnu")
  (setq indent-tabs-mode t)
  (setq show-trailing-whitespace t)
  (setq tab-width 8)
  )

(defun wireshark-c-mode ()
  "Wireshark c coding style"
  (interactive)
  (c-mode)
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil)
  (c-set-offset 'substatement-open 0)
  )

;; TODO: Im c-mode beim Laden einer Datei 
;; den fremden Stil erkennen und automatisch einstellen.
(setq auto-mode-alist 
      (cons '(".*/linux.*/.*\\.[ch]$" . linux-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/git/.*\\.[ch]$" . linux-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/wesnoth.*\\.cpp$" . wesnoth-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/wesnoth.*\\.hpp$" . wesnoth-c-mode)
          auto-mode-alist))
;(setq auto-mode-alist 
;      (cons '(".*/ieee1588v2.*\\.[ch]$" . ines-c-mode)
;          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/prp.*\\.[ch]$" . ines-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/coldfire.*\\.[ch]$" . ines-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/hsr.*\\.[ch]$" . ines-hsr-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/gimp.*/.*\\.[ch]$" . gimp-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*/gtk+.*/.*\\.[ch]$" . gtk-c-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*\\.mas$" . python-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*\\.java$" . java-mode)
          auto-mode-alist))
(setq auto-mode-alist 
      (cons '(".*SConstruct$" . python-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*\\.do$" . tcl-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*\\.m$" . octave-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*\\.d$" . c-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*\\.vhd$" . ines-vhdl-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*\\.do$" . sh-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*\\.pde$" . c-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*wireshark.*\\.[ch]$" . wireshark-c-mode)
          auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*/linux_ts.*/.*\\.[ch]$" . ines-hsr-mode)
          auto-mode-alist))

;(setq auto-mode-alist 
;      (cons '(".*/ptp2_.*\\.[ch]$" . ines-c-mode)
;          auto-mode-alist))

;; Add my directories to load-path.
(setq load-path (append
                 '("~/config/elisp")
                 load-path))
(setq load-path (append
                 '("~/config/elisp/python-mode-1.0")
                 load-path))

;(require 'vimpulse) ; only visual mode, not much more...
(setq viper-ex-style-editing nil)  ; can backspace past start of insert / line

;(eval-after-load "pymacs"
;  '(add-to-list 'pymacs-load-path "~/config/elisp"))
;(pymacs-load "pymacstest" "pytest-")
;;(message (pytest-foo))

; Color-themes package. 
; URL: http://www.emacswiki.org/cgi-bin/wiki.pl?ColorTheme
(require 'color-theme)
;(color-theme-sitaramv-solaris)
(color-theme-dark-maxy)

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

;; default text mode is with auto-fill <s>on</s>off
(setq default-major-mode 'text-mode)
(setq text-mode-hook
      '(lambda () (auto-fill-mode 0) ) )

;; disable menu bar
;(menu-bar-mode 0)

;; Turn off mouse interface early in startup to avoid momentary display
;; You really don't need these; trust me.
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; groessere Schrift
(set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")
;(set-frame-font "-Misc-Fixed-Medium-R-Normal--15-140-75-75-C-90-ISO8859-1")

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
; <old version>
;   ;(c-toggle-auto-newline-state -1)
    (c-toggle-auto-state -1)
; </old version>
    ;(c-toggle-auto-newline-state -1)
    ;(c-toggle-auto-newline -1)
    ; obsolete: (c-toggle-auto-state -1)
    ; hungry delete loescht alle leerzeichen auf einmal
    (c-toggle-hungry-state 1)
    (c-set-style "gnu")
    (setq tab-width 4)
    ;(setq show-trailing-whitespace t)
    ))

; Der Octave-Mode braucht eine extraaufforderung den viper zu benutzen
(add-hook 'octave-mode-hook
  (lambda () 
    (viper-mode)
    (setq tab-width 4)
    (setq octave-block-offset 4)
    ))

; Tabs fuer eclipse java zeugs
(add-hook 'java-mode-hook
  (lambda () 
    (setq indent-tabs-mode t)))

; Ich glaube das ist damit mal ein file.c.bz2 direkt editieren kann
(auto-compression-mode t)

(global-set-key "\M- " 'pop-global-mark) ; <-- den kann ich mir nicht merken
(define-key viper-vi-local-user-map "<" 'pop-global-mark) ; vielleicht kann ich mir ja einen davon merken...

(column-number-mode t)

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

; TODO: replace swbuff?
;Another vote for iswitchb-mode. It's so immensely useful, and does not seem to be very well known. I set it up like this:
;(setq iswitchb-prompt-newbuffer nil)
;(iswitchb-mode t)

; ido = iswitchb fork + same functionality for finding files
(require 'ido)
(ido-mode t)

; not really working anyway
;; (add-hook 'ido-define-mode-map-hook 'ido-my-keys)
;; (defun ido-my-keys ()
;;   "Add my keybindings for ido."
;;   ;(define-key ido-mode-map " " 'ido-next-match)
;;   (define-key ido-mode-map " " 'ido-next-match)
;;   (define-key ido-mode-map [up] 'ido-enter-find-file) ; just for the history, TODO: how can the same be done in ido?
;;   ;(define-key ido-mode-map "~" 'ido-next-match)
;;   )


; sort ido filelist by mtime instead of alphabetically
; my own implementation, watch for feedback at http://www.emacswiki.org/cgi-bin/wiki/InteractivelyDoThings
(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
(defun ido-sort-mtime ()
  (setq ido-temp-list
        (sort ido-temp-list 
              (lambda (a b)
                (let ((ta (nth 5 (file-attributes (concat ido-current-directory a))))
                      (tb (nth 5 (file-attributes (concat ido-current-directory b)))))
                  (if (= (nth 0 ta) (nth 0 tb))
                      (> (nth 1 ta) (nth 1 tb))
                    (> (nth 0 ta) (nth 0 tb)))))))
  (ido-to-end  ;; move . files to end (again)
   (delq nil (mapcar
              (lambda (x) (if (string-equal (substring x 0 1) ".") x))
              ido-temp-list))))

(define-key viper-vi-local-user-map "t" 'martin-kill-whole-line)

(defun martin-kill-whole-line ()
  (interactive)
  (viper-beginning-of-line (cons ?d ?d))
)

;  (viper-beginning-of-line 1)
;  (viper-kill-line 1)
;  )
;; insert a new comment with space
(defun martin-insert-comment ()
  (interactive)
  (comment-dwim nil)
  (viper-insert nil))

; for outline-mode
;(define-key viper-vi-local-user-map " " 'hs-toggle-hiding)
;(define-key viper-vi-local-user-map "-" 'hs-hide-all)
;(define-key viper-vi-local-user-map "+" 'hs-show-all)

(defun my-jump-to-tag ()
  (interactive)
  (setq last-tags-jump-was-find-tag t)
  (call-interactively 'find-tag))

(defun my-continue-tag-search ()
  (interactive)
  (if last-tags-jump-was-find-tag
      (progn
        (find-tag nil t)
        (ring-remove find-tag-marker-ring 0))
    (tags-loop-continue)))

(defun my-start-tag-grep ()
  (interactive)
  (setq last-tags-jump-was-find-tag nil)
  (call-interactively 'tags-search))

(global-set-key "\M-." 'my-jump-to-tag)
(define-key viper-vi-local-user-map "," 'my-start-tag-grep)
(global-set-key "\M-," 'my-continue-tag-search)
(define-key viper-vi-local-user-map "}" 'my-continue-tag-search)
(global-set-key (kbd "C-.") 'my-jump-to-tag)
(define-key viper-vi-local-user-map ":" 'my-jump-to-tag)

(define-key viper-vi-local-user-map "*" 'pop-tag-mark)

;(define-key viper-vi-local-user-map "W" 'kill-region)
(define-key viper-vi-local-user-map "W" 'copy-region-as-kill)
(define-key viper-vi-local-user-map " " 'set-mark-command)
;(define-key viper-vi-local-user-map "F" 'pop-global-mark)
(define-key viper-vi-local-user-map "M" 'delete-other-windows)
;(define-key viper-vi-local-user-map "D" 'kill-this-buffer)
(define-key viper-vi-local-user-map "K" 'kill-this-buffer)
;(define-key viper-vi-local-user-map "K" 'bury-buffer)
;(define-key viper-vi-local-user-map "P" 'yank-pop)
;(define-key viper-vi-local-user-map "ä" 'viper-bol-and-skip-white)
(define-key viper-vi-local-user-map "v" 'ido-find-file)
(define-key viper-vi-local-user-map "V" 'ido-switch-buffer)

;(global-set-key "%" 'match-paren)
(define-key viper-vi-local-user-map "%" 'match-paren)

; from http://grok2.tripod.com/
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

; better scrolling
; http://user.it.uu.se/~mic/emacs.html
(require 'pager)

; see emacs wiki
(require 'wgrep)

(defun pager-some-rows-down ()
  (interactive)
  (pager-row-down)
  (pager-row-down)
  (pager-row-down)
  (pager-row-down)
  (back-to-indentation)
  )
(defun pager-some-rows-up ()
  (interactive)
  (pager-row-up)
  (pager-row-up)
  (pager-row-up)
  (pager-row-up)
  (back-to-indentation)
  )

(define-key viper-vi-basic-map "\C-u" 'pager-page-up)
(define-key viper-vi-basic-map "\C-d" 'pager-page-down)

(global-set-key [next] 	   'pager-page-down)
(global-set-key [prior]	   'pager-page-up)

; scroll text (cursor fixed)
(global-set-key "\M-k"  'pager-some-rows-up)
(global-set-key "\M-j"  'pager-some-rows-down)
(define-key c-mode-base-map "\M-j"  'pager-some-rows-down)
(define-key viper-vi-local-user-map "[" 'pager-some-rows-down) ; kinesis
(define-key viper-vi-local-user-map "]" 'pager-some-rows-up) ; kinesis

; speichert liste von zuletzt geoeffneten dateien beim Beenden
(require 'recentf)
(recentf-mode 1)

; info about modifying viper per-mode: http://www.cs.cmu.edu/cgi-bin/info2www?%28viper%29Key%20Bindings
(setq my-python-modifier-map (make-sparse-keymap))
(define-key my-python-modifier-map [backspace] 'py-electric-delete)
;(viper-modify-major-mode 'python-mode 'vi-state my-python-modifier-map)
(viper-modify-major-mode 'python-mode 'insert-state my-python-modifier-map)

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
;(setq tramp-default-method "ssh")

;; ; not a mode, but I search for tramp-mode anyway when I want it
;; (defun tramp-mode ()
;;        "Load tramp mode, display helptext."
;;        (interactive)
;;        (require 'tramp)
;;        (message "now open /remotehost:filename"))

(put 'upcase-region 'disabled nil)

;; TODO: try to configure "semantic" / "cedet" to work fast enough here
;;   it reparses the buffer automatically on changes, cool! but too slow.

; mode for ocaml files
;(load "append-tuareg")
; fails on tardis:
;(load "pyrex-mode")


;; Wishlist
;
; Faster incremental search. (without pressing return)
; - bind viper / to isearch
; - bind viper ä to reverse isearch
; - remap keys within the search (disallow searching for:)
;   - type space to confirm the search.
;   - type / to find the next
;   - type ESC to cancel the search (no viper commands needed in minibuffer)
; - (use // to repeat it)
; - start to use it.
;
; --- and I don't want to code this... damn it... there must be an easier way...

; use 'dtemacs' & co (package gnuserv) to use emacs as $EDITOR for small stuff too
; - maybe use (package wmctrl) to raise the window?

; alternative(s) to swbuff:  -- will become emacs 22 default, see wiki
; Iswitchb is [0] (info "(emacs)Iswitchb")
;   <fsbot> [1] an improvement (on C-x b) in switching buffers,
;   <fsbot> [2] type few letters of a buffer name and it will move to the front of the list,
;   <fsbot> [3] use C-s and C-r to "scroll" forward and backwards through the buffer-list, ..[Type ,more]
;(setq ibuffer-shrink-to-minimum-size t)
;(setq ibuffer-always-show-last-buffer nil)
;(setq ibuffer-sorting-mode 'recency)
;(setq ibuffer-use-header-line t)

; From the GIMP developer webpage:

;; Merge this into your custom-set-variables section if you already have one
(custom-set-variables
 ;; Syntax highlighting
 ;'(global-font-lock-mode t nil (font-lock))
 ;'(show-paren-mode t nil (paren))
 ;; User name to be put in the ChangeLog file by M-x add-change-log-entry
 '(user-full-name "Martin Renold")
 '(user-mail-address "martinxyz@gmx.ch")
 )

;; use UTF-8 by default
;(prefer-coding-system 'mule-utf-8)

(global-set-key "\M-l" 'dabbrev-expand) ; windows-tastaturen haben den / nicht in reichweite
(global-set-key "ł" 'dabbrev-expand) ; kinesis AltGr-l

;(load-library "ispell")
;(setq ispell-program-name "aspell")

;(load "remem.el")

;; Org-mode settings
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;(global-set-key "\C-cl" 'org-store-link)
;(global-set-key "\C-ca" 'org-agenda)

; host specific stuff
(load "~/config/elisp/local-config")

; tips from http://infolab.stanford.edu/~manku/dotemacs.html
(fset 'yes-or-no-p 'y-or-n-p)
(setq enable-recursive-minibuffers t) ;; allow recursive editing in minibuffer
;(resize-minibuffer-mode 1)            ;; minibuffer gets resized if it becomes too big
(setq scroll-step 1) ; maybe this did interfer with "pager"?
(setq scroll-conservatively 1) ; maybe this did interfer with "pager"?

;; overwrite viper function to remove silly question:
(defun viper-set-register-macro (reg)
  (set-register reg last-kbd-macro))

; http://github.com/mattharrison/emacs-starter-kit
(require 'starter-kit-defuns)


(put 'downcase-region 'disabled nil)

;; -----------------------------------------------------------------------------
;; Git support
;; -----------------------------------------------------------------------------
;(load "/usr/share/git-core/emacs/git.el")
;(load "/usr/share/git-core/emacs/vc-git.el")
;(add-to-list 'vc-handled-backends 'GIT)

(require 'git-blame) ; note: modified version of git-blame.el
(define-key viper-vi-local-user-map "B" 'git-blame-mode)


;(add-to-list 'load-path "~/compile/mo-git-blame")

;(autoload 'mo-git-blame-file "mo-git-blame" nil t)
;(autoload 'mo-git-blame-current "mo-git-blame" nil t)

;Optionally bind keys to these functions, e.g.
;
;(global-set-key [?\C-c ?g ?c] 'mo-git-blame-current)
;(global-set-key [?\C-c ?g ?f] 'mo-git-blame-file)
