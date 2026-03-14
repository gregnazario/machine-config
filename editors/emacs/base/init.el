;;; Doom Emacs Configuration
;;; Base configuration for all operating systems
;;; https://github.com/doomemacs/doomemacs

;; Doom core settings
(doom! :completion
       ;; company              ; the ultimate code completion backend
       ;; ivy                  ; a search engine for the 21st century
       vertico               ; the search engine of the future

       :ui
       ;; doom                 ; what makes DOOM Emacs the greatest editor ever
       doom-dashboard        ; a nifty splash screen for Emacs
       doom-quit             ; DOOM quit message prompts
       ;;(emoji +unicode)     ; 🙂
       hl-todo               ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       ;; hydra                ; quick-access key bindings menu
       ;; indent-guides         ; highlighted indent columns
       ligatures             ; ligatures and symbols to make it pretty
       minimap               ; show a map of the code on the side
       modeline              ; snazzy, inspired-by VSCode modeline
       nav-flash             ; blink cursor line after big motions
       neotree               ; a project drawer, like NERDTree
       ophitos               ; highlight the region an operation acts on
       (popup +defaults)     ; tame sudden yet inevitable popups
       tabs                  ; a tab bar for Emacs
       treemacs              ; a project drawer, like neotree
       ;; unicode              ; extended unicode support for various languages
       vc-gutter             ; vcs diff in the fringe
       vi-tilde-fringe       ; fringe tildes to mark beyond EOB
       window-select         ; visually switch windows
       workspaces            ; tab emulation, persistence & separate workspaces
       zen                   ; distraction-free coding or writing

       :editor
       (evil +everywhere); come to the dark side, we have cookies
       file-templates       ; auto-snippet templates for new files
       fold                  ; (nearly) all you need to fold code
       (format +onsave)      ; automated prettiness
       ;; god                  ; run Emacs commands without modifier keys
       snippets             ; my elves. They type so I don't have to
       word-wrap             ; soft wrapping with language-aware indent

       :emacs
       (dired +icons)        ; making dired pretty [functional]
       electric              ; smarter, keyword-based electric-indent
       (ibuffer +icons)      ; interactive buffer management
       undo                  ; persistent, smarter undo for your accidental mistakes
       vc                    ; version-control and Emacs, sitting in a tree

       :term
       eshell                ; the elisp shell that works everywhere
       ;;shell                ; simple shell REPL for Emacs
       ;;term                 ; basic terminal emulator for Emacs
       vterm                 ; the best terminal emulation in Emacs

       :checkers
       syntax                ; tasing you for every semicolon you miss
       spell                 ; tasing you for misspelling misspelling
       grammar               ; tasing grammar mistake every you make

       :tools
       ;; ansible
       ;; biblio
       ;; debugger             ; FIXME stepping through code, to help you add bugs
       direnv
       docker
       ;; editorconfig          ; let someone else maintain your coding style
       ;; ein                  ; tame Jupyter notebooks with emacs
       (eval +overlay)        ; run code, run (also, repls)
       ;; gist                 ; interacting with github gists
       lookup                ; navigate your code and its documentation
       (lsp +eglot)          ; M-x vscode
       magit                 ; a git porcelain for Emacs
       ;; make                 ; run make tasks from Emacs
       ;; pass                 ; password manager for nerds
       pdf                    ; pdf improvements
       ;; prodigy               ; FIXME managing external tasks & how they run
       ;; rgb                   ; creating color palettes
       ;; taskrunner            ; FIXME taskrunner for all your projects
       ;; terraform             ; infrastructure as code
       ;; tmux                 ; an api for your terminal
       tree-sitter            ; syntax and parsing, sitting in a tree
       upload                ; map local to remote projects via ssh/ftp

       :lang
       ;;agda                 ; types of types based on types of types
       ;;beancount            ; mind the GAAP
       (cc +lsp)             ; C/C++/Obj-C with a clang
       ;;clojure              ; JVM with the clojure(s)
       ;;common-lisp          ; the best Lisp (that's not Emacs Lisp)
       ;;coq                  ; proofs-as-programs
       ;;data                  ; config/data formats
       ;;(dart +flutter)       ; paint ui and not much else
       ;;dhall
       ;;(elixir +lsp)         ; erlang done right
       ;;(elm +lsp)            ; care for a cup of tea?
       emacs-lisp            ; drown in parentheses
       ;;erlang               ; an Erlang runtime in Emacs
       ess                   ; emacs speaks statistics
       ;;fsharp               ; ML stands for Meta-Language, you know
       ;;fstar                ; (dependent) types and (monadic) effects and Z3
       (gdscript +lsp)       ; the language you waited for
       ;;(go +lsp)             ; The hipster languages
       ;;(graphql +lsp)        ; Give queries a REST
       ;;(haskell +lsp)        ; a language that's lazier than you
       ;;hy                   ; readability of scheme w/ speed of python
       ;;idris                ; a language you can depend on
       json                  ; At least it ain't XML
       (java +lsp)           ; the poster child for metal hair problems
       ;;javascript           ; all(hope(abandon(ye(who(enter(here))))))
       ;;julia                ; MATLAB: finally the C of the 21st century
       ;;kotlin               ; a better, slicker Java(Script)
       (latex +cdlatex)      ; writing papers in Emacs has never been so fun
       ;;lean                 ; for folks with too much to prove
       ;;ledger               ; be audit you can be
       ;;lua                  ; one-based indices? one-based indices
       markdown              ; writing docs for people to ignore
       ;;nim                  ; python + lisp at the speed of c
       ;;nix                  ; I hereby declare "nix goes away"
       ;;ocaml                ; an objective camel
       (org +roam2 +dragndrop +present +gnuplot +hugo)  ; organize your plain life in plain text
       ;;php                  ; perl's insecure younger brother
       ;;plantuml             ; diagrams for confused people
       ;;purescript           ; javascript, but functional
       (python +lsp +pyright) ; beautiful is better than ugly
       ;;qt                   ; the 'cutest' gui framework ever
       ;;racket               ; a DSL for DSLs
       ;;raku                 ; the artist formerly known as perl6
       ;;rest                  ; Emacs as a REST client
       ;;rst                  ; ReST in peace
       ;;(ruby +rails)         ; 1.step {|x| x.next}; _ = 1st
       ;;rust                 ; Fe2O3 = 2Fe1.5O
       ;;scala                ; java, but better
       (scheme +guile)       ; a fully configurable programming environment
       (sh +fish)            ; she sells {ba,z,fi}shells on the xor
       ;;sly                  ; the best SBCL repl
       ;; solidity             ; do you need a blockchain? No.
       ;;swift                ; who asked for apple icloud support?
       ;;terra                ; Earth and other planets
       ;;web                  ; the tubes
       yaml                  ; JSON, but readable
       ;;zig                  ; C, but simpler

       :email
       ;;(mu4e +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       :app
       ;; calendar
       ;; emms
       ;; everywhere          ; *leave* Emacs!? What blasphemy?!
       ;; irc                  ; how neckbeards socialize
       ;;(rss +org)            ; emacs as an RSS reader

       :config
       (default +bindings +smartparet)
       literate
       (private +doom))  ; Private configuration

;; === User Configuration ===

;; Identify
(setq user-full-name "Greg")
(setq user-mail-address "greg@example.com")

;; Theme
(setq doom-theme 'doom-dracula)

;; Font
(setq doom-font (font-spec :family "JetBrains Mono" :size 12 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 12)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24))

;; Line numbers
(setq display-line-numbers-type t)
(setq display-line-numbers-want 'relative)

;; Modeline
(setq doom-modeline-height 25
      doom-modeline-bar-width 5
      doom-modeline-hud nil
      doom-modeline-window-width-limit fill-column
      doom-modeline-icon (display-graphic-p)
      doom-modeline-major-mode-icon t
      doom-modeline-major-mode-color-icon t
      doom-modeline-buffer-file-name-style 'truncate-with-project
      doom-modeline-minor-modes nil
      doom-modeline-persp-name nil
      doom-modeline-lsp t
      doom-modeline-github nil
      doom-modeline-git t
      doom-modeline-genghis nil
      doom-modeline-check-simple-format t
      doom-modeline-virus-icon nil
      doom-modeline-modal-icon nil
      doom-modeline-mu4e nil
      doom-modeline-irc nil
      doom-modeline-time nil
      doom-modeline-env-version nil
      doom-modeline-persp-name nil
      doom-modeline-gnus nil
      doom-modeline-irc-buffers nil
      doom-modeline-workspace-name nil
      doom-modeline-window-width-limit fill-column)

;; Scratch buffer
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)

;; Large files
(setq large-file-warning-threshold 10000000)

;; indentation
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Auto-save and backup
(setq auto-save-default t
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; User directory
(setq user-emacs-directory "~/.config/emacs")

;; Private config
(setq-default dotspacemacs-configuration-layer-path
              '("~/.config/emacs/private" "private"))

;; === Org Mode Configuration ===

;; Org Roam
(after! org-roam
  (setq org-roam-directory (expand-file-name "~/notes"))
  (setq org-roam-db-location (expand-file-name "~/notes/org-roam.db"))
  (setq org-roam-completion-everywhere t)
  (org-roam-db-autosync-mode))

;; Org Capture Templates
(after! org-capture
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/notes/todo.org" "Tasks")
           "* TODO %?\n  %u\n  %a")
          ("n" "Note" entry (file+headline "~/notes/notes.org" "Notes")
           "* %?\n  %u\n  %a")
          ("j" "Journal" entry (file+datetree "~/notes/journal.org")
           "* %?\n  %U\n  %a")
          ("p" "Project" entry (file+headline "~/notes/projects.org" "Projects")
           "* %?\n  %u\n  %a")
          ("r" "Reference" entry (file+headline "~/notes/reference.org" "References")
           "* %?\n  %u\n  %a"))))

;; Org Agenda
(after! org-agenda
  (setq org-agenda-files (list "~/notes/todo.org"
                               "~/notes/projects.org"
                               "~/notes/journal.org"))
  (setq org-agenda-start-on-weekday 1)  ; Monday
  (setq org-agenda-span 14)               ; 2 weeks
  (setq org-agenda-show-all-dates t)
  (setq org-agenda-skip-deadline-if-done t)
  (setq org-agenda-skip-scheduled-if-done t)
  (setq org-deadline-warning-days 7))

;; Org Babel
(after! org
  (setq org-babel-python-command "python3")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)
     (ruby . t)
     (js . t)
     (typescript . t)
     (rust . t)
     (go . t)
     (latex . t)
     (emacs-lisp . t)
     (sql . t)
     (calc . t)
     (C . t)
     (cpp . t))))

