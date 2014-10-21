;; mdup's .emacs
;;
;; Beginner emacs config file from a long-time vimmer. Couldn't resist
;; using evil-mode as my pinky hates emacs keybindings...
;;
;; Most of this comes from
;; http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/
;; kudos to him!
;;


;; Custom variables.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "e26780280b5248eb9b2d02a237d9941956fc94972443b0f7aeec12b5c15db9f3" default)))
 '(guide-key-mode t)
 '(irony-additional-clang-options (quote ("-std=c++11")))
 '(safe-local-variable-values (quote ((achead:include-directories quote ("/usr/include/c++/4.8" "/Library/Developer/CommandLineTools/usr/bin/../lib/c++/v1" "/usr/local/include" "/Library/Developer/CommandLineTools/usr/bin/../lib/clang/5.1/include" "/Library/Developer/CommandLineTools/usr/include" "/usr/include" "/System/Library/Frameworks" "/Library/Frameworks"))))))

;; PACKAGES:
;; Desired packages.
(require 'package)
(setq package-list '(evil
		     sublime-themes
		     undo-tree
		     evil-leader
		     evil-tabs
		     guide-key
		     color-theme-solarized
		     helm
		     helm-projectile
		     discover-my-major
		     multi-term
		     flycheck
		     helm-flycheck
		     company
		     company-c-headers
		     ;company-cmake
		     cpputils-cmake
		     cmake-mode
		     cmake-project
		     irony
		     company-irony
		     ace-jump-buffer
		     ace-jump-mode
		     ack-and-a-half
		     async
		     auto-complete
		     auto-complete-c-headers
		     cider
		     color-theme
		     color-theme-solarized
		     discover-my-major
		     elscreen
		     evil-paredit
		     evil-surround
		     evil-visualstar
		     fill-column-indicator
		     git-commit-mode
		     git-rebase-mode
		     key-chord
		     magit
		     multi-term
		     paredit
		     pymacs
		     python-mode
		     rainbow-delimiters
		     rainbow-mode
		     undo-tree
		     yasnippet
  ))
;; Packages repositories.
(setq package-archives
  '(("gnu" . "http://elpa.gnu.org/packages/")
    ("org" . "http://orgmode.org/elpa/")
    ("marmalade" . "http://marmalade-repo.org/packages/")
    ("melpa" . "http://melpa.milkbox.net/packages/")))
;; Activate packages
(package-initialize)
;; Fetch the list of available packages
(unless package-archive-contents
    (package-refresh-contents))
;; Install the missing packages.
(dolist (package package-list)
    (unless (package-installed-p package)
	  (package-install package)))




