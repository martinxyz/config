(defun neuronics-python-mode ()
  (interactive)
  (python-mode)
  ; indent with tabs only.
  (setq indent-tabs-mode t)
  )

(defun neuronics-c-mode ()
  "save only tabs to disk, show 4 spaces (visual only)"
  (interactive)
  (c++-mode)
  ; indent with tabs only.
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode t)
  )

(setq auto-mode-alist (cons '(".*\\.h$" . neuronics-c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".*\\.hpp$" . neuronics-c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".*\\.c$" . neuronics-c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".*\\.cpp$" . neuronics-c-mode) auto-mode-alist))

(setq auto-mode-alist 
      (cons '(".*py$" . neuronics-python-mode)
          auto-mode-alist))

(setq-default tab-width 4)
(setq-default tab-stop-list (list 4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108))