;; Org appearance
(setq org-hide-emphasis-markers t)
(setq org-startup-folded 'showall)
(setq org-pretty-entities t)
(setq org-src-fontify-natively t)
(setq org-fontify-whole-heading-line t)
(setq org-src-tab-acts-natively t)
(setq org-src-preserve-indentation t)

;; === Editor Behavior ===

;; Auto-save
(setq auto-save-default t
      auto-save-timeout 20
      auto-save-interval 300)

;; Truncate lines
(setq-default truncate-lines t
              truncate-partial-width-windows nil)

;; Scrolling
(setq scroll-conservatively 100
      scroll-margin 4
      scroll-step 1)

;; Follow symlinks
(setq vc-follow-symlinks t)

;; Encoding
(setq coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8
      default-process-coding-system '(utf-8 . utf-8)
      default-file-name-coding-system 'utf-8
      file-name-coding-system 'utf-8)

;; File handling
(setq make-backup-files t
      version-control t
      kept-new-versions 10
      kept-old-versions 5
      delete-old-versions t
      backup-by-copying t
      backup-directory-alist '((".*" . "~/.local/state/emacs/backups")))

;; Lock files
(setq create-lockfiles nil)

;; === Version Control ===

;; Magit
(after! magit
  (setq magit-diff-refine-hunk t)
  (setq magit-diff-sections '(staged unstaged))
  (setq magit-revision-show-gravatars nil)
  (setq magit-display-buffer-function 'magit-display-buffer-same-window-except-diff-v1))

;; Git
(after! vc
  (setq vc-follow-symlinks t)
  (setq vc-handled-backends '(Git)))

;; === LSP ===

(after! lsp-mode
  (setq lsp-prefer-capf t)
  (setq lsp-signature-render-documentation t)
  (setq lsp-enable-symbol-highlight t)
  (setq lsp-enable-folding t)
  (setq lsp-enable-indentation t)
  (setq lsp-enable-on-type-formatting t)
  (setq lsp-modeline-code-actions-enable t)
  (setq lsp-modeline-diagnostics-enable t)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-lens-enable t)
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'warning))
  (setq lsp-ui-sideline-enable nil)
  (setq lsp-ui-peek-enable t)
  (setq lsp-idle-delay 0.5)
  (setq lsp-completion-provider :capf)
  (setq lsp-completion-show-kind t)
  (setq lsp-completion-show-detail t))

;; LSP keybindings
(map! :leader
      :desc "LSP command" "c" #'lsp-execute-code-action
      :desc "LSP rename" "r" #'lsp-rename
      :desc "LSP format" "f" #'lsp-format-buffer
      :desc "LSP references" "R" #'lsp-find-references)

;; === Python ===

(after! python
  (setq python-shell-interpreter "python3")
  (setq python-shell-interpreter-args "-i")
  (setq python-shell-prompt-detect-failure-p nil))

;; === Evil Mode ===

(after! evil
  (setq evil-ex-substitute-global t
        evil-move-cursor-back nil
        evil-kill-on-visual-paste nil)
  (setq evil-split-window-below t
        evil-vsplit-window-right t))

;; === UI ===

;; Frame title
(setq frame-title-format '("%b - Doom Emacs"))

;; Highlight line numbers
(setq hl-line-sticky-flag t
      global-hl-line-modes '(not diff-mode))

;; Fringe
(setq fringe-mode '(8 . 0))

;; Parentheses
(show-paren-mode 1)
(setq show-paren-delay 0
      show-paren-highlight-openparen t
      show-paren-when-point-inside-paren t
      show-paren-context-when-offscreen t)

;; === Completions ===

(after! company
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2))

;; === Additional Packages ===

;; Projectile
(after! projectile
  (setq projectile-project-search-path '("~/projects" "~/work" "~/code"))
  (setq projectile-ignored-projects '("/tmp" "~/.local"))
  (setq projectile-enable-caching t))

;; Dired
(after! dired
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always)
  (setq delete-by-moving-to-trash t))

;; === Custom Functions ===

;; User-defined functions can go here

;; === OS-specific overrides will be layered on top ===
;; source: editors/emacs/os/$(detect-os)/init.el