;; The theme. Look at https://github.com/owainlewis/emacs-color-themes
;; for a gallery.
;;
;;(load-theme 'spolsky)
;;(load-theme 'solarized-dark)
(load-theme 'solarized-light)

;; Evil-mode.
(evil-mode 1)
(setq evil-esc-delay 0.075) ;; Terminal: you need to type fast "ESC x" to get M-x

;; Evil cursor colors
;; EDIT: commented out, because it makes the cursor blink, it's unstoppable...
;(setq evil-emacs-state-cursor '("red" box))
;(setq evil-normal-state-cursor '("green" box))
;(setq evil-visual-state-cursor '("orange" box))
;(setq evil-insert-state-cursor '("red" bar))
;(setq evil-replace-state-cursor '("red" bar))
;(setq evil-operator-state-cursor '("red" hollow))

;; undo-tree: C-r is redo
(define-key evil-normal-state-map "\C-r" 'undo-tree-redo)

;; Evil tabs
(global-evil-tabs-mode t)
(global-set-key (kbd "s-<right>") 'elscreen-next)
(global-set-key (kbd "s-<left>") 'elscreen-previous)
(global-set-key (kbd "s-t") 'elscreen-create)
(global-set-key (kbd "s-w") 'elscreen-kill)
;; Commands for inside the terminal
(global-set-key (kbd "M-<right>") 'elscreen-next)
(global-set-key (kbd "M-l") 'elscreen-next)
(global-set-key (kbd "M-<left>") 'elscreen-previous)
(global-set-key (kbd "M-h") 'elscreen-previous)
(global-set-key (kbd "M-t") 'elscreen-create) ;; This will override
					      ;; 'transpose-words.
(global-set-key (kbd "M-w") 'elscreen-kill)
(global-set-key (kbd "M-@") 'other-window)
(defun other-window-reverse () (interactive) (other-window -1))
(global-set-key (kbd "M-#") 'other-window-reverse)
(global-set-key (kbd "M-k") 'kill-and-0)
(global-set-key (kbd "M-d") 'delete-window)
(global-set-key (kbd "M-&") 'delete-other-windows)
(global-set-key (kbd "M-à") 'delete-window)
(global-set-key (kbd "M-r") 'helm-recentf)
(global-set-key (kbd "M-b") 'helm-mini)

(define-key evil-normal-state-map (kbd "C-w <left>") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-w <right>") 'evil-window-right)
(define-key evil-normal-state-map (kbd "C-w <up>") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-w <down>") 'evil-window-down)
;; Not sure whether the followings work (well, not in term at least.)
(global-set-key (kbd "C-<left>") 'evil-window-left)
(global-set-key (kbd "C-<right>") 'evil-window-right)
(global-set-key (kbd "C-<up>") 'evil-window-up)
(global-set-key (kbd "C-<down>") 'evil-window-down)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-@") 'ace-jump-mode) ; works for C-SPC in term
(define-key global-map (kbd "M-SPC") 'ace-jump-line-mode)



(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(defun kill-and-0 ()
  "Kill a buffer and delete its window."
  (interactive)
  (kill-buffer)
  (delete-window))

;; Evil leader setup
(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
(evil-leader/set-leader ",")
;; Below setup could solve some problems; keep it around
;(setq evil-leader/in-all-states t)
;(evil-leader/set-leader ",")
;(evil-mode nil)
;(global-evil-leader-mode 1)
;(evil-mode 1)
;; Evil-leader bindings
(evil-leader/set-key
  "w" 'whitespace-cleanup
  "t" 'helm-projectile
  "e" 'helm-flycheck
)

;; Make some OS X keys work: ~ \ { }
;; Now 'meta' is the Cmd key. Alt does nothing.
;(setq mac-option-modifier nil
;      mac-command-modifier 'meta
;      x-select-enable-clipboard t)
; EDIT: actually I really don't like this solution :(
;; Second solution: steal some bindings from AquaMacs! :)
(defun aq-binding (any) nil)
(load  "~/.emacs.d/aquamacs-tools.el")
(load  "~/.emacs.d/emulate-mac-keyboard-mode.el")
(setq emulate-mac-french-keyboard-mode t)
(setq mac-right-option-modifier nil)

;; Guide-key
(setq guide-key/guide-key-sequence
      '("C-x r"
	"C-x 4")) ;; add more here, if you want some help.
(guide-key-mode 1)

;; Line numbers on the left
(global-linum-mode t)

;; juanjux's init-server.el. Defines macro 'after
(load "~/.emacs.d/init-server.el")

;;
;; Helm config
;; Mostly https://github.com/tuhdo/emacs-c-ide-demo/blob/master/custom/setup-helm.el
;; and juanjux.
(setq helm-command-prefix-key "C-c h")

(require 'helm-config)
(require 'helm-misc)
(after 'projectile
  (require 'helm-projectile))
(require 'helm-locate)
(require 'helm-eshell)
(require 'helm-files)
(require 'helm-grep)

;; (defun helm-my-buffers ()
;;   (interactive)
;;   (helm-other-buffer '(helm-c-source-buffers-list
;;                     helm-c-source-elscreen
;;                     helm-c-source-projectile-files-list
;;                     helm-c-source-ctags
;;                     helm-c-source-recentf
;;                     helm-c-source-locate)
;;                   "*helm-my-buffers*"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
(define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

(setq
 helm-bookmark-show-location t
 helm-google-suggest-use-curl-p t
 helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
 helm-quick-update t ; do not display invisible candidates
 helm-idle-delay 0.01 ; be idle for this many seconds, before updating in delayed sources.
 helm-input-idle-delay 0.01 ; be idle for this many seconds, before updating candidate buffer
 helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.

 ;; you can customize helm-do-grep to execute ack-grep
 ;; helm-grep-default-command "ack-grep -Hn --smart-case --no-group --no-color %e %p %f"
 ;; helm-grep-default-recurse-command "ack-grep -H --smart-case --no-group --no-color %e %p %f"
 helm-split-window-default-side 'other ;; open helm buffer in another window
 helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window
 helm-buffers-favorite-modes (append helm-buffers-favorite-modes
		     '(picture-mode artist-mode))
 helm-candidate-number-limit 500 ; limit the number of displayed canidates
 helm-M-x-requires-pattern 0     ; show all candidates when set to 0
 helm-boring-file-regexp-list
 '("\\.git$" "\\.hg$" "\\.svn$" "\\.CVS$" "\\._darcs$" "\\.la$" "\\.o$" "\\.i$") ; do not show these files in helm buffer
 helm-ff-file-name-history-use-recentf t
 helm-move-to-line-cycle-in-source t ; move to end or beginning of source
					; when reaching top or bottom of source.
 ido-use-virtual-buffers t		; Needed in helm-buffers-list
 helm-buffers-fuzzy-matching t          ; fuzzy matching buffer names when non-nil
					; useful in helm-mini that lists buffers
 )

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-c h g") 'helm-do-grep)
(global-set-key (kbd "C-c h C-c w") 'helm-wikipedia-suggest)
(global-set-key (kbd "C-c h x") 'helm-register)

(define-key 'help-command (kbd "C-f") 'helm-apropos)
(define-key 'help-command (kbd "r") 'helm-info-emacs)
(define-key 'help-command (kbd "C-l") 'helm-locate-library)

;;; Save current position to mark ring
(add-hook 'helm-goto-line-before-hook 'helm-save-current-pos-to-mark-ring)

(helm-mode)

;;--- (end of helm config)


;; Ignore beginner warnings for the following:
(put 'narrow-to-region 'disabled nil)

;; M-z opens zsh
;;(global-set-key (kbd "M-z") 'multi-term) ;; Not sure about this one

;; C++:
;; Enable flycheck
(add-hook 'c++-mode-hook 'flycheck-mode)
;; Flycheck C++11
(add-hook 'c++-mode-hook (lambda () (setq flycheck-clang-language-standard "c++11")))
;; Flycheck recognize .h as C++
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
;; C/C++ double-slash style comments
(add-hook 'c-mode-hook (lambda () (setq comment-start "//"
					comment-end   "")))
;; custom include
;(setq flycheck-clang-include-path '("<your_path_here>/include"))


;; gtags
;; config FIRST PART, from https://github.com/syohex/emacs-helm-gtags
;;; customize
;; (load  "~/.emacs.d/helm-gtags.el")

;; ;;; Enable helm-gtags-mode
;; (add-hook 'dired-mode-hook 'helm-gtags-mode)
;; (add-hook 'eshell-mode-hook 'helm-gtags-mode)
;; (add-hook 'c-mode-hook 'helm-gtags-mode)
;; (add-hook 'c++-mode-hook 'helm-gtags-mode)
;; (add-hook 'asm-mode-hook 'helm-gtags-mode)
;; ;;; key bindings
;; (eval-after-load "helm-gtags"
;;   '(progn
;;      (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
;;      (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
;;      (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
;;      (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
;;      (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;;      (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
;;      (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;;      (define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;;      ;(define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-select)
;;      (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;; ))
;; ;; config SECOND PART, from http://tuhdo.github.io/c-ide.html
;; (setq
;;  helm-gtags-ignore-case t
;;  helm-gtags-auto-update t
;;  helm-gtags-use-input-at-cursor t
;;  helm-gtags-pulse-at-cursor t
;;  helm-gtags-prefix-key "\C-cg"
;;  helm-gtags-suggested-key-mapping t
;;  )

;; PATH
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; projectile
(require 'projectile)
(add-hook 'c++-mode-hook 'projectile-mode)

;; company
;; (require 'company)
;; ;(add-hook 'after-init-hook 'global-company-mode)
;; ;(setq company-backends (delete 'company-semantic company-backends))
;; ;(define-key c-mode-map  [(tab)] 'company-complete)
;; ;(define-key c++-mode-map  [(tab)] 'company-complete)
;; (add-hook 'c++-mode-hook 'irony-mode)
;; (add-hook 'c-mode-hook 'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)
;; ;; replace the `completion-at-point' and `complete-symbol' bindings in
;; ;; irony-mode's buffers by irony-mode's function
;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)

;; (eval-after-load 'company
;;   '(add-to-list 'company-backends 'company-irony))

;; ;; (optional) adds CC special commands to `company-begin-commands' in order to
;; ;; trigger completion at interesting places, such as after scope operator
;; ;;     std::|
;; (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)


;; Autocomplete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;; Yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;; Autocomplete headers
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'achead:include-directories '"/usr/include/c++/4.8/")
  (add-to-list 'achead:include-directories '"/Library/Developer/CommandLineTools/usr/include/c++/v1")
  (add-to-list 'achead:include-directories '"/usr/local/include")
  (add-to-list 'achead:include-directories '"/Library/Developer/CommandLineTools/usr/lib/clang/5.1/include")
  (add-to-list 'achead:include-directories '"/Library/Developer/CommandLineTools/usr/include")
  (add-to-list 'achead:include-directories '"/usr/include")
  ;; (add-to-list 'achead:include-directories '"/System/Library/Frameworks")
  ;; (add-to-list 'achead:include-directories '"/Library/Frameworks")
  ; This is for C
  (add-to-list 'achead:include-directories '"/Library/Developer/CommandLineTools/usr/lib/clang/6.0/include")
  (message '"C++ include paths loaded.")
  (add-to-list 'ac-sources 'ac-source-c-headers)
)
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'cc-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;; Fix iedit bug
(define-key global-map (kbd "C-c ;") 'iedit-mode)

;; Note, remember, cheatsheet
;; - Undo-tree is available with C-x u. (this is pure awesomeness)
;; - In insert mode, refactor a name with iedit: C-c ;

;; C++ tab settings
(c-add-style "my-style"
	 '("stroustrup"
	   (indent-tabs-mode . nil)        ; use spaces rather than tabs
	   (c-basic-offset . 4)            ; indent by four spaces
	   (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
		   (brace-list-open . 0)
		   (statement-case-open . +)))))
(defun my-c++-mode-hook ()
  (c-set-style "my-style")        ; use my-style defined above
  (auto-fill-mode)
  (c-toggle-auto-hungry-state 1))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; (add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)

;; Semantic mode
(semantic-mode 1)
(defun my:add-semantic-to-autocomplete ()
  (add-to-list 'ac-sources 'ac-source-semantic))
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)
(add-hook 'c++-mode-hook 'my:add-semantic-to-autocomplete)

;; Irony with autocomplete
(load  "~/.emacs.d/ac-irony.el")
(defun my-ac-irony-setup ()
  ;; be cautious, if yas is not enabled before (auto-complete-mode 1), overlays
  ;; *may* persist after an expansion.
  (yas-minor-mode 1)
  (auto-complete-mode 1)
  (add-to-list 'ac-sources 'ac-source-irony)
  (define-key irony-mode-map (kbd "M-RET") 'ac-complete-irony-async))
(add-hook 'irony-mode-hook 'my-ac-irony-setup)

;; Helm color for solarized
;(set-face-attribute 'helm-selection nil :background "#ffffff")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))

;; Evil surround
;; EDIT: Arghhhh it overrides "s" evil binding, this is
;; awful. Disabling
;; (require 'evil-surround)
;; (global-evil-surround-mode 1)

;; Evil word boundary: I don't want underscore "_" to count as a word
;; boundary!
;;(modify-syntax-entry ?_ "w")
(defvar syntax-table-no-underscore
     (let ((table (make-syntax-table)))
       (modify-syntax-entry ?_ "w")
       table))
(set-syntax-table syntax-table-no-underscore)

;; Highlight trailing spaces
(setq-default show-trailing-whitespace 1)

;; Highlight current line, nice for the eyes
(global-hl-line-mode 1)

;; When opening with Mac OS X's `open -a`, don't open in a new frame.
(setq ns-pop-up-frames nil)

;; Fill column indicator
(require 'fill-column-indicator)
(define-globalized-minor-mode
 global-fci-mode fci-mode (lambda () (fci-mode 1)))
(global-fci-mode t)

;; ---Python---
; python-mode
(require 'python-mode)
; use IPython
(setq-default py-shell-name "ipython")
(setq-default py-which-bufname "IPython")
; use the wx backend, for both mayavi and matplotlib
(setq py-python-command-args
  '("--gui=wx" "--pylab=wx" "-colors" "Linux"))
(setq py-force-py-shell-name-p t)
; don't switch to the interpreter after executing code
(setq py-shell-switch-buffers-on-execute-p nil)
(setq py-switch-buffers-on-execute-p nil)
; don't split windows
(setq py-split-windows-on-execute-p nil)
; try to automagically figure out indentation
(setq py-smart-indentation t)

;; (global-set-key (kbd "C-c C-r") 'py-execute-region-no-switch)
;; (global-set-key (kbd "C-c C-c") 'py-execute-buffer-no-switch)


;; Visual-star:
;; Make a visual selection with `v` or `V`, and then hit `*` to search
;; the selection forward, or # to search that selection backward.
(require 'evil-visualstar)

; Don't use evil mode for everything, for prompt-like things, it sucks
(loop for (mode . state) in '((inferior-emacs-lisp-mode . emacs)
			      (nrepl-mode . insert)
			      (pylookup-mode . emacs)
			      (comint-mode . emacs)
			      (shell-mode . insert)
			      (git-commit-mode . insert)
			      (git-rebase-mode . emacs)
			      (term-mode . emacs)
			      (help-mode . emacs)
			      (helm-grep-mode . emacs)
			      (grep-mode . emacs)
			      (bc-menu-mode . emacs)
			      (magit-branch-manager-mode . emacs)
			      (rdictcc-buffer-mode . emacs)
			      (dired-mode . emacs)
			      (wdired-mode . normal))
do (evil-set-initial-state mode state))


;; Key chords. I don't use it right now but could be in the future
;;(key-chord-define-global " \t" 'switch-to-previous-buffer)

;; Rainbow
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Open .h associated to .cpp with quick shortcut.
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "M-h") 'ff-find-other-file)))
