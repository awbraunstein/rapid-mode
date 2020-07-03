;; rapid-mode.el --- Major mode for editing rapid files.

;;; Commentary:

;; Provides font-locking and indentation support.

;;; Code:

(defgroup rapid nil
  "Major mode for editing RAPID code."
  :prefix "rapid-"
  :group 'languages)

(defcustom rapid-indent-level 4
  "Indentation of RAPID statements."
  :type 'integer
  :group 'rapid
  :safe 'integerp)

(defcustom rapid-comment-column (default-value 'comment-column)
  "Indentation column of comments."
  :type 'integer
  :group 'rapid
  :safe 'integerp)

(defcustom rapid-indent-tabs-mode nil
  "Indentation can insert tabs in RAPID mode if this is non-nil."
  :type 'boolean
  :group 'rapid
  :safe 'booleanp)

(defun rapid-mode-variables ()
  "Set up initial buffer-local variables for RAPID mode."
  (setq indent-tabs-mode rapid-indent-tabs-mode)
  ;; (setq-local indent-line-function 'rapid-indent-line)
  (setq-local comment-start "!")
  (setq-local comment-column rapid-comment-column)
  (setq-local comment-start-skip "!+")
  (setq-local parse-sexp-ignore-comments t)
  (setq-local parse-sexp-lookup-properties t)
  (setq-local paragraph-start (concat "$\\|" page-delimiter))
  (setq-local paragraph-separate paragraph-start)
  (setq-local paragraph-ignore-fill-prefix t))

(defvar rapid-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?\' "\"" table)
    (modify-syntax-entry ?\" "\"" table)
    (modify-syntax-entry ?\` "\"" table)
    (modify-syntax-entry ?\! "<" table)
    (modify-syntax-entry ?\n ">" table)
    (modify-syntax-entry ?\\ "\\" table)
    (modify-syntax-entry ?$ "." table)
    (modify-syntax-entry ?_ "_" table)
    (modify-syntax-entry ?: "_" table)
    (modify-syntax-entry ?< "." table)
    (modify-syntax-entry ?> "." table)
    (modify-syntax-entry ?& "." table)
    (modify-syntax-entry ?| "." table)
    (modify-syntax-entry ?% "." table)
    (modify-syntax-entry ?= "." table)
    (modify-syntax-entry ?/ "." table)
    (modify-syntax-entry ?+ "." table)
    (modify-syntax-entry ?* "." table)
    (modify-syntax-entry ?- "." table)
    (modify-syntax-entry ?\; "." table)
    (modify-syntax-entry ?\( "()" table)
    (modify-syntax-entry ?\) ")(" table)
    (modify-syntax-entry ?\{ "(}" table)
    (modify-syntax-entry ?\} "){" table)
    (modify-syntax-entry ?\[ "(]" table)
    (modify-syntax-entry ?\] ")[" table)
    table)
  "Syntax table to use in RAPID mode.")

(defvar rapid-font-lock-syntax-table
  (let ((tbl (copy-syntax-table rapid-mode-syntax-table)))
    (modify-syntax-entry ?_ "w" tbl)
    tbl)
  "The syntax table to use for fontifying RAPID mode buffers.
See `font-lock-syntax-table'.")

(defconst rapid-font-lock-keyword-beg-re "\\(?:^\\|[^.@$]\\|\\.\\.\\)")

(defconst rapid-font-lock-keywords
  `(;; Procs.
    ("^\\s *proc\\s +\\([^( \t\n]+\\)"
     1 font-lock-function-name-face)
    ;; Funcs.
    ("^\\s *func\\s +\\(?:[^( \t\n]+\\)\\s +\\([^( \t\n]+\\)"
     1 font-lock-function-name-face)
    ;; Records.
    ("^\\s *record\\s +\\([^( \t\n]+\\)"
     1 font-lock-type-face)
    ;; Keywords.
    (,(concat
       rapid-font-lock-keyword-beg-re
       (regexp-opt
        '("alias"
          "and"
          "backward"
          "case"
          "connect"
          "const"
          "default"
          "div"
          "do"
          "else"
          "elseif"
          "endfor"
          "endfunc"
          "endif"
          "endmodule"
          "endproc"
          "endrecord"
          "endtest"
          "endtrap"
          "endwhile"
          "error"
          "exit"
          "false"
          "for"
          "from"
          "func"
          "goto"
          "if"
          "inout"
          "local"
          "mod"
          "module"
          "nostepin"
          "not"
          "noview"
          "or"
          "pers"
          "proc"
          "raise"
          "readonly"
          "record"
          "retry"
          "return"
          "step"
          "sysmodule"
          "test"
          "then"
          "to"
          "trap"
          "true"
          "trynext"
          "undo"
          "var"
          "viewonly"
          "while"
          "with"
          "xor")
        'symbols))
     (1 font-lock-keyword-face))
    ;; Vars.
    (,(concat (regexp-opt '("var" "pers" "const")) "\\s +\\(?:[^( \t\n]+\\)\\s +\\([^( \t\n]+\\)")
     1 font-lock-variable-name-face)
    ;; Types.
    (,(concat (regexp-opt '("var" "pers" "const")) "\\s +\\([^( \t\n]+\\)")
     (1 font-lock-type-face))
    )
  "Additional expressions to highlight in RAPID mode.")


;;;###autoload
(define-derived-mode rapid-mode prog-mode "RAPID"
  "Major mode for editing RAPID code."
  (rapid-mode-variables)


  ;; (add-hook 'electric-indent-functions 'rapid--electric-indent-p nil 'local)

  (setq-local font-lock-defaults '((rapid-font-lock-keywords) nil t))
  (setq-local font-lock-keywords rapid-font-lock-keywords)
  (setq-local font-lock-syntax-table rapid-font-lock-syntax-table))

;;; Invoke rapid-mode when appropriate

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.mod\\'" . rapid-mode))

(provide 'rapid-mode)

;;; rapid-mode.el ends here
