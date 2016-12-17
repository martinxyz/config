;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     (auto-completion :variables
                      ;auto-completion-enable-help-tooltip nil
                      ;auto-completion-enable-snippets-in-popup nil
                      ;;auto-completion-private-snippets-directory "~/.spacemacs.d/snippets")
                      )
     ivy
     better-defaults
     emacs-lisp
     git
     markdown
     org
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     (syntax-checking :variables
                      ; rather annoying to see a tooltip about "missing ;" every time you pause typing
                      syntax-checking-enable-tooltips nil
                      )
     version-control
     colors
     ; (colors :variables colors-enable-nyan-cat-progress-bar t) ; no, no, no.

     gtags ; does not seem to do any good (because not using helm, maybe)
     c-c++ ; huh, this only adds "disaster" mode and not much else?
     python
     html
     javascript
     ;react
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(swbuff cycbuf dtrt-indent)
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(
                         sanityinc-tomorrow-night ; great
                         material  ; nice, high-contrast, a bit too colorful
                         ; moe-dark  ; search hilights are too strong
                         sanityinc-tomorrow-day ; nice
                         spacemacs-dark ; just for reference
                         ; spacemacs-light
                         )
   ;; If non nil the cursor color matches the state color in GUI Emacs.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   ;; (set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")
   ;; dotspacemacs-default-font '("Misc-Fixed-Medium-R-Normal"
   ;;                             :size 20
   ;;                             :weight normal
   ;;                             :width normal
   ;;                             :powerline-scale 1.0)
   dotspacemacs-default-font '("Source Code Pro"
                               :size 17
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ; (set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ nil
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling nil
   ;; If non nil line numbers are turned on in all `prog-mode' and `text-mode'
   ;; derivatives. If set to `relative', also turns on relative line numbers.
   ;; (default nil)
   dotspacemacs-line-numbers nil
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'current
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'changed
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."

  ;; Do I need this?
  ;; Fix indentation with < and > via https://www.youtube.com/watch?v=HKF41ivkBb0
  ;(setq-default evil-shift-round nil)
  (push (expand-file-name "~/config/spacemacs.d/patched") load-path)
  (message "end of user-init")
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."


  (setq-default swbuff-exclude-buffer-regexps '("^ " "^\*.*\*" "TAGS"))
  (define-key evil-normal-state-map "q" 'swbuff-switch-to-next-buffer)
  (define-key evil-normal-state-map "Q" 'swbuff-switch-to-previous-buffer)
  ; does not work: (define-key evil-normal-state-map "C-q" 'evil-record-macro)
  ; or maybe start using "SCP o" for my custom stuff:
  (spacemacs/set-leader-keys "oq" 'evil-record-macro)
  (spacemacs/set-leader-keys "og" 'ggtags-find-definition)
  (spacemacs/set-leader-keys "od" 'ggtags-find-tag-dwim)
  ; concerning gtags: http://stackoverflow.com/questions/12922526/tags-for-emacs-relationship-between-etags-ebrowse-cscope-gnu-global-and-exub
  ; "use universal ctags (aka exuberant ctags) as a backend for gnu global, e.g. vor vhdl"
  ; TODO: learn using eldoc
  ; old C/C++ habit
  (define-key evil-normal-state-map (kbd "C-.") 'ggtags-find-definition)
  (define-key evil-visual-state-map (kbd "C-.") 'ggtags-find-definition)
  (define-key evil-insert-state-map (kbd "C-.") 'ggtags-find-definition)
  (define-key evil-normal-state-map (kbd "M-.") 'ggtags-find-definition)
  (define-key evil-visual-state-map (kbd "M-.") 'ggtags-find-definition)
  (define-key evil-insert-state-map (kbd "M-.") 'ggtags-find-definition)
  ;(global-set-key "\M-." 'my-jump-to-tag)
  ;(define-key evil-normal-state-map "\M-." 'my-jump-to-tag);

  ;(spacemacs/set-leader-keys "og" 'ggtags-find-tag)
  (define-key evil-normal-state-map "Ω" 'evil-record-macro) ; Shift-@

  ; keys I don't use: "#+| (AltGr-h,n,z,o,p)~ ←
  ; HD:

  ;(define-key evil-normal-state-map "t" 'evil-visual-line)
  (define-key evil-normal-state-map "t" 'avy-goto-word-or-subword-1)
  (define-key evil-normal-state-map (kbd "<backspace>") 'evil-visual-line)
  ;(define-key evil-visual-state-map (kbd "<backspace>") 'evil-previous-line)
  (define-key evil-visual-state-map (kbd "<backspace>") 'evil-visual-char)
  ;(define-key evil-visual-line-map (kbd "v") 'er/expand-region)
  ;(define-key evil-normal-state-map (kbd "v") 'er/expand-region)

  (with-eval-after-load 'evil-iedit-state
    (define-key evil-iedit-state-map (kbd "p") 'iedit-prev-occurrence)
    )

  ;(define-key evil-normal-state-map "v" 'ido-find-file)
  ;(define-key evil-normal-state-map "V" 'ido-switch-buffer)

  (define-key evil-normal-state-map "T" 'cycbuf-switch-to-next-buffer)
  ;(define-key evil-normal-state-map "M" 'evil-record-macro)
  (define-key evil-normal-state-map "M" 'delete-other-windows)
  (define-key evil-normal-state-map "K" 'kill-this-buffer)
  ;(define-key evil-normal-state-map "K" 'bury-buffer)
  ;;(define-key evil-normal-state-map "D" 'kill-this-buffer)
  (define-key evil-normal-state-map "W" 'copy-region-as-kill)

  ; old stuff from old config
  ;(global-set-key "\M-." 'my-jump-to-tag)
  ;(define-key evil-normal-state-map "\M-." 'my-jump-to-tag)
  ;(define-key evil-normal-state-map "," 'my-start-tag-grep)
  ;(global-set-key "\M-," 'my-continue-tag-search)
  ;(define-key evil-normal-state-map "}" 'my-continue-tag-search)
  ;(define-key evil-normal-state-map "*" 'pop-tag-mark) -- * is bound to something useful now

  ;(define-key evil-normal-state-map "v" 'ido-find-file)
  ;(define-key evil-normal-state-map "V" 'ido-switch-buffer)
  (define-key evil-normal-state-map "v" 'counsel-find-file)
  (define-key evil-normal-state-map "V" 'ivy-switch-buffer)

  ; from https://github.com/syl20bnr/spacemacs/issues/6097
  ; use this with dotspacemacs-smooth-scrolling nil
  (setq scroll-conservatively 101
        scroll-margin 8
        scroll-preserve-screen-position 't)

  ; ivy-find-file should not open "dired" when hitting RET on a directory
  (define-key ivy-minibuffer-map (kbd "RET") 'ivy-alt-done)

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

  ;; Uralte Gewohnheiten aus Borland-Produkten
  (global-set-key  [f4]  'next-error)
  (global-set-key  [(shift f4)]  'previous-error)

  (defun last-error () ; useful when coding python (go to end of traceback)
    (interactive)
    (with-current-buffer next-error-last-buffer
      (setq compilation-current-error (point-max)))
    (previous-error))
  (global-set-key  [f5]  'last-error)
  (global-set-key  [f8]  'compile)
  (global-set-key  [f9]  'recompile)
  ;(global-set-key  [f9]  (lambda () (interactive) (desktop-save-in-desktop-dir) (run-at-time 0.1 nil 'recompile)))
  (global-set-key  [f10]  'kill-compilation)

  ; Ctrl-S is "save file", not swiper-search
  (define-key evil-normal-state-map "\C-s" 'save-buffer)
  (define-key evil-visual-state-map "\C-s" 'save-buffer)
  (define-key evil-insert-state-map "\C-s" 'save-buffer)

  ; Ctrl-F is swiper-search, not evil-scroll-page-down
  (define-key evil-normal-state-map "\C-f" 'swiper-search)

  (defun maxy-some-rows-down ()
    (interactive)
    (evil-next-visual-line)
    (evil-next-visual-line)
    (evil-next-visual-line)
    (evil-next-visual-line)
    (evil-scroll-line-down 4)
    ;(pager-row-down)
    ;(evil-scroll-line-to-center nil)
    ;(back-to-indentation)
    )
  (defun maxy-some-rows-up ()
    (interactive)
    (evil-previous-visual-line)
    (evil-previous-visual-line)
    (evil-previous-visual-line)
    (evil-previous-visual-line)
    (evil-scroll-line-up 4)
    )

  ; completion
  (global-set-key "\M-l" 'dabbrev-expand)
  (global-set-key "ł" 'dabbrev-expand) ; kinesis AltGr-l

  ; pager module doesn't work well with visual-line
  ;(global-set-key [next] 'evil-scroll-down)
  ;(global-set-key [prior] 'evil-scroll-up)
  ; scroll text (cursor fixed)
  (global-set-key "\M-k"  'maxy-some-rows-up)
  (global-set-key "\M-j"  'maxy-some-rows-down)
  ;(define-key c-mode-base-map "\M-j"  'maxy-some-rows-down)
  ; Scrolling (Kinesis: Alt jk mapped to [])
  (define-key evil-normal-state-map "[" 'maxy-some-rows-down) ; not working?!
  (define-key evil-normal-state-map "]" 'maxy-some-rows-up) ; not working?!
  ;(define-key evil-normal-state-map "J" 'maxy-some-rows-down)
  ;(define-key evil-normal-state-map "K" 'maxy-some-rows-up)

  ; type ';' in normal state to add semicolon (useful if brackets were auto-closed)
  (define-key evil-normal-state-map ";" 'my-add-semicolon)
  (defun my-add-semicolon()
    (interactive)
    (save-excursion
      (end-of-line)
      (insert ";")))

  (setq-default spacemacs-show-trailing-whitespace nil)

  ; navigate snake_case as whole word
  (add-hook 'c-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

  ;(spacemacs/set-leader-keys "d" 'helm-mini)
  ;(spacemacs/set-leader-keys "os" 'ag-project)

  ; was: spacemacs/search-project-auto
  (spacemacs/set-leader-keys "/" 'counsel-git-grep)

  ; (set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")

  ;; show the filepath in the frame title
  ;; http://emacsredux.com/blog/2013/04/07/display-visited-files-path-in-the-frame-title/
  (setq frame-title-format
        '((:eval (if (buffer-file-name)
                     (abbreviate-file-name (buffer-file-name))
                   "%b"))))

  ;; http://stackoverflow.com/questions/898401/how-to-get-focus-follows-mouse-over-buffers-in-emacs
  (setq mouse-autoselect-window t)

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

  (global-hl-line-mode -1) ; Disable current line highlight

  ;; after copy Ctrl+c in X11 apps, you can paste by `yank' in emacs
  ;(setq select-enable-clipboard t)
  (setq select-enable-primary t)

  ;(delete 'company-dabbrev company-backends)
  ;(delete 'company-files company-backends) ; way too slow in $HOMe

  (with-eval-after-load 'core-auto-completion
    ; way too when showing $HOME
    (delete 'company-files spacemacs-default-company-backends)
    )

  ; (with-eval-after-load 'company
  ; (add-to-list 'company-backends 'company-elm))

  ; (add-to-list 'custom-theme-load-path (expand-file-name "~/config/spacemacs.d"))

  ; from http://blog.binchen.org/posts/easy-indentation-setup-in-emacs-for-web-development.html
  ;(defun my-setup-indent (n)
  ;  ;; java/c/c++
  ;  (setq-local c-basic-offset n)
  ;  ;; web development
  ;  (setq-local coffee-tab-width n) ; coffeescript
  ;  (setq-local javascript-indent-level n) ; javascript-mode
  ;  (setq-local js-indent-level n) ; js-mode
  ;  (setq-local js2-basic-offset n) ; js2-mode, in latest js2-mode, it's alias of js-indent-level
  ;  (setq-local web-mode-markup-indent-offset n) ; web-mode, html tag in html file
  ;  (setq-local web-mode-css-indent-offset n) ; web-mode, css in html file
  ;  (setq-local web-mode-code-indent-offset n) ; web-mode, js code in html file
  ;  (setq-local css-indent-offset n) ; css-mode
  ;  )

  ; watch https://github.com/syl20bnr/spacemacs/issues/3203 for updates
  (add-hook 'prog-mode-hook #'(lambda ()
                                (dtrt-indent-mode)
                                (dtrt-indent-adapt)))
  ; sadly dtrt-indent does not work with web-mode, see https://github.com/jscheid/dtrt-indent/issues/28
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(cycbuf-dont-show-regexp (quote ("^ " "^\\*cycbuf\\*$" "^\\*.*\\*$" "TAGS")))
 '(cycbuf-max-window-height 10)
 '(cycbuf-maximal-buffer-name-column 30)
 '(cycbuf-maximal-file-name-column 30)
 '(cycbuf-minimal-buffer-name-column 10)
 '(cycbuf-minimal-file-name-column 10)
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#37474f" t)
 '(global-whitespace-mode t)
 '(hl-sexp-background-color "#1c1f26")
 '(ivy-sort-functions-alist
   (quote
    ((read-file-name-internal . ivy--sort-files-by-date)
     (internal-complete-buffer)
     (counsel-git-grep-function)
     (Man-goto-section)
     (org-refile)
     (t . string-lessp))))
 '(mouse-yank-at-point t)
 '(package-selected-packages
   (quote
    (dtrt-indent pcache company-quickhelp color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow ggtags disaster company-c-headers cmake-mode clang-format powerline spinner ivy-purpose window-purpose imenu-list hydra parent-mode hide-comnt flx evil goto-chg highlight diminish pkg-info epl bind-map bind-key packed avy popup package-build cycbuf swbuff helm-pydoc helm-gitignore helm-css-scss helm-company helm-c-yasnippet anzu iedit smartparens undo-tree helm helm-core projectile async f dash s material-theme pug-mode yapfify web-mode web-beautify tagedit slim-mode scss-mode sass-mode rainbow-mode rainbow-identifiers pyvenv pytest pyenv-mode py-isort pip-requirements mwim livid-mode skewer-mode simple-httpd live-py-mode less-css-mode json-mode json-snatcher json-reformat js2-refactor multiple-cursors js2-mode js-doc jade-mode hy-mode haml-mode git-gutter-fringe+ git-gutter-fringe fringe-helper git-gutter+ git-gutter emmet-mode diff-hl cython-mode company-web web-completion-data company-tern dash-functional tern company-anaconda color-identifiers-mode coffee-mode anaconda-mode pythonic smeargle orgit org-projectile org-present org org-pomodoro alert log4e gntp org-download mmm-mode markdown-toc markdown-mode magit-gitflow htmlize gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md flycheck-pos-tip pos-tip flycheck evil-magit magit magit-popup git-commit with-editor company-statistics company auto-yasnippet yasnippet ac-ispell auto-complete wgrep smex ivy-hydra counsel-projectile counsel swiper ivy ws-butler window-numbering which-key volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spacemacs-theme spaceline restart-emacs request rainbow-delimiters quelpa popwin persp-mode pcre2el paradox org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint info+ indent-guide ido-vertical-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation help-fns+ helm-themes helm-swoop helm-projectile helm-mode-manager helm-make helm-flx helm-descbinds helm-ag google-translate golden-ratio flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-args evil-anzu eval-sexp-fu elisp-slime-nav dumb-jump define-word column-enforce-mode clean-aindent-mode auto-highlight-symbol auto-compile aggressive-indent adaptive-wrap ace-window ace-link ace-jump-helm-line)))
 '(swbuff-clear-delay 20)
 '(swbuff-clear-delay-ends-switching t)
 '(swbuff-separator "  ")
 '(swbuff-window-min-text-height 2)
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#f36c60")
     (40 . "#ff9800")
     (60 . "#fff59d")
     (80 . "#8bc34a")
     (100 . "#81d4fa")
     (120 . "#4dd0e1")
     (140 . "#b39ddb")
     (160 . "#f36c60")
     (180 . "#ff9800")
     (200 . "#fff59d")
     (220 . "#8bc34a")
     (240 . "#81d4fa")
     (260 . "#4dd0e1")
     (280 . "#b39ddb")
     (300 . "#f36c60")
     (320 . "#ff9800")
     (340 . "#fff59d")
     (360 . "#8bc34a"))))
 '(vc-annotate-very-old-color nil)
 '(whitespace-style
   (quote
    (face tabs space-before-tab::tab space-before-tab tab-mark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-completion-face ((t (:foreground "darkgray"))))
 '(ace-jump-face-foreground ((t (:foreground "white smoke" :underline nil))))
 '(ahs-definition-face ((t (:background "#3b3735"))))
 '(ahs-edit-mode-face ((t (:background "#3b3735" :foreground "Coral3"))))
 '(ahs-face ((t (:background "#3b3735"))))
 '(ahs-plugin-bod-face ((t (:background "#3b3735" :foreground "DodgerBlue"))))
 '(ahs-plugin-defalt-face ((t (:background "#3b3735" :foreground "Orange1"))))
 '(ahs-plugin-whole-buffer-face ((t (:background "#3b3735" :foreground "GreenYellow"))))
 '(avy-lead-face ((t (:foreground "orange"))))
 '(avy-lead-face-0 ((t (:foreground "yellow"))))
 '(avy-lead-face-1 ((t (:foreground "orange"))))
 '(avy-lead-face-2 ((t (:foreground "orange"))))
 '(cycbuf-current-face ((t (:background "dim gray" :weight bold))))
 '(cycbuf-header-face ((t (:foreground "yellow" :weight bold))))
 '(cycbuf-uniquify-face ((t (:foreground "dodger blue"))))
 '(evil-ex-lazy-highlight ((t (:inherit lazy-highlight))))
 '(flx-highlight-face ((t (:inherit font-lock-variable-name-face :weight bold))))
 '(flycheck-error ((t (:underline (:color "#af1010" :style wave)))))
 '(flycheck-fringe-error ((t (:foreground "#E05555"))))
 '(flycheck-fringe-info ((t (:foreground "#404040"))))
 '(flycheck-fringe-warning ((t (:foreground "#784600"))))
 '(flycheck-info ((t (:underline (:color "#505050" :style wave)))))
 '(flycheck-warning ((t (:underline (:color "#9f5c00" :style wave)))))
 '(ggtags-highlight ((t nil)))
 '(ido-first-match ((t (:weight bold))))
 '(ido-subdir ((t (:foreground "#729FCF"))))
 '(isearch ((t (:background "#3b3735" :foreground "#EAF46F" :inverse-video nil :weight bold))))
 '(isearch-fail ((t (:inherit font-lock-warning-face :inverse-video nil))))
 '(lazy-highlight ((t (:background "#3b3735" :foreground "nil" :inverse-video nil))))
 '(pabbrev-single-suggestion-face ((t (:foreground "gray33"))))
 '(pabbrev-suggestions-face ((t (:foreground "gray25"))))
 '(region ((t (:background "#1D4570"))))
 '(smerge-base ((t (:background "#21210c"))))
 '(smerge-lower ((t (:background "#142114"))))
 '(smerge-markers ((t (:foreground "gray60"))))
 '(smerge-refined-added ((t (:inherit smerge-refined-change :background "#105210"))))
 '(smerge-refined-removed ((t (:inherit smerge-refined-change :background "#521010"))))
 '(smerge-upper ((t (:background "#211414"))))
 '(swbuff-current-buffer-face ((t (:background "#37474F" :foreground "yellow" :weight bold))))
 '(viper-minibuffer-emacs ((t nil)))
 '(viper-minibuffer-insert ((t nil)))
 '(whitespace-big-indent ((t (:background "OrangeRed4"))))
 '(whitespace-empty ((t (:background "#503030"))))
 '(whitespace-space ((t (:background "grey10" :foreground "gray20"))))
 '(whitespace-tab ((t (:foreground "grey25"))))
 '(whitespace-trailing ((t (:background "#382A2A")))))
