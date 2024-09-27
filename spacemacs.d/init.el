;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
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

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(lua
     asciidoc
     vimscript
     (python :variables python-backend 'lsp python-lsp-server 'pyright)
     (vue)
     ;; (vue :variables vue-backend 'lsp)
     ;; (python :variables python-backend 'lsp python-lsp-server 'mspyls)
     ;; (python :variables python-backend 'lsp python-lsp-server 'pylsp)
     ;; (python :variables
     ;;         python-backend 'lsp
     ;;         python-lsp-server 'mspyls
     ;;         python-lsp-git-root "~/dev/python/python-language-server")
     ;; (python :variables
     ;;         python-backend 'lsp
     ;;         python-lsp-server 'pylsp)
     csv
     emacs-lisp
     fsharp
     kotlin
     nginx
     (csharp :variables csharp-backend 'lsp)
     ansible
     systemd
     yaml
     (typescript :variables
                 typescript-fmt-tool 'prettier
                 typescript-linter 'eslint
                 typescript-backend 'lsp
                 ;; typescript-fmt-on-save t
                 ;; default: 'tide
                 )
     gpu
     rust
     ;; not using the auto-completion layer because it rebinds <tab> in too many places, clashing with dabbrev-expand, and generally produces too much noise
     ;; (auto-completion :variables
     ;;                  auto-completion-enable-sort-by-usage t
     ;;                  ;auto-completion-enable-help-tooltip nil
     ;;                  ;auto-completion-enable-snippets-in-popup nil
     ;;                  ;;auto-completion-private-snippets-directory "~/.spacemacs.d/snippets")

     ;;                  ;; ;; https://github.com/syl20bnr/spacemacs/tree/master/layers/%2Bcompletion/auto-completion#auto-complete
     ;;                  ;; ;; I want to confirm the pabbrev-expand suggestion with TAB, always.
     ;;                  ;; ;; The autocomplete suggestion can still be confirmed with RET.
     ;;                  ;; ;; (TODO: if there is only a single auto-complete, the displayed suggestion clashes with dabbrev-expand)
     ;;                  auto-completion-tab-key-behavior nil
     ;;                  )
     ivy
     better-defaults
     git
     markdown
     shell-scripts  ;; enables shellcheck
     org
     neotree  ;; the new default is treemacs, which I wasn't able to get used to
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     ;; spell-checking
     (syntax-checking :variables
                      ;; rather annoying to see a tooltip about "missing ;" every time you pause typing
                      syntax-checking-enable-tooltips nil
                      )
     version-control
     colors
     ;; (colors :variables colors-enable-nyan-cat-progress-bar t) ;; no, no, no.

     ;; https://develop.spacemacs.org/layers/+lang/c-c++/README.html#rtags
     (c-c++ :variables
            ;; c-c++-backend 'rtags  ;; old, proven, fast
            c-c++-backend 'lsp-clangd  ;; memory-hungry, requires clangd >=9 to work well
            ;; c-c++-backend 'lsp-ccls  ;; okay-ish
            c-c++-enable-google-style t
            c-c++-enable-google-newline t
            ;; c-c++-enable-clang-format-on-save t  ;; maybe! (manually: SPC m = =)
            )

     (html :variables
           css-enable-lsp 't
           less-enable-lsp 't
           scss-enable-lsp 't
           html-enable-lsp 't
           )
     ;; javascript
     (javascript :variables
                 javascript-backend 'lsp
                 javascript-fmt-tool 'prettier
                 )
     tern
     ;; c++-rtags ;; git clone https://github.com/kzemek/cpp-rtags-layer ~/.emacs.d/private/c++-rtags

                                        ;react
                                        ;restclient
     ;; lsp  ;; breaks my typescript workflow
     ;; (cmake :variables cmake-enable-cmake-ide-support t)
     (cmake :variables cmake-enable-cmake-ide-support nil)
     )
   ;; List of additional packages that will be installed without being wrapped
   ;; in a layer (generally the packages are installed only and should still be
   ;; loaded using load/require/use-package in the user-config section below in
   ;; this file). If you need some configuration for these packages, then
   ;; consider creating a layer. You can also put the configuration in
   ;; `dotspacemacs/user-config'. To use a local version of a package, use the
   ;; `:location' property: '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages '(cycbuf
                                      dtrt-indent
                                      devdocs
                                      editorconfig
                                      yasnippet-snippets
                                      auto-yasnippet
                                      company ;; for company-clang-arguments
                                        ;(pabbrev :location (recipe :fetcher file
                                      ;;                           :repo (expand-file-name "~/config/spacemacs.d/patched")))
                                      cmake-mode
                                      ;; qml-mode
                                      ;; protobuf-mode
                                      groovy-mode
                                      sqlite3 ;; just to silence the warning
                                      )
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '(importmagic org-brain)  ;; importmagic uses too much RAM for too little gain
   ;; '(evil-search-highlight-persist)  ;; '(tern)
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."

  ;; https://github.com/emacs-lsp/lsp-pyright/issues/66
  (setq lsp-pyright-multi-root nil)

  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need
   ;; to compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;;
   ;; WARNING: pdumper does not work with Native Compilation, so it's disabled
   ;; regardless of the following setting when native compilation is in effect.
   ;;
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 5

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

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
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "all-the-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons nil

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(
                         sanityinc-tomorrow-night ;; great
                         material  ;; nice, high-contrast, a bit too colorful
                         ;; moe-dark  ;; search hilights are too strong
                         sanityinc-tomorrow-day ;; nice
                         spacemacs-dark ;; just for reference
                         ;; spacemacs-light
                         )


   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("Source Code Pro"
                               :size 17
                               :weight normal
                               :width normal
                               :powerline-scale 1.1)
   ;; (set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab t

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

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

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
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
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' in OSX to obtain
   ;; borderless fullscreen. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers nil

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode t

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'current

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server t

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Show trailing whitespace (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'changed

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
  )

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  ;; Do I need this?
  ;; Fix indentation with < and > via https://www.youtube.com/watch?v=HKF41ivkBb0
                                        ;(setq-default evil-shift-round nil)
  (message "setting patched directory in user-init")
  (push (expand-file-name "~/config/spacemacs.d/patched") load-path)

  (add-hook 'after-init-hook 'global-company-mode)
  ;; hack: this would be defined in the autocomplete layer, which I'm not using, but other spacemacs packages keep calling this when company is installed.
  ;; (company-clang-arguments works either way; just get to rid of the startup errors)
  (defmacro spacemacs|add-company-backends (&rest props))

  ;; just to suppress a warning when opening magit
  (setq forge-add-default-bindings nil)

  (message "end of user-init")
  )

(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
  )

(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."
  ;; may help performance, see bottom of https://github.com/syl20bnr/spacemacs/issues/4207
  (setq shell-file-name "/bin/sh")

  ;; my own customized versions from ./patched/
  (require 'pabbrev)
  (require 'swbuff)

  (setq-default swbuff-exclude-buffer-regexps '("^ " "^\*.*\*" "TAGS" "magit[-:]"))
  (define-key evil-normal-state-map "q" 'swbuff-switch-to-next-buffer)
  (define-key evil-normal-state-map "Q" 'swbuff-switch-to-previous-buffer)
  ;; does not work: (define-key evil-normal-state-map "C-q" 'evil-record-macro)
  ;; or maybe start using "SCP o" for my custom stuff:
  (spacemacs/set-leader-keys "oq" 'evil-record-macro)
  (spacemacs/set-leader-keys "op" 'org-projectile/goto-todos)

  (defun maxy-show-manpage ()
    (interactive)
    (manual-entry (current-word)))
  (spacemacs/set-leader-keys "hm" 'maxy-show-manpage)
  (spacemacs/set-leader-keys "hh" 'devdocs-search)
  (global-set-key [f1] 'maxy-show-manpage)
  (global-set-key [f2] 'devdocs-search)

  ;; from devdocs.el
  (defun maxy-devdocs-do-search (pattern)
    (let ((arg (format "--app=%s/#q=%s" devdocs-url (url-hexify-string pattern))))
      (start-process "chromium devdocs" nil "chromium" "--password-store=basic" arg)
      ))
  (advice-add 'devdocs-do-search :override #'maxy-devdocs-do-search)

  (spacemacs/set-leader-keys "op" 'js2r-log-this)  ;; a bit easier than SPC m r l t


                                        ;(spacemacs/set-leader-keys "og" 'ggtags-find-tag)
  (define-key evil-normal-state-map "Ω" 'evil-record-macro) ;; Shift-@

  ;; keys I don't use: "#+| (AltGr-h,n,z,o,p)~ ←
  ;; HD:

                                        ;(define-key evil-normal-state-map "t" 'evil-visual-line)
  ;; (define-key evil-normal-state-map "t" 'avy-goto-word-or-subword-1)  ;; I'm not using that.
  (define-key evil-normal-state-map (kbd "<backspace>") 'evil-visual-line)
                                        ;(define-key evil-visual-state-map (kbd "<backspace>") 'evil-previous-line)
  (define-key evil-visual-state-map (kbd "<backspace>") 'evil-visual-line)
                                        ;(define-key evil-visual-line-map (kbd "v") 'er/expand-region)
                                        ;(define-key evil-normal-state-map (kbd "v") 'er/expand-region)
  ;; use SPC v instead

  (with-eval-after-load 'evil-iedit-state
    (define-key evil-iedit-state-map (kbd "p") 'iedit-prev-occurrence)
    )

  ;; (wishlist: also ignore __pycache__ and GTAGS etc.)
  ;; (wishlist2: I shouldn't have to configure this.)
  (setq counsel-find-file-ignore-regexp
        (concat
         ;; File names beginning with # or .
         "\\(?:\\`[#.]\\)"
         ;; File names ending with # or ~
         "\\|\\(?:\\`.+?[#~]\\'\\)"))

                                        ;(define-key evil-normal-state-map "v" 'ido-find-file)
                                        ;(define-key evil-normal-state-map "V" 'ido-switch-buffer)

  ;; similar to https://github.com/abo-abo/swiper/wiki/Sort-files-by-mtime
  (defun compare-files-by-date (f1 f2)
    (time-less-p
     (nth 5 (file-attributes f2))
     (nth 5 (file-attributes f1))))

                                        ;(define-key evil-normal-state-map "M" 'evil-record-macro)
  (define-key evil-normal-state-map "M" 'delete-other-windows)
  (define-key evil-normal-state-map "K" 'kill-this-buffer)
                                        ;(define-key evil-normal-state-map "K" 'bury-buffer)
  ;;(define-key evil-normal-state-map "D" 'kill-this-buffer)
  (define-key evil-normal-state-map "W" 'copy-region-as-kill)

  ;; old stuff from old config
                                        ;(global-set-key "\M-." 'my-jump-to-tag)
                                        ;(define-key evil-normal-state-map "\M-." 'my-jump-to-tag)
                                        ;(define-key evil-normal-state-map "," 'my-start-tag-grep)
                                        ;(global-set-key "\M-," 'my-continue-tag-search)
                                        ;(define-key evil-normal-state-map "}" 'my-continue-tag-search)
                                        ;(define-key evil-normal-state-map "*" 'pop-tag-mark) -- * is bound to something useful now

                                        ;(define-key evil-normal-state-map "v" 'ido-find-file)
                                        ;(define-key evil-normal-state-map "V" 'ido-switch-buffer)

  ;;;; Those two I used a long time (on 'v' and 'V' originally):
  (define-key evil-normal-state-map "F" 'counsel-projectile) ;; great but slow (two seconds without projectile-enable-caching) ;; (minor usability issue: shows large backup-copy folder with non-git files before the git files)
  ;; (define-key evil-normal-state-map "V" 'counsel-projectile)  ;; I'm prefering V for "visual-line" now (vim default)
  (define-key evil-normal-state-map "t" 'counsel-projectile)
  (define-key evil-normal-state-map "T" 'projectile-find-file-dwim)  ;; a bit faster than counsel-projectile, and a bit lower quality (it only spends time in sorting by mtime, if enabled I guess, not in file-truename; but still too slow)
  (define-key evil-normal-state-map "\C-t" 'lsp-ivy-workspace-symbol)
  ;; (define-key evil-normal-state-map "z" 'ivy-switch-buffer)
  (define-key evil-normal-state-map "z" 'counsel-buffer-or-recentf)

                                        ;(define-key evil-normal-state-map "v" 'counsel-projectile-switch-to-buffer) ;; grep-like interface
                                        ;(define-key evil-normal-state-map "v" 'ivy-switch-buffer) ;; fast (SPC b b) but I also want to switch to any project file
                                        ;(define-key evil-normal-state-map "v" 'counsel-projectile-find-file) ;; a bit slow (one second)
  ;; (define-key evil-normal-state-map "v" 'counsel-projectile)
                                        ;(define-key evil-normal-state-map "v" 'projectile-switch-to-buffer) ;; fast, but project-only (too limited, but still better than mixing projects)
  ;; (define-key evil-normal-state-map "v" 'counsel-find-file) ;; great (now that it's sorted by mtime again)
  ;; (define-key evil-normal-state-map "v" 'projectile-find-file)
                                        ;(define-key evil-normal-state-map "V" 'helm-mini)
  ;; (define-key evil-normal-state-map ":" 'spacemacs/helm-gtags-maybe-dwim)

  ;; experimental: use rg to get the list of project files (faster)
  ;; based on https://github.com/kaushalmodi/.emacs.d/blob/master/general.el#L102
  ;; and https://github.com/kaushalmodi/.emacs.d/blob/master/setup-files/setup-projectile.el#L79
                                        ;
  ;; Moved to customize: projectile-git-command (calls rg instead of git)

  ;; Make the file list creation faster by NOT calling `projectile-get-sub-projects-files'
  (defun maxy/advice-projectile-no-sub-project-files ()
    "Directly call `projectile-get-ext-command'. No need to try to get a list of sub-project files if the vcs is git."
    (projectile-files-via-ext-command (projectile-get-ext-command)))
  (advice-add 'projectile-get-repo-files :override
              #'maxy/advice-projectile-no-sub-project-files)
  ;; Do not visit the current project's tags table if `ggtags-mode' is loaded.
  ;; Doing so prevents the unnecessary call to `visit-tags-table' function
  ;; and the subsequent `find-file' call for the `TAGS' file."
  (defun maxy/advice-projectile-dont-visit-tags-table () nil)
  (when (fboundp 'ggtags-mode)
    (advice-add 'projectile-visit-project-tags-table :override
                #'maxy/advice-projectile-dont-visit-tags-table))

  ;; ;(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ;; rebind tab to run persistent action
  ;; ;(define-key helm-map (kbd "ł") 'helm-execute-persistent-action) ;; make TAB work in terminal
  ;; (define-key helm-map (kbd "ħ")  'helm-next-source)
  ;; (define-key helm-map (kbd "[")  'helm-next-line)
  ;; (define-key helm-map (kbd "]")  'helm-previous-line)
  ;; (define-key helm-read-file-map (kbd "ħ")  'helm-find-files-up-one-level)
  ;; (define-key helm-find-files-map (kbd "ħ")  'helm-find-files-up-one-level)


  ;; from https://github.com/syl20bnr/spacemacs/issues/6097
  ;; use this with dotspacemacs-smooth-scrolling nil
  (setq scroll-conservatively 101
        scroll-margin 8
        scroll-preserve-screen-position 't)

  ;; ivy-find-file should not open "dired" when hitting RET on a directory
  (define-key ivy-minibuffer-map (kbd "RET") 'ivy-alt-done)

                                        ;(global-set-key  "\C-e" 'bigterm-in-current-directory)
  (define-key evil-normal-state-map "\C-e" 'bigterm-in-current-directory)
  (define-key evil-visual-state-map "\C-e" 'bigterm-in-current-directory)
  (define-key evil-insert-state-map "\C-e" 'bigterm-in-current-directory)
  (defun bigterm-in-current-directory ()
    "start a terminal in the current directory"
    (interactive)
                                        ;(start-process "terminal" nil "~/scripts/bigterm"))
    ;; background it to avoid "active processes exist" question when exiting emacs
    ;; (start-process "terminal" nil "bash" "-c" "~/scripts/bigterm" "&")) ;; cargo missing from $PATH
    ;; (start-process "terminal" nil "~/scripts/bigterm")) ;; cargo missing from $PATH
    (start-process "terminal" nil "konsole")) ;; $PATH okay

  ;; Uralte Gewohnheiten aus Borland-Produkten
  (global-set-key  [f4]  'next-error)
  (global-set-key  [(shift f4)]  'previous-error)

  (defun last-error () ;; useful when coding python (go to end of traceback)
    (interactive)
    (with-current-buffer next-error-last-buffer
      (setq compilation-current-error (point-max)))
    (previous-error))
  (global-set-key  [f5]  'last-error)
  (global-set-key  [f8]  'compile)
  (global-set-key  [f9]  'recompile)
  (global-set-key  (kbd "C-b")  'recompile)
                                        ;(global-set-key  [f9]  (lambda () (interactive) (desktop-save-in-desktop-dir) (run-at-time 0.1 nil 'recompile)))
  (global-set-key  [f10]  'kill-compilation)
  (define-key evil-normal-state-map "\C-b" 'recompile)
  (define-key evil-visual-state-map "\C-b" 'recompile)
  (define-key evil-insert-state-map "\C-b" 'recompile)

  ;; Ctrl-S is "save file", not swiper-search
  (define-key evil-normal-state-map "\C-s" 'save-buffer)
  (define-key evil-visual-state-map "\C-s" 'save-buffer)
  (define-key evil-insert-state-map "\C-s" 'save-buffer)

  ;; Ctrl-F is swiper search, not evil-scroll-page-down
  (define-key evil-normal-state-map "\C-f" 'swiper)
  (define-key evil-normal-state-map "/" 'swiper)
  (define-key evil-normal-state-map "\C-j" 'spacemacs/jump-to-definition)

  ;; move lines around (source: https://github.com/syl20bnr/spacemacs/issues/5365#issuecomment-192973053)
  ;; TODO: there is dotspacemacs-visual-line-move-text -- just enable that instead?
  (define-key evil-visual-state-map "J"
              (concat ":m '>+1" (kbd "RET") "gv=gv"))
  (define-key evil-visual-state-map "K"
              (concat ":m '<-2" (kbd "RET") "gv=gv"))

  (define-key evil-visual-state-map (kbd "<tab>")
              'indent-region)

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

  ;; completion
  (global-set-key "\M-l" 'dabbrev-expand)
  (global-set-key "ł" 'dabbrev-expand) ;; kinesis AltGr-l
  ;; Undo html layer emmet-mode configuration: dabbrev-expand is already showing autocompletions for me, often more accurate than emmet-mode. When I press tab I want those completions, just like in every other buffer.
  (remove-hook 'css-mode-hook 'emmet-mode)
  (remove-hook 'html-mode-hook 'emmet-mode)
  (remove-hook 'sass-mode-hook 'emmet-mode)
  (remove-hook 'scss-mode-hook 'emmet-mode)
  (remove-hook 'web-mode-hook 'emmet-mode)
  ;; this was not quite working:
  ;; (advice-add 'spacemacs/emmet-expand :override #'dabbrev-expand)
  ;; (advice-add 'spacemacs/emmet-expand :override #'pabbrev-expand-maybe)
  ;; (advice-add 'emmet-expand :override #'pabbrev-expand-maybe)  ;; TAB key in html-mode

  ;; to have lsp in .svelte buffers
  ;; spacemacs//setup-lsp-for-html-buffer enables this only for .html
  (add-hook 'web-mode-hook #'lsp t)

  (defun noop () (interactive))

  ;; org-mode should not override tab in insert-mode
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "<tab>") nil))
  ;; override spacemacs hook: orgtbl steals my <tab> key
  (with-eval-after-load 'markdown-mode
    (remove-hook 'markdown-mode-hook 'orgtbl-mode))

  (with-eval-after-load 'company
    ;; the tab key belongs to me, damn it!
    (define-key company-active-map (kbd "TAB") nil)
    (define-key company-active-map (kbd "<tab>") nil)

    (delete 'company-dabbrev company-backends)
    ;; (delete 'company-files company-backends) ;; way too slow in $HOME
    )
  ;; (with-eval-after-load 'core-auto-completion
  ;;   (delete 'company-files spacemacs-default-company-backends)
  ;;   )


  ;; (setq spacemacs-default-jump-handlers
  ;;       (remove 'evil-goto-definition spacemacs-default-jump-handlers))

  ;; (require 'qml-mode)
  ;; (require 'protobuf-mode)

  (require 'yasnippet)
  (yas-global-mode 1)
  (define-key yas-minor-mode-map [(tab)]        nil)
  ;; (define-key yas-minor-mode-map (kbd "TAB")    nil)
  (define-key yas-minor-mode-map (kbd "<tab>")  nil)
  (define-key yas-minor-mode-map (kbd "<C-return>") 'yas-expand)
  (define-key yas-keymap (kbd "<tab>") 'pabbrev-expand-maybe)
  (define-key yas-keymap (kbd "<C-return>") 'yas-next-field)
  (define-key yas-keymap (kbd "<return>") 'yas-next-field)

  (define-key evil-insert-state-map (kbd "<C-tab>") 'pabbrev-expand-maybe)

  (define-key evil-normal-state-map (kbd "<C-tab>") 'projectile-find-other-file)
  (define-key evil-normal-state-map (kbd "<C-tab>") 'projectile-find-other-file)
  (spacemacs/set-leader-keys "ph" 'projectile-find-other-file)  ;; there is already test/impl: SPC p a

  (define-key evil-motion-state-map "B" 'magit-blame-addition)

  ;; pager module doesn't work well with visual-line
                                        ;(global-set-key [next] 'evil-scroll-down)
                                        ;(global-set-key [prior] 'evil-scroll-up)
  ;; scroll text (cursor fixed)
  (global-set-key "\M-k"  'maxy-some-rows-up)
  (global-set-key "\M-j"  'maxy-some-rows-down)
                                        ;(define-key c-mode-base-map "\M-j"  'maxy-some-rows-down)
  ;; Scrolling (Kinesis: Alt jk mapped to [])
  (define-key evil-normal-state-map "[" 'maxy-some-rows-down) ;; not working?!
  (define-key evil-normal-state-map "]" 'maxy-some-rows-up) ;; not working?!
                                        ;(define-key evil-normal-state-map "J" 'maxy-some-rows-down)
                                        ;(define-key evil-normal-state-map "K" 'maxy-some-rows-up)

  ;; type ';' in normal state to add semicolon (useful if brackets were auto-closed)
  (define-key evil-normal-state-map ";" 'my-add-semicolon)
  (defun my-add-semicolon()
    (interactive)
    (save-excursion
      (end-of-line)
      (insert ";")))

  (define-key evil-visual-state-map ";" 'evilnc-comment-operator)  ;; should learn using C-/ instead;
  (define-key evil-visual-state-map (kbd "C-/") 'evilnc-comment-operator)
  (define-key evil-normal-state-map (kbd "C-/") 'comment-line)  ;; note: this mapping breaks undo, unless the workaround below is used
  ;; workaround for non-working workaround in undo-tree.el to allow binding C-/

  ;; (require 'undo-tree)
  (defun my-undo-tree-overridden-undo-bindings-p ()  ;; from undo-tree.el (modified)
    (let ((binding2 (lookup-key (current-global-map) [?\C-_])))
      (global-set-key [?\C-_] 'undo)
      (unwind-protect
          (and (key-binding [?\C-_])
               (not (eq (key-binding [?\C-_]) 'undo)))
        (global-set-key [?\C-_] binding2))))
  (advice-add 'undo-tree-overridden-undo-bindings-p :override #'my-undo-tree-overridden-undo-bindings-p)

  (setq-default spacemacs-show-trailing-whitespace nil)

  ;; navigate snake_case as whole word
  (add-hook 'c-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))

  (define-key spacemacs-web-mode-map "," 'spacemacs/web-mode-transient-state/body)
  ;; (set-frame-font "-Misc-Fixed-Medium-R-Normal--20-200-75-75-C-100-ISO8859-1")

  ;; show the filepath in the frame title
  ;; http://emacsredux.com/blog/2013/04/07/display-visited-files-path-in-the-frame-title/
  (setq frame-title-format
        '((:eval (if (buffer-file-name)
                     (abbreviate-file-name (buffer-file-name))
                   "%b"))))

  ;; get rid of compilation window on success
  ;; source: http://www.bloomington.in.us/~brutt/emacs-c-dev.html [dead link]
  ;; (setq compilation-finish-function
  ;;       (lambda (buf str)
  ;;         (if (string-match "exited abnormally" str)
  ;;             ;;there were errors
  ;;             ;(message "compilation errors, press C-x ` to visit")
  ;;             (message "ERRORs while compiling.")
  ;;           ;;no errors, make the compilation window go away in 0.5 seconds
  ;;           (run-at-time 0.5 nil 'delete-windows-on buf)
  ;;           (message "Compilation done."))))

  (global-hl-line-mode -1) ;; Disable current line highlight

  ;; after copy Ctrl+c in X11 apps, you can paste by `yank' in emacs
                                        ;(setq select-enable-clipboard t)
  (setq select-enable-primary t)
  ;; fix pasting over visual selection, see https://github.com/syl20bnr/spacemacs/issues/4685#issuecomment-278076373
  (fset 'evil-visual-update-x-selection 'ignore)

  (defun my-json-mode-hook ()
    (setq js-indent-level 4)
    (setq tab-width 4)
                                        ;    (prettier-js-mode 't)
    (dtrt-indent-mode 't))
  (add-hook 'json-mode-hook 'my-json-mode-hook)

  (editorconfig-mode 1)

  ;; use the current project's eslint binary
  ;; source: https://emacs.stackexchange.com/a/21207/12292
  (defun my/use-linter-from-node-modules ()
    (let* ((root (locate-dominating-file
                  (or (buffer-file-name) default-directory)
                  "node_modules"))
           (eslint (and root
                        (expand-file-name "node_modules/eslint/bin/eslint.js"
                                          root)))
           (tslint (and root
                        (expand-file-name "node_modules/tslint/bin/tslint"
                                          root))))
      (when (and eslint (file-executable-p eslint))
        (setq-local flycheck-javascript-eslint-executable eslint))
      (when (and tslint (file-executable-p tslint))
        (setq-local flycheck-typescript-tslint-executable tslint))))
  (add-hook 'flycheck-mode-hook #'my/use-linter-from-node-modules)

  ;; some javascript stuff picked from https://github.com/redguardtoo/emacs.d/blob/master/lisp/init-javascript.el
  (setq-default js2-strict-trailing-comma-warning nil ;; it's encouraged to use trailing comma in ES6
                js2-idle-timer-delay 0.5 ;; NOT too big for real time syntax check
                js2-skip-preprocessor-directives t
                js2-strict-inconsistent-return-warning nil) ;; return <=> return null

  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  (global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)
  (global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)

  ;; treat the underscores (snake_case) as part of the word
  (with-eval-after-load 'evil
    (defalias #'forward-evil-word #'forward-evil-symbol))

  (with-eval-after-load 'ivy
    ;; "patch" until https://github.com/abo-abo/swiper/issues/2492 has an upstream solution
    (defun ivy-occur-next-error (n &optional reset)
      "A `next-error-function' for `ivy-occur-mode'."
      (interactive "p")
      (when reset
        (goto-char (point-min)))
      (setq n (or n 1))
      (let ((ivy-calling t))
        (cond ((< n 0) (ivy-occur-previous-line (- n)))
              (t (ivy-occur-next-line n))))
      ;; the window's point overrides the buffer's point every time it's redisplayed
      (cl-dolist (window (get-buffer-window-list nil nil t))
        (set-window-point window (point))))

    ;; I'm missing some previous hydra heads
    (defhydra+ hydra-ivy (:hint nil :color pink)
      ;; based on ivy-hydra-20200608.1010/ivy-hydra.el
      "
^ ^ ^ ^ ^ ^ | ^Call^      ^ ^  | ^Cancel^ | ^Options^ | Action _w_/_s_/_a_: %-14s(ivy-action-name)
^-^-^-^-^-^-+-^-^---------^-^--+-^-^------+-^-^-------+-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^---------------------------
^ ^ _k_ ^ ^ | _f_ollow _o_ccur | _i_nsert | _c_: calling %-5s(if ivy-calling \"on\" \"off\") _C_ase-fold: %-10`ivy-case-fold-search
_h_ ^+^ _l_ | _d_one      ^ ^  | _o_ops   | _M_: matcher %-5s(ivy--matcher-desc)^^^^^^^^^^^^ _T_runcate: %-11`truncate-lines
^ ^ _j_ ^ ^ | _g_o        ^ ^  | ^ ^      | _<_/_>_: shrink/grow^^^^^^^^^^^^^^^^^^^^^^^^^^^^ _D_efinition of this menu
"
      ("o" ivy-occur :exit t)
      ("l" ivy-call)
      )
    )


  ;; https://www.emacswiki.org/emacs/IndentingC
  (c-add-style "double-class-indent"
               '("k&r"
                 (c-basic-offset . 4)
                 (c-offsets-alist
                  (inclass . ++)
                  (access-label . -))))
  ;; source: https://raw.githubusercontent.com/google/styleguide/gh-pages/google-c-style.el
  ;; Wrapper function needed for Emacs 21 and XEmacs (Emacs 22 offers the more
  ;; elegant solution of composing a list of lineup functions or quantities with
  ;; operators such as "add")
  (defun google-c-lineup-expression-plus-4 (langelem)
    "Indents to the beginning of the current C expression plus 4 spaces.

This implements title \"Function Declarations and Definitions\"
of the Google C++ Style Guide for the case where the previous
line ends with an open parenthese.

\"Current C expression\", as per the Google Style Guide and as
clarified by subsequent discussions, means the whole expression
regardless of the number of nested parentheses, but excluding
non-expression material such as \"if(\" and \"for(\" control
structures.

Suitable for inclusion in `c-offsets-alist'."
    (save-excursion
      (back-to-indentation)
      ;; Go to beginning of *previous* line:
      (c-backward-syntactic-ws)
      (back-to-indentation)
      (cond
       ;; We are making a reasonable assumption that if there is a control
       ;; structure to indent past, it has to be at the beginning of the line.
       ((looking-at "\\(\\(if\\|for\\|while\\)\\s *(\\)")
        (goto-char (match-end 1)))
       ;; For constructor initializer lists, the reference point for line-up is
       ;; the token after the initial colon.
       ((looking-at ":\\s *")
        (goto-char (match-end 0))))
      (vector (+ 4 (current-column)))))



  (c-add-style "google"
               ;; source: https://stackoverflow.com/questions/13825188/suppress-c-namespace-indentation-in-emacs
               '("k&r"
                 (c-basic-offset . 2)
                 (c-offsets-alist
                  (arglist-intro google-c-lineup-expression-plus-4)
                  (func-decl-cont . ++)
                  (member-init-intro . ++)
                  (inher-intro . ++)
                  (comment-intro . 0)
                  (arglist-close . c-lineup-arglist)
                  (topmost-intro . 0)
                  (block-open . 0)
                  (inline-open . 0)
                  (substatement-open . 0)
                  (statement-cont . ++)
                  (label . /)
                  (case-label . +)
                  (statement-case-open . +)
                  (statement-case-intro . +) ;; case w/o {
                  (access-label . /)
                  (innamespace . 0))))

  ;; (setq c-default-style "double-class-indent")
  (setq c-default-style "google")

  ;; requires: https://github.com/Andersbakken/rtags
  ;; (require 'rtags)

  (define-key evil-normal-state-map (kbd "M-.") 'spacemacs/jump-to-definition)
  (define-key evil-visual-state-map (kbd "M-.") 'spacemacs/jump-to-definition)
  (define-key evil-insert-state-map (kbd "M-.") 'spacemacs/jump-to-definition)
  (define-key evil-normal-state-map (kbd "C-.") 'spacemacs/jump-to-definition)
  (define-key evil-visual-state-map (kbd "C-.") 'spacemacs/jump-to-definition)
  (define-key evil-insert-state-map (kbd "C-.") 'spacemacs/jump-to-definition)
  (define-key evil-normal-state-map (kbd "C-,") 'spacemacs/jump-to-definition)
  (define-key evil-visual-state-map (kbd "C-,") 'spacemacs/jump-to-definition)
  (define-key evil-insert-state-map (kbd "C-,") 'spacemacs/jump-to-definition)
  ;; (define-key evil-normal-state-map (kbd "M-,") 'rtags-find-references-at-point)
  ;; (define-key evil-visual-state-map (kbd "M-,") 'rtags-find-references-at-point)
  ;; (define-key evil-insert-state-map (kbd "M-,") 'rtags-find-references-at-point)

  (define-key evil-normal-state-map (kbd "C-p") 'evil-jump-forward)
  (define-key evil-normal-state-map (kbd "C--" )'evil-jump-backward)


  (with-eval-after-load 'rtags
    ;; (spacemacs/set-leader-keys "og" 'ggtags-find-definition)
    ;; (spacemacs/set-leader-keys "od" 'ggtags-find-tag-dwim)
    ;; (define-key evil-normal-state-map (kbd "M-.") 'rtags-find-symbol-at-point)
    ;; (define-key evil-visual-state-map (kbd "M-.") 'rtags-find-symbol-at-point)
    ;; (define-key evil-insert-state-map (kbd "M-.") 'rtags-find-symbol-at-point)
    (define-key evil-normal-state-map (kbd "M-,") 'rtags-find-references-at-point)
    (define-key evil-visual-state-map (kbd "M-,") 'rtags-find-references-at-point)
    (define-key evil-insert-state-map (kbd "M-,") 'rtags-find-references-at-point)

    (define-key evil-normal-state-map (kbd ":") 'rtags-find-symbol-at-point)

    (define-key c-mode-base-map (kbd "M-<left>")
                (function xref-pop-marker-stack))
    (define-key c-mode-base-map (kbd "M-<right>")
                (function xref-push-marker-stack))

    ;; the customized rtags-periodic-reparse-timeout gets reset for some reason
    ;; (rtags-set-periodic-reparse-timeout 1.5)

    ;; rtags and eldoc, source:
    ;; https://github.com/Andersbakken/rtags/issues/987
    (defun fontify-string (str mode)
      "Return STR fontified according to MODE."
      (with-temp-buffer
        (insert str)
        (delay-mode-hooks (funcall mode))
        (font-lock-default-function mode)
        (font-lock-default-fontify-region
         (point-min) (point-max) nil)
        (buffer-string)))
    (defun rtags-eldoc-function ()
      (let ((summary (rtags-get-summary-text)))
        (and summary
             (fontify-string
              (replace-regexp-in-string
               "{[^}]*$" ""
               (mapconcat
                (lambda (str) (if (= 0 (length str)) "//" (string-trim str)))
                (split-string summary "\r?\n")
                " "))
              major-mode))))
    (defun rtags-eldoc-mode ()
      (interactive)
      (setq-local eldoc-documentation-function #'rtags-eldoc-function)
      (eldoc-mode 1))
    )

  (add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
  ;; (add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))
  ;; (add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))

  ;; not sure why those aren't there by default
  (add-to-list 'spacemacs-jump-handlers-c++-mode '(rtags-find-symbol-at-point :async t))
  (add-to-list 'spacemacs-jump-handlers-c-mode '(rtags-find-symbol-at-point :async t))

  ;; (add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))
  ;; (add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))

  ;; (require 'lsp-mode)
  ;; (add-hook 'c++-mode-hook #'lsp)

  ;; The config below doesn't work in new emacs versions due to some flycheck macro expansion stuff:
                                        ;
  ;; GCC has no way of suppressing the "#pragma once in main file" warning,
  ;; and flycheck has no (non-internal) way to ignore some errors.
  ;; (with-eval-after-load "flycheck"
  ;;   (eval-when-compile (require 'flycheck))  ;; for flycheck-error struct
  ;;   (defun my-filter-pragma-once-in-main (orig-fun errors)
  ;;     (dolist (err errors)
  ;;       (-when-let (msg (flycheck-error-message err))
  ;;         (setf (flycheck-error-message err)
  ;;               (if (string-match-p "#pragma once in main file" msg) nil msg))))
  ;;     (funcall orig-fun errors))
  ;;   (advice-add 'flycheck-sanitize-errors :around #'my-filter-pragma-once-in-main))

  ;; same for clang
  ;; (with-eval-after-load 'flycheck
  ;;   (setq flycheck-clang-warnings `(,@flycheck-clang-warnings
  ;;                                   "no-pragma-once-outside-header")))
  ;; maybe helps against hangups, https://github.com/proofit404/anaconda-mode/issues/169
  (setq url-http-attempt-keepalives nil)


  ;; http://trey-jackson.blogspot.com/2010/04/emacs-tip-36-abort-minibuffer-when.html
  (defun stop-using-minibuffer ()
    "kill the minibuffer"
    (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
      (abort-recursive-edit)))
  (add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

  (defun remove-dos-eol ()
    "Do not show ^M in files containing mixed UNIX and DOS line endings."
    (interactive)
    (setq buffer-display-table (make-display-table))
    (aset buffer-display-table ?\^M []))
  (add-hook 'csharp-mode-hook 'remove-dos-eol)

  ;; https://github.com/emacs-lsp/lsp-mode/wiki/Install-Angular-Language-server
  (setq lsp-clients-angular-language-server-command
        '("node"
          "/home/martin/.local/lib/node_modules/@angular/language-server"
          "--ngProbeLocations"
          "/home/martin/.local/lib/node_modules"
          "--tsProbeLocations"
          "/home/martin/.local/lib/node_modules"
          "--stdio"))
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
  (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(ansi-color-faces-vector
     [default bold shadow italic underline bold bold-italic bold])
   '(ansi-color-names-vector
     ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
   '(browse-url-browser-function 'browse-url-firefox)
   '(company-dabbrev-downcase nil)
   '(company-dabbrev-ignore-case nil)
   '(compilation-ask-about-save nil)
   '(create-lockfiles nil)
   '(custom-safe-themes
     '("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default))
   '(cycbuf-buffer-sort-function 'cycbuf-sort-by-recency)
   '(cycbuf-dont-show-regexp '("^ " "^\\*cycbuf\\*$" "^\\*.*\\*$" "TAGS"))
   '(cycbuf-max-window-height 2)
   '(cycbuf-maximal-buffer-name-column 30)
   '(cycbuf-maximal-file-name-column 20)
   '(cycbuf-minimal-buffer-name-column 20)
   '(cycbuf-minimal-file-name-column 8)
   '(dabbrev-case-replace nil)
   '(delete-trailing-lines nil)
   '(dumb-jump-confirm-jump-to-modified-file nil)
   '(evil-ex-search-persistent-highlight nil)
   '(evil-repeat-move-cursor nil)
   '(evil-surround-pairs-alist
     '((40 "(" . ")")
       (91 "[" . "]")
       (123 "{" . "}")
       (41 "(" . ")")
       (93 "[" . "]")
       (125 "{" . "}")
       (35 "#{" . "}")
       (98 "(" . ")")
       (66 "{" . "}")
       (62 "<" . ">")
       (116 . evil-surround-read-tag)
       (60 . evil-surround-read-tag)
       (102 . evil-surround-function)))
   '(evil-want-Y-yank-to-eol nil)
   '(fci-rule-color "#37474f")
   '(flycheck-json-python-json-executable "python3")
   '(flycheck-python-flake8-executable "python3")
   '(flycheck-python-pycompile-executable "python3")
   '(flycheck-python-pylint-executable "python3")
   '(git-commit-fill-column 72)
   '(global-pabbrev-mode t)
   '(global-whitespace-mode t)
   '(hl-sexp-background-color "#1c1f26")
   '(ivy-extra-directories nil)
   '(ivy-sort-functions-alist
     '((read-file-name-internal . compare-files-by-date)
       (internal-complete-buffer)
       (counsel-git-grep-function)
       (Man-goto-section)
       (org-refile)
       (t)))
   '(js2-strict-missing-semi-warning nil)
   '(js2-strict-trailing-comma-warning nil)
   '(lsp-eldoc-enable-hover nil)
   '(lsp-file-watch-threshold 10000)
   '(lsp-prefer-flymake nil)
   '(lsp-pyright-python-executable-cmd "python3")
   '(lsp-restart 'ignore)
   '(lsp-rust-analyzer-cargo-watch-args ["--target-dir" "target/check-rustanalyzer"])
   '(lsp-rust-analyzer-server-display-inlay-hints t)
   '(lsp-rust-server 'rust-analyzer)
   '(lsp-signature-auto-activate nil)
   '(lsp-ui-doc-enable nil)
   '(lsp-ui-sideline-delay 0.8)
   '(magit-diff-refine-hunk t)
   '(magit-diff-refine-ignore-whitespace nil)
   '(magit-revision-show-gravatars nil t)
   '(magit-save-repository-buffers 'dontask)
   '(magit-section-initial-visibility-alist '((stashes . hide) (untracked . hide)))
   '(markdown-indent-function 'noop)
   '(mouse-yank-at-point t)
   '(pabbrev-idle-timer-verbose nil)
   '(package-selected-packages
     '(svelte-mode magit-svn json-navigator hierarchy yapfify ws-butler winum which-key wgrep web-mode web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package unfill toml-mode toc-org tide tern tagedit symon string-inflection spaceline-all-the-icons smex smeargle slim-mode scss-mode sass-mode restart-emacs request realgud rainbow-mode rainbow-identifiers rainbow-delimiters racer pyvenv pytest pyenv-mode py-isort pug-mode popwin pippel pipenv pip-requirements persp-mode pcre2el password-generator paradox overseer orgit org-projectile org-present org-pomodoro org-mime org-download org-bullets org-brain open-junk-file neotree nameless mwim move-text mmm-mode material-theme markdown-toc magit-gitflow macrostep lorem-ipsum livid-mode live-py-mode linum-relative link-hint less-css-mode json-mode js2-refactor js-doc ivy-xref ivy-rtags ivy-purpose ivy-hydra indent-guide importmagic impatient-mode hy-mode hungry-delete hl-todo highlight-parentheses highlight-numbers highlight-indentation helm-make google-translate google-c-style golden-ratio gnuplot gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link git-gutter-fringe git-gutter-fringe+ gh-md ggtags font-lock+ flycheck-rust flycheck-rtags flycheck-pos-tip flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-org evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-exchange evil-escape evil-ediff evil-cleverparens evil-args evil-anzu eval-sexp-fu emmet-mode elisp-slime-nav editorconfig dumb-jump dtrt-indent disaster diminish diff-hl devdocs define-word cython-mode cycbuf counsel-projectile counsel-gtags counsel-css column-enforce-mode color-theme-sanityinc-tomorrow color-identifiers-mode coffee-mode clean-aindent-mode clang-format centered-cursor-mode cargo browse-at-remote auto-highlight-symbol auto-compile anaconda-mode aggressive-indent adaptive-wrap ace-window ace-link))
   '(projectile-completion-system 'ido)
   '(projectile-enable-caching nil)
   '(projectile-git-command "rg --files --null")
   '(projectile-globally-ignored-buffers '("TAGS" "*anaconda-mode*" "GTAGS" "GRTAGS" "GPATH"))
   '(projectile-globally-ignored-directories
     '(".idea" ".ensime_cache" ".eunit" ".git" ".hg" ".fslckout" "_FOSSIL_" ".bzr" "_darcs" ".tox" ".svn" ".stack-work" "bower_components" "node_packages" ".pyc" "__pycache__"))
   '(projectile-globally-ignored-files '("TAGS" "GTAGS" "GRTAGS" "GPATH"))
   '(projectile-other-file-alist
     '(("cpp" "h" "hpp" "ipp")
       ("ipp" "h" "hpp" "cpp")
       ("hpp" "h" "ipp" "cpp" "cc")
       ("cxx" "h" "hxx" "ixx")
       ("ixx" "h" "hxx" "cxx")
       ("hxx" "h" "ixx" "cxx")
       ("c" "h")
       ("m" "h")
       ("mm" "h")
       ("h" "c" "cc" "cpp" "ipp" "hpp" "cxx" "ixx" "hxx" "m" "mm")
       ("cc" "h" "hh" "hpp")
       ("hh" "cc")
       ("vert" "frag")
       ("frag" "vert")
       (nil "lock" "gpg")
       ("lock" "")
       ("gpg" "")
       ("html" "css" "scss" "js" "ts")
       ("ts" "html")
       ("js" "html")
       ("component.ts" "component.html")
       ("component.css" "component.html")
       ("component.scss" "component.html")
       ("component.spec.ts" "component.ts")
       ("component.html" "component.spec.ts" "component.css" "component.scss" "component.js" "component.ts")))
   '(py-shell-name "python3")
   '(python-shell-interpreter "python3")
   '(rtags-path "/home/martin/.local/bin/")
   '(rust-format-on-save t)
   '(rustic-ansi-faces
     ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
   '(rustic-format-trigger 'on-save)
   '(rustic-rustfmt-args "fmt")
   '(rustic-rustfmt-bin "cargo")
   '(safe-local-variable-values
     '((cmake-ide-project-dir . "/home/martin/code/pixelcrawl")
       (cmake-ide-build-dir . "/home/martin/code/pixelcrawl/build-dbg")
       (eval progn
             (add-to-list 'exec-path
                          (concat
                           (locate-dominating-file default-directory ".dir-locals.el")
                           "node_modules/.bin/")))))
   '(sp-escape-quotes-after-insert nil)
   '(sp-escape-wrapped-region nil)
   '(swbuff-clear-delay 20)
   '(swbuff-clear-delay-ends-switching t)
   '(swbuff-separator "  ")
   '(swbuff-status-window-layout 'adjust)
   '(swbuff-window-min-text-height 2)
   '(tab-width 4)
   '(tramp-mode nil)
   '(vc-annotate-background nil)
   '(vc-annotate-color-map
     '((20 . "#f36c60")
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
       (360 . "#8bc34a")))
   '(vc-annotate-very-old-color nil)
   '(warning-suppress-log-types '((lsp-mode) (comp)))
   '(warning-suppress-types '((lsp-mode) (comp)))
   '(web-mode-auto-close-style 2)
   '(whitespace-style
     '(face tabs space-before-tab::tab space-before-tab tab-mark))
   '(yas-snippet-dirs
     '("~/.spacemacs.d/snippets" "/home/martin/.emacs.d/snippets" yasnippet-snippets-dir)))
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
   '(ahs-plugin-defalt-face ((t (:background "#3b3735" :foreground "Orange1"))) t)
   '(ahs-plugin-whole-buffer-face ((t (:background "#3b3735"))))
   '(avy-lead-face ((t (:foreground "orange"))))
   '(avy-lead-face-0 ((t (:foreground "yellow"))))
   '(avy-lead-face-1 ((t (:foreground "orange"))))
   '(avy-lead-face-2 ((t (:foreground "orange"))))
   '(company-tooltip-common ((t (:inherit company-tooltip :underline nil :weight bold))))
   '(company-tooltip-common-selection ((t (:inherit company-tooltip-selection :underline nil :weight bold))))
   '(cycbuf-current-face ((t (:background "dim gray" :weight bold))))
   '(cycbuf-header-face ((t (:foreground "yellow" :weight bold))))
   '(cycbuf-uniquify-face ((t (:foreground "dodger blue"))))
   '(diff-refine-added ((t (:background "#134019" :foreground "nil"))))
   '(diff-refine-removed ((t (:background "#442a18" :foreground "nil"))))
   '(escape-glyph ((t (:foreground "dim gray"))))
   '(evil-ex-lazy-highlight ((t (:inherit lazy-highlight))))
   '(flx-highlight-face ((t (:inherit font-lock-variable-name-face :weight bold))))
   '(flycheck-error ((t (:underline (:color "#af1010" :style wave)))))
   '(flycheck-fringe-error ((t (:foreground "#E05555"))))
   '(flycheck-fringe-info ((t (:foreground "#404040"))))
   '(flycheck-fringe-warning ((t (:foreground "#784600"))))
   '(flycheck-info ((t (:underline (:color "#505050" :style wave)))))
   '(flycheck-warning ((t (:underline (:color "#9f5c00" :style wave)))))
   '(ggtags-highlight ((t nil)))
   '(highlight-parentheses-highlight ((nil (:weight ultra-bold))) t)
   '(ido-first-match ((t (:weight bold))))
   '(ido-subdir ((t (:foreground "#729FCF"))))
   '(isearch ((t (:background "#3b3735" :foreground "#EAF46F" :inverse-video nil))))
   '(isearch-fail ((t (:inherit font-lock-warning-face :inverse-video nil))))
   '(ivy-current-match ((t (:inherit highlight :foreground "#b5bd68" :underline nil))))
   '(lazy-highlight ((t (:background "#3b3735" :foreground "nil" :inverse-video nil))))
   '(lsp-lsp-flycheck-warning-unnecessary-face ((t (:foreground "dim gray"))) t)
   '(lsp-ui-sideline-code-action ((t (:inherit success))))
   '(match ((t (:background "#1d1f21" :foreground "#ADD9FF" :inverse-video nil))))
   '(pabbrev-single-suggestion-face ((t (:foreground "gray33"))))
   '(pabbrev-suggestions-face ((t (:foreground "gray25"))))
   '(region ((t (:background "#1D4570"))))
   '(rtags-errline ((t (:background "#321212" :underline (:color "red" :style wave)))))
   '(rtags-fixitline ((t (:background "#303012" :underline (:color "brown" :style wave)))))
   '(rtags-warnline ((t (:foreground "white" :underline (:color "khaki4" :style wave)))))
   '(show-paren-match ((t (:background "#443947" :foreground "#fff"))))
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
   '(whitespace-space-before-tab ((t (:background "nil" :foreground "#666"))))
   '(whitespace-tab ((t (:background "nil" :foreground "grey25"))))
   '(whitespace-trailing ((t (:background "#382A2A")))))
  )
