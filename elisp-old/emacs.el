;; .emacs von Martin Renold
;; Aus verschiedenen Quellen zusammenkopiert,
;; neuere Dinge am Schluss.

; latest evil version with fix for undo bug
(add-to-list 'load-path "~/compile/evil")
(add-to-list 'load-path "~/compile/evil/lib")
(require 'undo-tree)
(require 'evil)
(evil-mode 1)
; evil is installed from melpa now
; undo-tree is required for evil's redo to work (and is also nice on its own)
;(add-to-list 'load-path "~/config/elisp/evil/lib")
;(require 'undo-tree)
;(global-undo-tree-mode)
;(add-to-list 'load-path "~/config/elisp/evil")
;(require 'evil)
;(evil-mode 1)


;; wohin die "customize"-Einstellungen gespeichert werden
(setq custom-file "~/config/elisp/emacs-custom")
(load "~/config/elisp/emacs-custom" t t)
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
;(require 'seq)

; scheint auch ohne zu gehen, aber so ist es gleich von Anfang an geladen
(require 'cc-mode)

; make sure we use python-mode from melpa (bugfix about slow font-lock-mode)
(require 'python-mode)

(set-cursor-color "yellow")

; some nice ideas there, but nothing wrong with ido, imo
;(require 'icicles)

;; Add my directories to load-path.
(setq load-path (append
                 '("~/config/elisp")
                 load-path))
(setq load-path (append
                 '("~/config/elisp/python-mode-1.0")
                 load-path))

; (related: smartparen, autopairs, electric pair mode)
(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'ace-jump-mode) ; from melpa
;(setq ace-jump-word-mode-use-query-char nil)
(setq ace-jump-word-mode-use-query-char 't)
(define-key evil-normal-state-map "g" 'ace-jump-mode)
;(define-key evil-normal-state-map "t" 'ace-jump-line-mode)
;(define-key evil-normal-state-map "t" 'ace-jump-word-mode)
(setq ace-jump-mode-move-keys (append "jkluiomhznp,fds.arvecwxqytbg" nil))

;(require 'avy) ; from melpa
;(define-key evil-normal-state-map "t" 'avy-goto-line)
;(define-key evil-normal-state-map "t" 'avy-goto-word-1)


;; The commented stuff below seems to do more harm than good.
; Evil normal emacs commands when in insert state
;(setcdr evil-insert-state-map nil)
;;(define-key evil-insert-state-map "\C-k" 'evil-insert-digraph)
;;(define-key evil-insert-state-map "\C-o" 'evil-execute-in-normal-state)
;;(define-key evil-insert-state-map "\C-r" 'evil-paste-from-register)
;;(define-key evil-insert-state-map "\C-y" 'evil-copy-from-above)
;;(define-key evil-insert-state-map "\C-e" 'evil-copy-from-below)
;;(define-key evil-insert-state-map "\C-n" 'evil-complete-next)
;;(define-key evil-insert-state-map "\C-p" 'evil-complete-previous)
;;(define-key evil-insert-state-map "\C-x\C-n" 'evil-complete-next-line)
;;(define-key evil-insert-state-map "\C-x\C-p" 'evil-complete-previous-line)
;;(define-key evil-insert-state-map "\C-t" 'evil-shift-right-line)
;;(define-key evil-insert-state-map "\C-d" 'evil-shift-left-line)
;;(define-key evil-insert-state-map [delete] 'delete-char)
;(define-key evil-insert-state-map [remap delete-backward-char] 'evil-delete-backward-char-and-join)
;(define-key evil-insert-state-map [escape] 'evil-normal-state)
;(define-key evil-insert-state-map
;  (read-kbd-macro evil-toggle-key) 'evil-emacs-state)
;(define-key evil-insert-state-map [remap newline] 'evil-ret)
;(define-key evil-insert-state-map [remap newline-and-indent] 'evil-ret-and-indent)
; return key in insert mode should indent, too
;(define-key global-map (kbd "RET") 'newline-and-indent)

;; visual line movement
;; source: http://stackoverflow.com/questions/20882935/how-to-move-between-visual-lines-and-move-past-newline-in-evil-mode
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-end-of-line>") 'evil-end-of-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-end-of-line>") 'evil-end-of-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-beginning-of-line>") 'evil-beginning-of-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-beginning-of-line>") 'evil-beginning-of-visual-line)
(evil-redirect-digit-argument evil-motion-state-map "0" 'evil-beginning-of-visual-line)
; Make horizontal movement cross lines
(setq-default evil-cross-lines t)

;; evil visual line mode: can only select whole lines, not visual lines
; does not work...
;(define-key evil-visual-state-map "j" 'evil-next-line)
;(define-key evil-visual-state-map "k" 'evil-previous-line)

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
;(global-set-key  [f9]  (lambda () (interactive)
;						 (desktop-save-in-desktop-dir)
;                         (if compilation-in-progress (kill-compilation))
;                         (run-at-time 0.3 nil 'recompile)))
(global-set-key  [f9]  (lambda () (interactive)
                         (desktop-save-in-desktop-dir)
                         (run-at-time 0.1 nil 'recompile)))
(global-set-key  [f10]  'kill-compilation)
;(global-set-key  [f12]  'add-change-log-entry-other-window)

;(global-set-key  "\C-e" 'bigterm-in-current-directory)
(define-key evil-normal-state-map "\C-e" 'bigterm-in-current-directory)
(define-key evil-visual-state-map "\C-e" 'bigterm-in-current-directory)
(define-key evil-insert-state-map "\C-e" 'bigterm-in-current-directory)

(defun bigterm-in-current-directory ()
  "start a terminal in the current directory"
  (interactive)
  ;(start-process "terminal" nil "~/scripts/bigterm"))
  ; background it to avoid "active processes exist" question when exiting emacs
  (start-process "terminal" nil "bash" "-c" "~/scripts/bigterm" "&"))

(defun point-grep()
  "git grep in a terminal in the current directory"
  (interactive)
  ;;(start-process "terminal" nil "~/scripts/bigterm"))
  ;; background it to avoid "active processes exist" question when exiting emacs
  ;(start-process "terminal" nil "bash" "-c" "~/scripts/bigterm" "&"))
  (compilation-start (concat
                      ;"git grep -nH --color=never -i "
                      "ag -n -i "
                      (thing-at-point 'symbol)
                      " | cat"
                      )
		     'grep-mode))

;(global-set-key "\C-z" 'undo)

; Kleineres Fenster für die Fehlermeldungen
;(setq compilation-window-height 8)

;;setq compile-command '("gmake"))
;;setq compile-command '("gmake" . 4))

;; get rid of compilation window on success
;; source: http://www.bloomington.in.us/~brutt/emacs-c-dev.html [dead link]
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
;(add-to-list 'compilation-error-regexp-alist 'vsim)
; # ** Error: ../../source/core/queue_fifo.vhd(22): (vcom-1195) Cannot find expanded name "work.ram".
;(push '(vsim "^..\\(ERROR\\|WARNING\\|\\*\\* Error\\|\\*\\* Warning\\)[^:]*: \\(\\[[0-9]+\\] \\)?\\(.+\\)(\\([0-9]+\\)):" 3 4)
;      compilation-error-regexp-alist-alist)
;(add-to-list 'compilation-error-regexp-alist 'vsim2)
; # Error in macro ./queue_fifo.do line 22
;(push '(vsim2 "^..Error in macro \\([^ ]+\\) line \\([0-9]+\\)" 1 2)
;      compilation-error-regexp-alist-alist)

; Error: Symbolic name "_clk3" is used but not defined File: /opt/altera9.1/quartus/libraries/megafunctions/altpll.tdf Line: 1376
;(add-to-list 'compilation-error-regexp-alist 'quartus1)
; # Error in macro ./queue_fifo.do line 22
;(push '(quartus1 "^Error.*File: \\([^ ]+\\) Line: \\([0-9]+\\)" 1 2)
;      compilation-error-regexp-alist-alist)
;(push '(quartus1 "File: \\([^ ]+\\) Line: \\([0-9]+\\)" 1 2)
;      compilation-error-regexp-alist-alist)

; fix from https://bugs.launchpad.net/ubuntu/+source/emacs23/+bug/814468
;(add-to-list 'compilation-error-regexp-alist 'gcc_include_fix)
;(push '(gcc_include_fix "^\\(?:In file included\\|                \\) from \
;+\\([^:]+\\):\\([0-9]+\\)\\(?::[0-9]+\\)?[:,]$" 1 2)
;      compilation-error-regexp-alist-alist)

; own fix
;(add-to-list 'compilation-error-regexp-alist 'unresolved_reference2 t)
;(push '(unresolved_reference2 "\\(^obj[^:]+[:]\\)\\([^0-9][^:]+\\)[:]\\([0-9]+\\)[:] first defined here" 2 3)
;      compilation-error-regexp-alist-alist)

; make compile buffer wrap lines
; http://stackoverflow.com/questions/1292936/line-wrapping-within-emacs-compilation-buffer
(defun my-compilation-mode-hook ()
   (setq truncate-lines nil) ;; automatically becomes buffer local
   (set (make-local-variable 'truncate-partial-width-windows) nil))
(add-hook 'compilation-mode-hook 'my-compilation-mode-hook)

; show matching brackets
(show-paren-mode t)

; use % for jumping to matching html tags, if/else, etc.
(require 'evil-matchit)
;(defun evilmi-customize-keybinding ()
;  (evil-define-key 'normal evil-matchit-mode-map
;    "%" 'evilmi-jump-items))
(global-evil-matchit-mode 1)

;(define-key evil-normal-state-map "t" 'evilmi-jump-items)
(define-key evil-normal-state-map "t" 'web-mode-navigate)

; from melpa now
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)

(add-hook 'markdown-mode-hook
          (lambda ()
            (visual-line-mode t)))

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

(defun ines-notab-c-mode ()
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

(defun cura-c-mode ()
  "CuraEngine c coding style"
  (interactive)
  (c++-mode)
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil)
  (c-set-offset 'substatement-open 0)
  (remove-dos-eol)
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

(defun cura-py-mode ()
  "Python with tabs instead of spaces"
  (interactive)
  (python-mode)
  ; indent with tabs only.
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode t)
  (c-set-offset 'substatement-open 0)
  )

(require 'google-c-style)
(defun google-cpp-mode ()
  (interactive)
  (c++-mode)
  (google-set-c-style))

(defun javascript-config ()
  (interactive)
  (javascript-mode)
  (electric-indent-mode)
  (setq tab-width 4))

(require 'web-mode)
(defun my-web-mode ()
  (interactive)
  (web-mode)
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4)
  (setq web-mode-indent-style 4))
(defun my-web-mode-2spc ()
  (interactive)
  (my-web-mode)
  (setq web-mode-markup-indent-offset 2)
  ; (setq web-mode-auto-close-style 2)
)

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . my-web-mode))
(add-to-list 'auto-mode-alist '(".*/frontend/.*\\.html?\\'" . my-web-mode-2spc))

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'auto-mode-alist '(".*/linux.*/.*\\.[ch]$" . linux-c-mode))
(add-to-list 'auto-mode-alist '(".*/git/.*\\.[ch]$" . linux-c-mode))
(add-to-list 'auto-mode-alist '(".*/wesnoth.*\\.cpp$" . wesnoth-c-mode))
(add-to-list 'auto-mode-alist '(".*/wesnoth.*\\.hpp$" . wesnoth-c-mode))
(add-to-list 'auto-mode-alist '(".*/gimp.*/.*\\.[ch]$" . gimp-c-mode))
(add-to-list 'auto-mode-alist '(".*/gtk+.*/.*\\.[ch]$" . gtk-c-mode))
(add-to-list 'auto-mode-alist '(".*\\.mas$" . python-mode))
(add-to-list 'auto-mode-alist '(".*\\.java$" . java-mode))
(add-to-list 'auto-mode-alist '(".*SConstruct$" . python-mode))
(add-to-list 'auto-mode-alist '(".*\\.do$" . tcl-mode))
(add-to-list 'auto-mode-alist '(".*\\.m$" . octave-mode))
(add-to-list 'auto-mode-alist '(".*\\.d$" . c-mode))
(add-to-list 'auto-mode-alist '(".*\\.vhd$" . ines-vhdl-mode))
(add-to-list 'auto-mode-alist '(".*\\.do$" . sh-mode))
(add-to-list 'auto-mode-alist '(".*\\.pde$" . c-mode))
(add-to-list 'auto-mode-alist '(".*\\.ino$" . c-mode))
(add-to-list 'auto-mode-alist '(".*wireshark.*\\.[ch]$" . wireshark-c-mode))
(add-to-list 'auto-mode-alist '(".*/Cura.*\\.py$" . cura-py-mode))
(add-to-list 'auto-mode-alist '(".*/Cura.*\\.h$" . cura-c-mode))
(add-to-list 'auto-mode-alist '(".*/Cura.*\\.cpp" . cura-c-mode))
(add-to-list 'auto-mode-alist '(".*\\.txt$" . markdown-mode))
(add-to-list 'auto-mode-alist '(".*\\.js$" . javascript-config))

;;(setq-default c-electric-flag nil)
;(setq-default c-brace-newlines nil)

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
;(global-font-lock-mode t)
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
;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;(scroll-bar-mode -1)
;(set-scroll-bar-mode 't)
;(toggle-horizontal-scroll-bar -1)
(toggle-scroll-bar -1)

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

; Tabs fuer eclipse java zeugs
(add-hook 'java-mode-hook
  (lambda ()
    (setq indent-tabs-mode t)))

; Ich glaube das ist damit mal ein file.c.bz2 direkt editieren kann
(auto-compression-mode t)

;(global-set-key "\M- " 'pop-global-mark) ; <-- den kann ich mir nicht merken
;(define-key evil-normal-state-map "<" 'pop-global-mark) ; <-- konflikt mit indent command

(column-number-mode t)

; Nützlich für "Search & Replace" in einer Region
(put 'narrow-to-region 'disabled nil)

; indent with spaces, never tabs (for details google "emacs tabs")
(setq-default indent-tabs-mode nil)

;; Enter soll im c-modus auto-indent machen
;(setq viper-auto-indent t)
;(custom-set-variables
; '(viper-auto-indent t))

;; Buffer Wechseln mit Tastatur
; Paket swbuff von: http://perso.wanadoo.fr/david.ponce/more-elisp.html
(require 'swbuff)
; keine internen buffer *scratch* *help* etc. (regex aus doku)
(setq-default swbuff-exclude-buffer-regexps '("^ " "^\*.*\*" "TAGS"))
(define-key evil-normal-state-map "q" 'swbuff-switch-to-next-buffer)
(define-key evil-normal-state-map "Q" 'swbuff-switch-to-previous-buffer)
;(define-key evil-normal-state-map "t" 'evil-record-macro)    ; does not work; but using "q" does work (uncommenting the above)
;(define-key evil-normal-state-map "T" 'evil-execute-macro)   ; same

; TODO: replace swbuff?
;Another vote for iswitchb-mode. It's so immensely useful, and does not seem to be very well known. I set it up like this:
;(setq iswitchb-prompt-newbuffer nil)
;(iswitchb-mode t)

; ido = iswitchb fork + same functionality for finding files
(require 'ido)
(require 'flx-ido)
(ido-mode t)
(setq ido-enable-flex-matching t)

;(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights
(setq ido-enable-flex-matching t)
;(setq ido-use-faces nil)


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
;; (add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
;; (add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
;; (defun ido-sort-mtime ()
;;   (setq ido-temp-list
;;         (sort ido-temp-list
;;               (lambda (a b)
;;                 (let ((ta (nth 5 (file-attributes (concat ido-current-directory a))))
;;                       (tb (nth 5 (file-attributes (concat ido-current-directory b)))))
;;                   (if (= (nth 0 ta) (nth 0 tb))
;;                       (> (nth 1 ta) (nth 1 tb))
;;                     (> (nth 0 ta) (nth 0 tb)))))))
;;   (ido-to-end  ;; move . files to end (again)
;;    (delq nil (mapcar
;;               (lambda (x) (if (string-equal (substring x 0 1) ".") x))
;;               ido-temp-list))))
;
; Updated version from emacs wiki after a couple of years:
(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
(defun ido-sort-mtime ()
  (setq ido-temp-list
        (sort ido-temp-list
              (lambda (a b)
                (time-less-p
                 (sixth (file-attributes (concat ido-current-directory b)))
                 (sixth (file-attributes (concat ido-current-directory a)))))))
  (ido-to-end  ;; move . files to end (again)
   (delq nil (mapcar
              (lambda (x) (and (char-equal (string-to-char x) ?.) x))
              ido-temp-list))))

(setq ido-enable-flex-matching t)
; ignore some build products (they are often more recent than whatever I want to select)
; (setq ido-ignore-files '("\\`CVS/" "\\`#" "\\`.#" "\\`\\.\\./" "\\`\\./"
;                          "\\.o\\'" "\\.os\\'" "\\.so\\'" "\\.pyc\\'"
;                          "\\.elf\\'" "\\.hex\\'"  "\\.dblite\\'" ))
;; ido-ignore-extensions should hopefully replace all of the above

;(define-key evil-normal-state-map "t" 'martin-kill-whole-line)

;(defun martin-kill-whole-line ()
;  (interactive)
;  (viper-beginning-of-line (cons ?d ?d))
;)

;; insert a new comment with space
;(defun martin-insert-comment ()
;  (interactive)
;  (comment-dwim nil)
;  (viper-insert nil))

(global-set-key (kbd "C-;") 'comment-dwim)
(define-key evil-normal-state-map ";" 'comment-dwim)
(define-key evil-visual-state-map ";" 'comment-dwim)


(defun my-jump-to-tag ()
  (interactive)
  (setq last-tags-jump-was-find-tag t)
  (call-interactively 'find-tag))

(define-key evil-normal-state-map (kbd "C-.") 'my-jump-to-tag)
(define-key evil-visual-state-map (kbd "C-.") 'my-jump-to-tag)
(define-key evil-insert-state-map (kbd "C-.") 'my-jump-to-tag)

; Problem:
; M-x tags-search since emacs24 visits every buffer where there is NO match,
;                               destroying my most-recent ido buffer sorting.
;                               (Same for tags-loop-continue.)

(defun my-continue-tag-search ()
  (interactive)
  (if last-tags-jump-was-find-tag
      (progn
        (find-tag nil t)
        (ring-remove find-tag-marker-ring 0))

    (swbuff-start-switching)
    (tags-loop-continue)
    (swbuff-end-switching)))

(defun my-start-tag-grep ()
  (interactive)
  (setq last-tags-jump-was-find-tag nil)
  (swbuff-start-switching)
  (call-interactively 'tags-search (thing-at-point 'symbol))
  (swbuff-end-switching))

(require 'etags)
(defun my-ido-find-tag ()
  "Find a tag using ido"
  (interactive)
  (let ((default (find-tag--default)))
    (save-excursion
      (visit-tags-table-buffer))
    (tags-completion-table)
    (find-tag (ido-completing-read "Tag: " tags-completion-table
                                   nil nil default)))
  )


(define-key evil-normal-state-map "\C-t" 'my-ido-find-tag)
(define-key evil-normal-state-map (kbd "C-.") 'my-ido-find-tag)

(global-set-key "\M-." 'my-jump-to-tag)
(define-key evil-normal-state-map "\M-." 'my-jump-to-tag)
(define-key evil-normal-state-map "," 'my-start-tag-grep)
(global-set-key "\M-," 'my-continue-tag-search)
(define-key evil-normal-state-map "}" 'my-continue-tag-search)
;(global-set-key (kbd "\C-.") 'my-jump-to-tag)
;(define-key evil-normal-state-map ":" 'my-jump-to-tag)

(define-key evil-normal-state-map "*" 'pop-tag-mark)

(define-key evil-normal-state-map "\C-W" 'kill-region)
(define-key evil-insert-state-map "\C-W" 'backward-kill-word)
(define-key evil-normal-state-map "W" 'copy-region-as-kill)
(define-key evil-normal-state-map " " 'set-mark-command)
;(define-key evil-normal-state-map "F" 'pop-global-mark)
(define-key evil-normal-state-map "M" 'delete-other-windows)
;;(define-key evil-normal-state-map "D" 'kill-this-buffer)
(define-key evil-normal-state-map "K" 'kill-this-buffer)
;;(define-key evil-normal-state-map "K" 'bury-buffer)
;;(define-key evil-normal-state-map "P" 'yank-pop)
;;(define-key evil-normal-state-map "ä" 'viper-bol-and-skip-white)
(define-key evil-normal-state-map "v" 'ido-find-file)
(define-key evil-normal-state-map "V" 'ido-switch-buffer)
(define-key evil-normal-state-map (kbd "SPC") 'evil-visual-line)
(define-key evil-visual-state-map (kbd "SPC") 'evil-next-line)
(define-key evil-visual-state-map (kbd "SPC") 'evil-next-line)
;
(define-key evil-normal-state-map "H" 'point-grep)

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

; FIXME: visual rows, when in visual mode!
(defun maxy-some-rows-down ()
  (interactive)
  (evil-next-visual-line)
  ;(evil-scroll-line-down 1)
  (evil-next-visual-line)
  ;(evil-scroll-line-down 1)
  (evil-next-visual-line)
  ;(evil-scroll-line-down 1)
  (evil-next-visual-line)
  (evil-scroll-line-down 4)

 ; (evil-next-visual-line)
 ; (evil-next-visual-line)
 ; (evil-next-visual-line)
  ;(pager-row-down)
  ;(pager-row-down)
  ;(pager-row-down)
  ;(pager-row-down)
  ;(evil-scroll-line-to-center nil)
  ;(back-to-indentation)
  )
(defun maxy-some-rows-up ()
  (interactive)
  (evil-previous-visual-line)
  ;(evil-scroll-line-up 1)
  (evil-previous-visual-line)
  ;(evil-scroll-line-up 1)
  (evil-previous-visual-line)
  ;(evil-scroll-line-up 1)
  (evil-previous-visual-line)
  (evil-scroll-line-up 4)
  ;(pager-row-up)
  ;(pager-row-up)
  ;(pager-row-up)
  ;(pager-row-up)
  ;(evil-scroll-line-to-center nil)
  ;(back-to-indentation)
  )

; pager module doesn't work well with visual-line
;(global-set-key [next] 	   'evil-scroll-down)
;(global-set-key [prior]	   'evil-scroll-up)

; scroll text (cursor fixed)
(global-set-key "\M-k"  'maxy-some-rows-up)
(global-set-key "\M-j"  'maxy-some-rows-down)
(define-key c-mode-base-map "\M-j"  'maxy-some-rows-down)

; speichert liste von zuletzt geoeffneten dateien beim Beenden
(require 'recentf)
(recentf-mode 1)

; info about modifying viper per-mode: http://www.cs.cmu.edu/cgi-bin/info2www?%28viper%29Key%20Bindings
(setq my-python-modifier-map (make-sparse-keymap))
(define-key my-python-modifier-map [backspace] 'py-electric-backspace)
;;(viper-modify-major-mode 'python-mode 'vi-state my-python-modifier-map)
;(viper-modify-major-mode 'python-mode 'insert-state my-python-modifier-map)

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

(global-set-key "\M-l" 'dabbrev-expand) ; windows-tastaturen haben den / nicht in reichweite
(global-set-key "ł" 'dabbrev-expand) ; kinesis AltGr-l

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

(put 'downcase-region 'disabled nil)

;; -----------------------------------------------------------------------------
;; Git support
;; -----------------------------------------------------------------------------
;(load "/usr/share/git-core/emacs/git.el")
;(load "/usr/share/git-core/emacs/vc-git.el")
;(add-to-list 'vc-handled-backends 'GIT)

(require 'git-blame) ; note: modified version of git-blame.el
(define-key evil-normal-state-map "B" 'git-blame-mode)


;(add-to-list 'load-path "~/compile/mo-git-blame")

;(autoload 'mo-git-blame-file "mo-git-blame" nil t)
;(autoload 'mo-git-blame-current "mo-git-blame" nil t)

;Optionally bind keys to these functions, e.g.
;
;(global-set-key [?\C-c ?g ?c] 'mo-git-blame-current)
;(global-set-key [?\C-c ?g ?f] 'mo-git-blame-file)


; http://stackoverflow.com/questions/730751/hiding-m-in-emacs
(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))
(add-hook 'text-mode-hook 'remove-dos-eol)

(defadvice tags-loop-continue (around protect-search-end activate)
  (let ((oldbuf (current-buffer)))
    (unless (ignore-errors ad-do-it t)
      (switch-to-buffer oldbuf)
      (message "No more matches."))))

;; after copy Ctrl+c in X11 apps, you can paste by `yank' in emacs
;(setq select-enable-clipboard t)
;; after mouse selection in X11, you can paste by `yank' in emacs
(setq select-enable-primary t)


; http://www.emacswiki.org/emacs/pabbrev.el
(require 'pabbrev)

(defun pabbrev-suggestions-ido (suggestion-list)
  "Use ido to display menu of all pabbrev suggestions."
  (when suggestion-list
    (pabbrev-suggestions-insert-word pabbrev-expand-previous-word)
    (pabbrev-suggestions-insert-word
     (ido-completing-read "Completions: " (mapcar 'car suggestion-list)))))

(defun pabbrev-suggestions-insert-word (word)
  "Insert word in place of current suggestion, with no attempt to kill pabbrev-buffer."
  (let ((point))
    (save-excursion
      (let ((bounds (pabbrev-bounds-of-thing-at-point)))
	(progn
	  (delete-region (car bounds) (cdr bounds))
	  (insert word)
	  (setq point (point)))))
    (if point
	(goto-char point))))

(fset 'pabbrev-suggestions-goto-buffer 'pabbrev-suggestions-ido)

(global-pabbrev-mode)


;(define-key evil-normal-state-map "\C-u" 'pager-page-up)
;(define-key evil-normal-state-map "\C-d" 'pager-page-down)
(define-key evil-normal-state-map "\C-u" 'evil-scroll-up)
(define-key evil-normal-state-map "\C-d" 'evil-scroll-down)
(define-key evil-normal-state-map "[" 'maxy-some-rows-down) ; kinesis
(define-key evil-normal-state-map "]" 'maxy-some-rows-up) ; kinesis
(define-key evil-normal-state-map "\C-d" 'evil-scroll-down)

; from http://dnquark.com/blog/2012/02/emacs-evil-ecumenicalism/
(defun evil-undefine ()
 (interactive)
 (let (evil-mode-map-alist)
   (call-interactively (key-binding (this-command-keys)))))
; use tab for indentation, not for evil-jump-forward
(define-key evil-normal-state-map (kbd "TAB") 'evil-undefine)

; clash of TAB key (pabbrev vs yasnippet vs python-mode)
(require 'yasnippet) ; installed with M-x list-packages
(define-key yas-keymap (kbd "ħ")   'yas-next-field-or-maybe-expand)
(define-key yas-keymap (kbd "TAB")   'pabbrev-expand-maybe)
(define-key yas-keymap [(tab)]       'pabbrev-expand-maybe)

(defun my-indent-region()
  (interactive)
  ;(call-interactively indent-region)
  (indent-region (mark) (point))
  )
(define-key evil-visual-state-map (kbd "TAB") 'my-indent-region)


; type ';' in normal state to add semicolon (useful if brackets were auto-closed)
(define-key evil-normal-state-map ";" 'my-add-semicolon)
(defun my-add-semicolon()
  (interactive)
  (save-excursion
    (end-of-line)
    (insert ";")))

;(fill-keymap evil-normal-state-map
;            "SPC" 'evil-ace-jump-char-mode
;             "Y" (kbd "y$")
;             "+" 'evil-numbers/inc-at-pt
;             "-" 'evil-numbers/dec-at-pt
;             "SPC" 'evil-ace-jump-char-mode
;             "S-SPC" 'evil-ace-jump-word-mode
;             "C-SPC" 'evil-ace-jump-line-mode
;             "go" 'goto-char
;             "C-t" 'transpose-chars
;             "C-:" 'eval-expression
;             ":" 'evil-repeat-find-char-reverse
;             "gH" 'evil-window-top
;             "gL" 'evil-window-bottom
;             "gM" 'evil-window-middle
;             "H" 'beginning-of-line
;             "L" 'end-of-line
;             )

; visual line movements (instead of typing gj, gk, etc.)
;(define-key evil-motion-state-map "j" #'evil-next-visual-line)
;(define-key evil-motion-state-map "k" #'evil-previous-visual-line)
;(define-key evil-motion-state-map "$" #'evil-end-of-visual-line)
;(define-key evil-motion-state-map "^" #'evil-first-non-blank-of-visual-line)
;(define-key evil-motion-state-map "0" #'evil-beginning-of-visual-line)

; search word at point backwards, but when pressing "n" search forward again
(defun martin-search-word-at-point()
 (interactive)
 (call-interactively 'evil-ex-search-word-backward)
 (setq evil-ex-search-direction 'forward)
 )
(define-key evil-motion-state-map "#" 'martin-search-word-at-point)

; evil should count underscores as part of a word, like vim does
; https://bitbucket.org/lyro/evil/wiki/Home
(modify-syntax-entry ?_ "w")
(add-hook 'c-mode-common-hook #'(lambda () (modify-syntax-entry ?_ "w")))

;#(require 'keyfreq)
;(keyfreq-mode 1)
;(keyfreq-autosave-mode 1)

(require 'helm) ; melpa: helm and helm-swoop
(global-set-key (kbd "M-x") 'helm-M-x)
; try those:
; - helm-for-files  - too much clutter (size, type, path... ido-find-file is better, shows path only if needed)
; - helm-semantic-or-imenu   - jump to local function/variable/method/class
; - helm-multi-swoop-all
; (or just use M-x occur)

(autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
(add-hook 'cmake-mode-hook 'cmake-font-lock-activate)

; Procudes too much commit noise when editing code with broken whitespace...
; (add-hook 'c-mode-hook
;           (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
;
; Better solution: ws-butler package from melpa. (enabled globally through M-x customize)
(require 'ws-butler)


(define-key global-map (kbd "C-z") nil) ; don't ever do "suspend frame"


;; Evil indent after paste
;; Almost (not quite) working. Source: http://comments.gmane.org/gmane.emacs.vim-emulation/2005
(defun get-common-indent-in-region (start end)
  (setq end (copy-marker end))
  (unwind-protect
      (let (indentation)
        (save-excursion
          (goto-char start)
          (or (bolp) (forward-line 1))
          (while (< (point) end)
            (skip-chars-forward " \t")
            (setq indentation
                  (cons (current-column) indentation))
            (forward-line 1)))
        (apply #'min indentation))
    (move-marker end nil)))
(defun my-evil-adjust-indent-after-paste ()
  (interactive)
  (unless (memq last-command
                '(evil-paste-after
                  evil-paste-before))
    (error "Previous command was not a line-wise evil-paste: %s" last-command))
  (let* ((start (evil-get-marker ?\[))
         (end (evil-get-marker ?\]))
         (common (get-common-indent-in-region start end))
         (this
          (save-excursion
            (cond
             ((eq last-command 'evil-paste-after)
              (goto-char end)
              (forward-line 1))
             (t
              (goto-char start)
              (forward-line -1)))
            (skip-chars-forward " \t")
            (current-column))))
    (indent-rigidly start end (- this common))))
(evil-define-command evil-paste-after-adjusting-indent
  (count &optional register yank-handler)
  "Like `evil-paste-before' but adjusts the indent to the current line."
  :suppress-operator t
  (interactive "P<x>")
  (evil-paste-after count register yank-handler)
  ;(my-evil-adjust-indent-after-paste 'before))
  (my-evil-adjust-indent-after-paste))
;(define-key evil-normal-state-map "p" 'evil-paste-after-adjusting-indent)

; indented yank (working; from https://www.emacswiki.org/emacs/AutoIndentation)
(dolist (command '(yank yank-pop))
   (eval `(defadvice ,command (after indent-region activate)
            (and (not current-prefix-arg)
                 (member major-mode '(emacs-lisp-mode lisp-mode
                                                      clojure-mode    scheme-mode
                                                      haskell-mode    ruby-mode
                                                      rspec-mode      python-mode
                                                      c-mode          c++-mode
                                                      objc-mode       latex-mode
                                                      plain-tex-mode))
                 (let ((mark-even-if-inactive transient-mark-mode))
                   (indent-region (region-beginning) (region-end) nil))))))
(define-key evil-normal-state-map "P" 'yank)


(require 'flycheck)
; (add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
;(setq-default flycheck-disabled-checkers
;  (append flycheck-disabled-checkers
;    '(javascript-jshint)))

;;; use eslint with web-mode for jsx files
;(flycheck-add-mode 'javascript-eslint 'web-mode)

;;; customize flycheck temp file prefix
;(setq-default flycheck-temp-prefix ".flycheck")

;;; disable json-jsonlist checking for json files
;(setq-default flycheck-disabled-checkers
;  (append flycheck-disabled-checkers
;    '(json-jsonlist)))

; using evil to search, might as well save with this
; (global-set-key "\C-s" 'save-buffer) ; this hurts searching inside M-x customize etc.
(define-key evil-normal-state-map "\C-s" 'save-buffer)
(define-key evil-visual-state-map "\C-s" 'save-buffer)
(define-key evil-insert-state-map "\C-s" 'save-buffer)

