; .emacs file 
;  2/9/08 Customized by H .Youngren
;
;  This file will do two things: alias the function keys as listed below
;  and turn on font-locking for all modes 
;  Font-locking replaced the hilite19 code previously used for syntax 
;  hilighting for code (lisp, fortran, C, etc) in different colors
;
;  The colors are presently set for use with a grey background and brown
;  foreground.  To get these colors, add the following two lines to your
;  .Xdefaults/.Xresources file
;
;  emacs.foreground: lightgoldenrod3
;  emacs.background: gray30
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   Start-up options...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-splash-screen t)

(setq default-frame-alist
        '(
;;        (top . 50)
;;        (left . 100)
;;        (width . 110)
        (height . 50)
	(mouse-color       . "blue")
	(cursor-color      . "red")
        (background-color  . "gray30")
        (foreground-color  . "white")
;;        (font . "-*-Courier New-normal-r-*-*-13-*-*-*-c-*-iso8859-1")
     ))        
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   My own key settings... HHY 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key "\C-o" 'call-last-kbd-macro)
(global-set-key "\ek" 'kill-to-beginning-of-line)
(global-set-key "\C-c\C-e" 'compile)
(global-set-key "\C-c\C-g" 'goto-line)
(global-set-key "\C-xn" 'other-window)
(global-set-key "\C-xp" 'previous-multiframe-window)
;
; Key definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   The emacs function key mappings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key [f1] 'find-file)              ; open file
;(global-set-key [f2] 'what-line)             ; tell you what line you're on
(global-set-key [f2] 'shell-command)          ; run shell command
(global-set-key [f3] 'goto-line)              ; goto line <insert number>
(global-set-key [f4] 'query-replace)          ; search and replace
(global-set-key [f5] 'switch-to-buffer)       ; switch to other file
(global-set-key [f6] 'copy-region-as-kill)    ; copy
(global-set-key [f7] 'yank)                   ; paste
;; function keys f1-f7 used on Mac OSX without modifier
(global-set-key [f8] 'mail)                    ; enter sendmail mode
(global-set-key [f9] 'save-buffer)             ; save file
(global-set-key [f10] 'kill-buffer)            ; close file
(global-set-key [f11] 'kill-region)            ; cut
(global-set-key [f12] 'keyboard-quit)          ; quit out of any function

(global-set-key [home]  'beginning-of-buffer)  ; goto beginning of buffer
(global-set-key [end]   'end-of-buffer)        ; goto end of buffer
(global-set-key [Next]  'beginning-of-buffer)  ; goto beginning of buffer
(global-set-key [Prior] 'end-of-buffer)        ; goto end of buffer


;; Enable font-locking for all buffers to get syntax hi-lighting
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode t))
;;(setq font-lock-support-mode 'lazy-lock-mode)
(setq font-lock-maximum-decoration t)

;;(setq lazy-lock-defer-after-change t)
;;(global-font-lock-mode t)

;; always turn parentheses mode on.
;;(show-paren-mode t)

;; turn on column number display
(column-number-mode t)

;; Auto-resize minibuffer the appropriate size. 
;;(resize-minibuffer-mode t)

(put 'downcase-region 'disabled nil)
