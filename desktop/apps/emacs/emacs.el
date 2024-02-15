(require 'use-package)

(use-package evil
  :config (evil-mode 1)
    (setq-default display-line-numbers-mode 'visual)
    (setq-default display-line-numbers-current-absolute t)
    (setq-default display-line-numbers-widen t)
  )

(setq inhibit-startup-message t)
