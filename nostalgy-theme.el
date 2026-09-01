;;; nostalgy-theme.el --- A nostalgic dark theme built on classic X11 colors -*- lexical-binding: t; -*-

;; Copyright (C) 2026  Pavlo

;; Author: Pavlo <pavlikus@gmail.com>
;; Maintainer: Pavlo <pavlikus@gmail.com>
;; URL: https://github.com/pavlo/emacs-nostalgy-theme
;; Version: 0.1.0
;; Package-Requires: ((emacs "28.1"))
;; Keywords: faces, theme, accessibility

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Nostalgy is a dark Emacs theme that revives the palette of the early
;; graphical web and the X11 `rgb.txt' colour list: a `DarkSlateGray'
;; canvas, `wheat' text, sea greens, burlywood, and a jolt of pure `cyan'
;; for links and strings.  Two reference "moods" are supported:
;;
;;   * The default look is understated -- most code stays `wheat', with
;;     cyan reserved for strings and links and quiet sea-green comments.
;;
;;   * A "colourful" mood mirrors the busier reference screenshot, giving
;;     keywords, types, and constants their own hues.  Enable it with the
;;     preset described below.
;;
;; The architecture follows the design of the Modus themes by Protesilaos
;; Stavrou (https://protesilaos.com/emacs/modus-themes):
;;
;;   1. A palette of *named colours*  ......  (wheat "#f5deb3")
;;   2. A layer of *semantic mappings*  ....  (string cyan-cooler)
;;                                            (comment green-faint)
;;
;; A mapping value may be a hex string, the name of another palette
;; colour, or the name of another mapping (which is resolved
;; recursively).  Users can shadow any entry through
;; `nostalgy-palette-overrides', and a ready-made preset is provided:
;;
;;     (setq nostalgy-palette-overrides nostalgy-preset-overrides-colorful)
;;     (load-theme 'nostalgy :no-confirm)
;;
;; After loading, `nostalgy-after-load-theme-hook' is run so further
;; tweaks can be applied programmatically.

;;; Code:

(eval-when-compile (require 'cl-lib))

(deftheme nostalgy
  "A nostalgic dark theme built on classic X11 / early-web colours.")


;;;; User options

(defgroup nostalgy-theme nil
  "Nostalgy theme options.
Changes take effect the next time the theme is loaded."
  :group 'faces
  :prefix "nostalgy-"
  :tag "Nostalgy Theme")

(defcustom nostalgy-palette-overrides nil
  "Alist of overrides applied on top of `nostalgy-palette'.
Each element has the form (NAME VALUE), where NAME is a palette key
(a named colour or a semantic mapping) and VALUE is a hex string,
another palette colour name, or another mapping name.

For a curated set of overrides see `nostalgy-preset-overrides-colorful'."
  :group 'nostalgy-theme
  :type '(repeat (list symbol sexp))
  :package-version '(nostalgy-theme . "0.1.0"))

(defcustom nostalgy-after-load-theme-hook nil
  "Hook run after the Nostalgy theme is loaded with `load-theme'."
  :group 'nostalgy-theme
  :type 'hook)


;;;; Palette: named colours

;; The face-building macro `nostalgy-with-colors' walks the palette while
;; it expands, so the palette and its resolver must exist at compile time
;; as well as at load time -- hence `eval-and-compile'.
(eval-and-compile

(defconst nostalgy-palette
  '(
;;; Basic values -- the DarkSlateGray canvas and wheat ink

    (bg-main        "#2f4f4f") ; DarkSlateGray
    (bg-dim         "#2b4848")
    (bg-alt         "#3a5c5c")
    (fg-main        "#f5deb3") ; wheat
    (fg-dim         "#b3ac8f")
    (fg-alt         "#d3d3d3") ; LightGray
    (bg-active      "#436868")
    (bg-inactive    "#2a4545")
    (border         "#5c7d7d")

;;; Common accent foregrounds (tuned for contrast on DarkSlateGray)

    (red            "#e07a6b")
    (red-warmer     "#e9967a") ; DarkSalmon
    (red-cooler     "#dd8878")
    (red-faint      "#c99a8f")
    (red-intense    "#ff6a5a")

    (green          "#8fbc8f") ; DarkSeaGreen
    (green-warmer   "#3cb371") ; MediumSeaGreen
    (green-cooler   "#66cdaa") ; MediumAquamarine
    (green-faint    "#a6c3a0")
    (green-intense  "#54d06a")

    (yellow         "#e8d994")
    (yellow-warmer  "#deb887") ; BurlyWood
    (yellow-cooler  "#d8c97d")
    (yellow-faint   "#cdba96")
    (yellow-intense "#f2d64b")

    (blue           "#8fb2cc")
    (blue-warmer    "#9aa9d6")
    (blue-cooler    "#5f9ea0") ; CadetBlue
    (blue-faint     "#a7bccb")
    (blue-intense   "#79b8ff")

    (magenta        "#caa6ca")
    (magenta-warmer "#d7a6bd")
    (magenta-cooler "#b3a6d8")
    (magenta-faint  "#c3b2c3")
    (magenta-intense "#e59bd4")

    (cyan           "#00ffff") ; cyan / aqua
    (cyan-warmer    "#7fffd4") ; Aquamarine
    (cyan-cooler    "#4fd0d0")
    (cyan-faint     "#9cc4c4")
    (cyan-intense   "#00e0e0")

    (rust           "#c18a59")
    (rust-deep      "#8d6650")

;;; Background accents (subtle washes for highlighting)

    (bg-red-subtle      "#5c3a3a")
    (bg-green-subtle    "#31543f")
    (bg-yellow-subtle   "#54502f")
    (bg-blue-subtle     "#334f5c")
    (bg-magenta-subtle  "#4f3a52")
    (bg-cyan-subtle     "#2f5252")

    (bg-red-intense     "#7a3f3f")
    (bg-green-intense   "#2f6a48")
    (bg-yellow-intense  "#7a6a2f")
    (bg-blue-intense    "#35617a")
    (bg-magenta-intense "#6a3f70")
    (bg-cyan-intense    "#2f6a6a")

;;; Diffs

    (bg-added          "#2f5a44")
    (bg-added-faint    "#2b4f3e")
    (bg-added-refine   "#3a7256")
    (fg-added          "#b7e0c4")

    (bg-changed        "#544f2f")
    (bg-changed-faint  "#4a472b")
    (bg-changed-refine "#726a3a")
    (fg-changed        "#e6dca8")

    (bg-removed        "#5c3a3a")
    (bg-removed-faint  "#4f3535")
    (bg-removed-refine "#743f3f")
    (fg-removed        "#eeb7ac")

;;; Special purpose

    (bg-hl-line     "#375656")
    (bg-region      "#5a7d7d")
    (fg-region      "#f5deb3")
    (bg-paren-match "#5f9ea0")
    (fg-paren-match "#2f4f4f")
    (bg-paren-mismatch "#e9967a")
    (bg-search-current "#e8d994")
    (fg-search-current "#2f4f4f")
    (bg-search-lazy  "#4f7f7f")
    (fg-search-lazy  "#f5deb3")
    (bg-prompt      unspecified)
    (fg-prompt      "#66cdaa")

    (bg-mode-line-active   "#243c3c")
    (fg-mode-line-active   "#f5deb3")
    (border-mode-line-active "#6f9a9a")
    (bg-mode-line-inactive "#2a4545")
    (fg-mode-line-inactive "#9db0b0")
    (border-mode-line-inactive "#4a6a6a")

    (bg-tab-bar      "#274040")
    (bg-tab-current  "#2f4f4f")
    (bg-tab-other    "#385959")

    (fg-line-number-inactive "#86a3a3")
    (fg-line-number-active   "#f5deb3")
    (bg-line-number-inactive unspecified)
    (bg-line-number-active   "#375656")

    (cursor         "#f5deb3")
    (fg-window-divider-inner "#3a5c5c")
    (fg-window-divider-outer "#5c7d7d")

;;;; Semantic mappings -- the understated default mood

    (fg-active   fg-main)
    (bg-hover    bg-cyan-subtle)
    (bg-hover-secondary bg-yellow-subtle)

    (keyword     yellow-faint)
    (builtin     fg-main)
    (comment     green-faint)
    (string      cyan-cooler)
    (docstring   green-faint)
    (docmarkup   magenta-faint)
    (constant    yellow)
    (number      yellow)
    (type        green)
    (fnname      fg-main)
    (variable    fg-main)
    (property    fg-main)
    (preprocessor yellow-warmer)
    (rx-construct green-cooler)
    (rx-backslash red-faint)
    (escape-char  red-faint)
    (delimiter    fg-dim)
    (operator     fg-main)
    (bracket      fg-main)
    (punctuation  fg-dim)

    (accent-0    cyan)
    (accent-1    green-warmer)
    (accent-2    yellow-warmer)
    (accent-3    magenta-cooler)

    (fg-link      cyan)
    (fg-link-visited magenta-cooler)
    (fg-link-symbolic cyan-warmer)
    (underline-link cyan)
    (underline-link-visited magenta-cooler)

    (warning     yellow)
    (err         red-warmer)
    (info        green-warmer)
    (success     green-warmer)
    (note        cyan-cooler)

    (fg-heading-0 cyan-warmer)
    (fg-heading-1 fg-main)
    (fg-heading-2 yellow)
    (fg-heading-3 green)
    (fg-heading-4 cyan-cooler)
    (fg-heading-5 yellow-warmer)
    (fg-heading-6 green-warmer)
    (fg-heading-7 magenta-cooler)
    (fg-heading-8 fg-dim)

    (fg-prose-verbatim green-cooler)
    (bg-prose-block-contents bg-dim)
    (fg-prose-block-delimiter fg-dim)
    (fg-prose-code cyan-cooler)
    (fg-prose-macro yellow-warmer)
    (fg-prose-table fg-dim)
    (fg-prose-tag fg-dim)

    (prose-done  green-warmer)
    (prose-todo  red-warmer)

    (fg-mark-select cyan-cooler)
    (bg-mark-select bg-cyan-subtle)
    (fg-mark-delete red-warmer)
    (bg-mark-delete bg-red-subtle)
    (fg-mark-other yellow)
    (bg-mark-other bg-yellow-subtle)

    (identifier-fg fg-dim)

    (fg-completion-match-0 cyan)
    (fg-completion-match-1 yellow-warmer)
    (fg-completion-match-2 green-warmer)
    (fg-completion-match-3 magenta-cooler)
    )
  "The entire palette of the Nostalgy theme.
Each element is a list of the form (NAME VALUE).  A VALUE that is
another symbol is resolved against this same table (and against
`nostalgy-palette-overrides') until a hex string, `unspecified',
or nil is reached.")


;;;; Preset overrides

(defconst nostalgy-preset-overrides-colorful
  '((keyword      green-warmer)
    (builtin      green)
    (string       yellow-warmer)
    (type         yellow)
    (constant     yellow-warmer)
    (number       yellow-warmer)
    (fnname       blue)
    (variable     yellow-faint)
    (property     cyan-faint)
    (preprocessor red-warmer)
    (comment      green-cooler)
    (docstring    green-faint)
    (rx-construct green-cooler)
    (delimiter    rust)
    (operator     yellow-faint)
    (fg-heading-1 cyan-warmer)
    (fg-prose-code yellow-warmer)
    (fg-prose-verbatim yellow))
  "Overrides that reproduce the busier, multi-hue reference look.
Assign to `nostalgy-palette-overrides' before loading the theme.")


;;;; Palette resolution

(defun nostalgy--all-entries ()
  "Return the working palette: overrides first, then defaults."
  (append (and (boundp 'nostalgy-palette-overrides) nostalgy-palette-overrides)
          nostalgy-palette))

(defun nostalgy--lookup (name entries seen)
  "Resolve palette key NAME within ENTRIES, tracking SEEN keys."
  (when (memq name seen)
    (error "Nostalgy: circular palette reference through `%s'" name))
  (let ((cell (assq name entries)))
    (cond
     ((null cell)
      (if (or (stringp name) (null name) (eq name 'unspecified))
          name
        (error "Nostalgy: palette key `%s' is undefined" name)))
     (t
      (let ((val (nth 1 cell)))
        (if (and val (symbolp val) (not (eq val 'unspecified)))
            (nostalgy--lookup val entries (cons name seen))
          val))))))

(defun nostalgy-get-color-value (name)
  "Return the final colour value bound to palette key NAME."
  (nostalgy--lookup name (nostalgy--all-entries) nil))

(defmacro nostalgy-with-colors (&rest body)
  "Evaluate BODY with every palette key bound as a variable."
  (declare (indent 0))
  (let* ((entries (nostalgy--all-entries))
         (names (delete-dups (mapcar #'car entries))))
    `(let* ,(mapcar (lambda (n)
                      (list n (list 'nostalgy-get-color-value (list 'quote n))))
                    names)
       (ignore ,@names)
       ,@body)))

) ; end eval-and-compile


;;;; Faces

(defun nostalgy--faces ()
  "Return the face specification for `custom-theme-set-faces'."
  (nostalgy-with-colors
    `(
;;; Core
      (default ((t :background ,bg-main :foreground ,fg-main)))
      (cursor ((t :background ,cursor)))
      (fringe ((t :background ,bg-main :foreground ,fg-dim)))
      (region ((t :background ,bg-region :foreground ,fg-region :extend t)))
      (secondary-selection ((t :background ,bg-hover-secondary :extend t)))
      (highlight ((t :background ,bg-hover :foreground ,fg-main)))
      (hl-line ((t :background ,bg-hl-line :extend t)))
      (shadow ((t :foreground ,fg-dim)))
      (match ((t :background ,bg-search-lazy :foreground ,fg-search-lazy)))
      (error ((t :foreground ,err :weight normal)))
      (warning ((t :foreground ,warning :weight normal)))
      (success ((t :foreground ,success :weight normal)))
      (escape-glyph ((t :foreground ,escape-char)))
      (homoglyph ((t :foreground ,yellow-warmer)))
      (nobreak-space ((t :foreground ,red-faint :underline t)))
      (nobreak-hyphen ((t :foreground ,red-faint)))
      (trailing-whitespace ((t :background ,bg-red-intense)))
      (tabulated-list-fake-header ((t :foreground ,fg-main :weight normal :underline t)))
      (button ((t :foreground ,fg-link :underline t)))
      (link ((t :foreground ,fg-link :underline ,underline-link)))
      (link-visited ((t :foreground ,fg-link-visited :underline ,underline-link-visited)))
      (help-key-binding ((t :background ,bg-dim :foreground ,cyan-cooler :box (:line-width 1 :color ,border))))
      (tooltip ((t :background ,bg-dim :foreground ,fg-main)))
      (menu ((t :background ,bg-dim :foreground ,fg-main)))
      (minibuffer-prompt ((t :foreground ,fg-prompt)))
      (fill-column-indicator ((t :foreground ,bg-alt)))
      (vertical-border ((t :foreground ,fg-window-divider-inner)))
      (window-divider ((t :foreground ,fg-window-divider-inner)))
      (window-divider-first-pixel ((t :foreground ,fg-window-divider-outer)))
      (window-divider-last-pixel ((t :foreground ,fg-window-divider-outer)))
      (separator-line ((t :background ,border)))
      (pulse-highlight-start-face ((t :background ,bg-cyan-intense)))

;;; Line numbers
      (line-number ((t :inherit default :background ,bg-line-number-inactive :foreground ,fg-line-number-inactive)))
      (line-number-current-line ((t :inherit default :background ,bg-line-number-active :foreground ,fg-line-number-active :weight normal)))
      (line-number-major-tick ((t :background ,bg-yellow-subtle :foreground ,fg-main)))
      (line-number-minor-tick ((t :background ,bg-dim :foreground ,fg-dim)))

;;; Mode line
      (mode-line ((t :background ,bg-mode-line-active :foreground ,fg-mode-line-active :box nil)))
      (mode-line-active ((t :inherit mode-line)))
      (mode-line-inactive ((t :background ,bg-mode-line-inactive :foreground ,fg-mode-line-inactive :box (:line-width 1 :color ,border-mode-line-inactive))))
      (mode-line-highlight ((t :background ,bg-hover :foreground ,fg-main :box (:line-width 1 :color ,border))))
      (mode-line-emphasis ((t :foreground ,cyan-cooler :weight normal)))
      (mode-line-buffer-id ((t :weight normal)))
      (header-line ((t :background ,bg-dim :foreground ,fg-main)))
      (header-line-highlight ((t :inherit mode-line-highlight)))

;;; Font lock
      (font-lock-builtin-face ((t :foreground ,builtin)))
      (font-lock-comment-face ((t :foreground ,comment :slant italic)))
      (font-lock-comment-delimiter-face ((t :foreground ,comment :slant italic)))
      (font-lock-constant-face ((t :foreground ,constant)))
      (font-lock-doc-face ((t :foreground ,docstring :slant italic)))
      (font-lock-doc-markup-face ((t :foreground ,docmarkup)))
      (font-lock-function-name-face ((t :foreground ,fnname)))
      (font-lock-function-call-face ((t :foreground ,fnname)))
      (font-lock-keyword-face ((t :foreground ,keyword :weight normal)))
      (font-lock-negation-char-face ((t :foreground ,red-warmer :weight normal)))
      (font-lock-number-face ((t :foreground ,number)))
      (font-lock-operator-face ((t :foreground ,operator)))
      (font-lock-preprocessor-face ((t :foreground ,preprocessor)))
      (font-lock-property-name-face ((t :foreground ,property)))
      (font-lock-property-use-face ((t :foreground ,property)))
      (font-lock-punctuation-face ((t :foreground ,punctuation)))
      (font-lock-bracket-face ((t :foreground ,bracket)))
      (font-lock-delimiter-face ((t :foreground ,delimiter)))
      (font-lock-escape-face ((t :foreground ,escape-char)))
      (font-lock-regexp-face ((t :foreground ,string)))
      (font-lock-regexp-grouping-backslash ((t :foreground ,rx-backslash :weight normal)))
      (font-lock-regexp-grouping-construct ((t :foreground ,rx-construct :weight normal)))
      (font-lock-string-face ((t :foreground ,string)))
      (font-lock-type-face ((t :foreground ,type)))
      (font-lock-variable-name-face ((t :foreground ,variable)))
      (font-lock-variable-use-face ((t :foreground ,variable)))
      (font-lock-warning-face ((t :foreground ,warning :weight normal)))

;;; isearch / occur
      (isearch ((t :background ,bg-search-current :foreground ,fg-search-current :weight normal)))
      (isearch-fail ((t :background ,bg-removed :foreground ,fg-removed)))
      (isearch-group-1 ((t :background ,bg-magenta-intense :foreground ,fg-main)))
      (isearch-group-2 ((t :background ,bg-green-intense :foreground ,fg-main)))
      (lazy-highlight ((t :background ,bg-search-lazy :foreground ,fg-search-lazy)))
      (query-replace ((t :inherit isearch)))
      (isearch-lazy-count-prefix ((t :foreground ,fg-dim)))
      (isearch-lazy-count-suffix ((t :foreground ,fg-dim)))

;;; Parens
      (show-paren-match ((t :background ,bg-paren-match :foreground ,fg-paren-match :weight normal)))
      (show-paren-match-expression ((t :background ,bg-cyan-subtle :extend t)))
      (show-paren-mismatch ((t :background ,bg-paren-mismatch :foreground ,bg-main :weight normal)))

;;; Completions (default UI)
      (completions-common-part ((t :foreground ,fg-completion-match-0 :weight normal)))
      (completions-first-difference ((t :foreground ,fg-completion-match-1 :weight normal)))
      (completions-annotations ((t :foreground ,identifier-fg :slant italic)))
      (completions-group-title ((t :foreground ,fg-dim :slant italic)))
      (completions-highlight ((t :background ,bg-hover :foreground ,fg-main)))

;;; orderless
      (orderless-match-face-0 ((t :foreground ,fg-completion-match-0 :weight normal)))
      (orderless-match-face-1 ((t :foreground ,fg-completion-match-1 :weight normal)))
      (orderless-match-face-2 ((t :foreground ,fg-completion-match-2 :weight normal)))
      (orderless-match-face-3 ((t :foreground ,fg-completion-match-3 :weight normal)))

;;; vertico / selectrum / icomplete
      (vertico-current ((t :background ,bg-hl-line :foreground ,fg-main :extend t)))
      (vertico-group-title ((t :foreground ,fg-dim :slant italic)))
      (vertico-group-separator ((t :foreground ,fg-dim :strike-through t)))
      (icomplete-first-match ((t :foreground ,cyan :weight normal)))
      (icomplete-selected-match ((t :background ,bg-hl-line :extend t)))

;;; marginalia
      (marginalia-key ((t :foreground ,cyan-cooler)))
      (marginalia-documentation ((t :foreground ,identifier-fg :slant italic)))
      (marginalia-file-name ((t :foreground ,fg-dim)))
      (marginalia-number ((t :foreground ,number)))
      (marginalia-size ((t :foreground ,green)))
      (marginalia-modified ((t :foreground ,warning)))

;;; consult
      (consult-file ((t :foreground ,fg-dim)))
      (consult-line-number ((t :foreground ,fg-line-number-inactive)))
      (consult-line-number-prefix ((t :foreground ,fg-line-number-inactive)))
      (consult-bookmark ((t :foreground ,blue)))
      (consult-async-running ((t :foreground ,warning)))
      (consult-async-finished ((t :foreground ,success)))

;;; corfu
      (corfu-default ((t :background ,bg-dim :foreground ,fg-main)))
      (corfu-current ((t :background ,bg-hl-line :foreground ,fg-main)))
      (corfu-bar ((t :background ,cyan-cooler)))
      (corfu-border ((t :background ,border)))
      (corfu-annotations ((t :foreground ,identifier-fg :slant italic)))

;;; company
      (company-tooltip ((t :background ,bg-dim :foreground ,fg-main)))
      (company-tooltip-selection ((t :background ,bg-hl-line)))
      (company-tooltip-common ((t :foreground ,fg-completion-match-0 :weight normal)))
      (company-tooltip-annotation ((t :foreground ,identifier-fg :slant italic)))
      (company-scrollbar-bg ((t :background ,bg-alt)))
      (company-scrollbar-fg ((t :background ,cyan-cooler)))
      (company-preview ((t :foreground ,fg-dim)))
      (company-preview-common ((t :foreground ,cyan :weight normal)))

;;; which-key
      (which-key-key-face ((t :foreground ,cyan-cooler :weight normal)))
      (which-key-command-description-face ((t :foreground ,fg-main)))
      (which-key-group-description-face ((t :foreground ,green)))
      (which-key-separator-face ((t :foreground ,fg-dim)))

;;; tab-bar / tab-line
      (tab-bar ((t :background ,bg-tab-bar :foreground ,fg-main)))
      (tab-bar-tab ((t :background ,bg-tab-current :foreground ,fg-main :box (:line-width 2 :color ,bg-tab-current) :weight normal)))
      (tab-bar-tab-inactive ((t :background ,bg-tab-other :foreground ,fg-dim :box (:line-width 2 :color ,bg-tab-other))))
      (tab-bar-tab-group-current ((t :foreground ,cyan-cooler :weight normal)))
      (tab-bar-tab-group-inactive ((t :foreground ,fg-dim)))
      (tab-line ((t :background ,bg-tab-bar :foreground ,fg-main)))
      (tab-line-tab ((t :inherit tab-bar-tab)))
      (tab-line-tab-current ((t :inherit tab-bar-tab)))
      (tab-line-tab-inactive ((t :inherit tab-bar-tab-inactive)))

;;; dired
      (dired-directory ((t :foreground ,blue :weight normal)))
      (dired-symlink ((t :foreground ,fg-link-symbolic :slant italic)))
      (dired-broken-symlink ((t :foreground ,red-warmer :underline t)))
      (dired-header ((t :foreground ,cyan-warmer :weight normal)))
      (dired-mark ((t :foreground ,fg-mark-select :weight normal)))
      (dired-marked ((t :background ,bg-mark-select :foreground ,fg-mark-select :weight normal)))
      (dired-flagged ((t :background ,bg-mark-delete :foreground ,fg-mark-delete :weight normal)))
      (dired-perm-write ((t :foreground ,yellow-warmer)))
      (dired-special ((t :foreground ,magenta-cooler)))
      (dired-ignored ((t :foreground ,fg-dim)))

;;; diff-mode
      (diff-header ((t :foreground ,fg-dim)))
      (diff-file-header ((t :foreground ,cyan-warmer :weight normal)))
      (diff-hunk-header ((t :background ,bg-changed :foreground ,fg-changed :weight normal :extend t)))
      (diff-function ((t :foreground ,fg-dim)))
      (diff-index ((t :foreground ,fg-dim)))
      (diff-context ((t :foreground ,fg-main)))
      (diff-added ((t :background ,bg-added :foreground ,fg-added :extend t)))
      (diff-removed ((t :background ,bg-removed :foreground ,fg-removed :extend t)))
      (diff-changed ((t :background ,bg-changed :foreground ,fg-changed :extend t)))
      (diff-refine-added ((t :background ,bg-added-refine :foreground ,fg-added :weight normal)))
      (diff-refine-removed ((t :background ,bg-removed-refine :foreground ,fg-removed :weight normal)))
      (diff-refine-changed ((t :background ,bg-changed-refine :foreground ,fg-changed :weight normal)))
      (diff-indicator-added ((t :inherit diff-added :foreground ,green-warmer)))
      (diff-indicator-removed ((t :inherit diff-removed :foreground ,red-warmer)))
      (diff-indicator-changed ((t :inherit diff-changed :foreground ,yellow)))

;;; ediff
      (ediff-current-diff-A ((t :background ,bg-removed :extend t)))
      (ediff-current-diff-B ((t :background ,bg-added :extend t)))
      (ediff-current-diff-C ((t :background ,bg-changed :extend t)))
      (ediff-current-diff-Ancestor ((t :background ,bg-blue-subtle :extend t)))
      (ediff-fine-diff-A ((t :background ,bg-removed-refine :weight normal)))
      (ediff-fine-diff-B ((t :background ,bg-added-refine :weight normal)))
      (ediff-fine-diff-C ((t :background ,bg-changed-refine :weight normal)))
      (ediff-even-diff-A ((t :background ,bg-dim :extend t)))
      (ediff-even-diff-B ((t :background ,bg-dim :extend t)))
      (ediff-even-diff-C ((t :background ,bg-dim :extend t)))
      (ediff-odd-diff-A ((t :background ,bg-inactive :extend t)))
      (ediff-odd-diff-B ((t :background ,bg-inactive :extend t)))
      (ediff-odd-diff-C ((t :background ,bg-inactive :extend t)))

;;; magit
      (magit-section-heading ((t :foreground ,cyan-warmer :weight normal)))
      (magit-section-heading-selection ((t :background ,bg-hl-line :foreground ,fg-main :extend t)))
      (magit-section-highlight ((t :background ,bg-hl-line :extend t)))
      (magit-diff-file-heading ((t :foreground ,fg-main :weight normal)))
      (magit-diff-file-heading-highlight ((t :background ,bg-hl-line :weight normal :extend t)))
      (magit-diff-hunk-heading ((t :background ,bg-changed-faint :foreground ,fg-changed :extend t)))
      (magit-diff-hunk-heading-highlight ((t :background ,bg-changed :foreground ,fg-changed :weight normal :extend t)))
      (magit-diff-context ((t :foreground ,fg-dim :extend t)))
      (magit-diff-context-highlight ((t :background ,bg-dim :foreground ,fg-main :extend t)))
      (magit-diff-added ((t :background ,bg-added-faint :foreground ,fg-added :extend t)))
      (magit-diff-added-highlight ((t :background ,bg-added :foreground ,fg-added :extend t)))
      (magit-diff-removed ((t :background ,bg-removed-faint :foreground ,fg-removed :extend t)))
      (magit-diff-removed-highlight ((t :background ,bg-removed :foreground ,fg-removed :extend t)))
      (magit-diffstat-added ((t :foreground ,green-warmer)))
      (magit-diffstat-removed ((t :foreground ,red-warmer)))
      (magit-branch-local ((t :foreground ,cyan-cooler :weight normal)))
      (magit-branch-remote ((t :foreground ,green-warmer :weight normal)))
      (magit-branch-current ((t :foreground ,cyan :box (:line-width 1 :color ,border))))
      (magit-tag ((t :foreground ,yellow-warmer)))
      (magit-hash ((t :foreground ,identifier-fg)))
      (magit-log-author ((t :foreground ,rust)))
      (magit-log-date ((t :foreground ,fg-dim)))
      (magit-log-graph ((t :foreground ,fg-dim)))
      (magit-process-ok ((t :foreground ,success :weight normal)))
      (magit-process-ng ((t :foreground ,err :weight normal)))
      (magit-bisect-good ((t :foreground ,success)))
      (magit-bisect-bad ((t :foreground ,err)))
      (magit-bisect-skip ((t :foreground ,warning)))
      (magit-blame-heading ((t :background ,bg-dim :foreground ,fg-main :extend t)))
      (magit-blame-name ((t :foreground ,rust)))
      (magit-blame-date ((t :foreground ,fg-dim)))
      (magit-blame-summary ((t :foreground ,fg-main)))
      (magit-reflog-commit ((t :foreground ,green-warmer)))
      (magit-reflog-amend ((t :foreground ,magenta-cooler)))
      (magit-reflog-merge ((t :foreground ,green-warmer)))
      (magit-reflog-checkout ((t :foreground ,blue)))
      (magit-reflog-reset ((t :foreground ,red-warmer)))
      (magit-reflog-rebase ((t :foreground ,magenta-cooler)))
      (magit-reflog-cherry-pick ((t :foreground ,green-warmer)))

;;; VC / diff fringe
      (vc-edited-state ((t :foreground ,warning)))
      (vc-locally-added-state ((t :foreground ,success)))
      (vc-removed-state ((t :foreground ,err)))
      (vc-conflict-state ((t :foreground ,err :weight normal)))
      (vc-dir-header ((t :foreground ,cyan-warmer :weight normal)))
      (smerge-upper ((t :background ,bg-removed :extend t)))
      (smerge-lower ((t :background ,bg-added :extend t)))
      (smerge-base ((t :background ,bg-changed :extend t)))
      (smerge-markers ((t :background ,bg-dim :foreground ,fg-dim :weight normal :extend t)))
      (smerge-refined-added ((t :background ,bg-added-refine :weight normal)))
      (smerge-refined-removed ((t :background ,bg-removed-refine :weight normal)))

;;; git-gutter / diff-hl
      (git-gutter:added ((t :background ,bg-main :foreground ,green-warmer)))
      (git-gutter:deleted ((t :background ,bg-main :foreground ,red-warmer)))
      (git-gutter:modified ((t :background ,bg-main :foreground ,yellow)))
      (git-gutter-fr:added ((t :foreground ,green-warmer)))
      (git-gutter-fr:deleted ((t :foreground ,red-warmer)))
      (git-gutter-fr:modified ((t :foreground ,yellow)))
      (diff-hl-insert ((t :background ,bg-added :foreground ,green-warmer)))
      (diff-hl-delete ((t :background ,bg-removed :foreground ,red-warmer)))
      (diff-hl-change ((t :background ,bg-changed :foreground ,yellow)))

;;; flymake / flycheck / flyspell
      (flymake-error ((t :underline (:style wave :color ,red-warmer))))
      (flymake-warning ((t :underline (:style wave :color ,yellow))))
      (flymake-note ((t :underline (:style wave :color ,cyan-cooler))))
      (flymake-error-echo ((t :foreground ,red-warmer)))
      (flymake-warning-echo ((t :foreground ,yellow)))
      (flymake-note-echo ((t :foreground ,cyan-cooler)))
      (flycheck-error ((t :underline (:style wave :color ,red-warmer))))
      (flycheck-warning ((t :underline (:style wave :color ,yellow))))
      (flycheck-info ((t :underline (:style wave :color ,cyan-cooler))))
      (flycheck-fringe-error ((t :foreground ,red-warmer)))
      (flycheck-fringe-warning ((t :foreground ,yellow)))
      (flycheck-fringe-info ((t :foreground ,cyan-cooler)))
      (flyspell-incorrect ((t :underline (:style wave :color ,red-warmer))))
      (flyspell-duplicate ((t :underline (:style wave :color ,yellow))))

;;; compilation
      (compilation-error ((t :foreground ,err :weight normal)))
      (compilation-warning ((t :foreground ,warning :weight normal)))
      (compilation-info ((t :foreground ,info :weight normal)))
      (compilation-line-number ((t :foreground ,fg-line-number-inactive)))
      (compilation-column-number ((t :foreground ,fg-line-number-inactive)))
      (compilation-mode-line-exit ((t :foreground ,success :weight normal)))
      (compilation-mode-line-fail ((t :foreground ,err :weight normal)))
      (compilation-mode-line-run ((t :foreground ,warning :weight normal)))

;;; eshell / term / ansi
      (eshell-prompt ((t :foreground ,fg-prompt :weight normal)))
      (eshell-ls-directory ((t :foreground ,blue :weight normal)))
      (eshell-ls-symlink ((t :foreground ,fg-link-symbolic :slant italic)))
      (eshell-ls-executable ((t :foreground ,green-warmer)))
      (eshell-ls-archive ((t :foreground ,magenta-cooler)))
      (eshell-ls-backup ((t :foreground ,fg-dim)))
      (eshell-ls-missing ((t :foreground ,red-warmer)))
      (eshell-ls-product ((t :foreground ,yellow-warmer)))
      (eshell-ls-readonly ((t :foreground ,fg-dim)))
      (eshell-ls-special ((t :foreground ,magenta-cooler)))
      (eshell-ls-unreadable ((t :foreground ,red-faint)))
      (term-color-black ((t :background ,bg-inactive :foreground ,bg-inactive)))
      (term-color-red ((t :background ,red-warmer :foreground ,red-warmer)))
      (term-color-green ((t :background ,green-warmer :foreground ,green-warmer)))
      (term-color-yellow ((t :background ,yellow :foreground ,yellow)))
      (term-color-blue ((t :background ,blue :foreground ,blue)))
      (term-color-magenta ((t :background ,magenta :foreground ,magenta)))
      (term-color-cyan ((t :background ,cyan-cooler :foreground ,cyan-cooler)))
      (term-color-white ((t :background ,fg-alt :foreground ,fg-alt)))

;;; org-mode
      (org-level-1 ((t :foreground ,fg-heading-1 :weight normal)))
      (org-level-2 ((t :foreground ,fg-heading-2 :weight normal)))
      (org-level-3 ((t :foreground ,fg-heading-3 :weight normal)))
      (org-level-4 ((t :foreground ,fg-heading-4 :weight normal)))
      (org-level-5 ((t :foreground ,fg-heading-5 :weight normal)))
      (org-level-6 ((t :foreground ,fg-heading-6 :weight normal)))
      (org-level-7 ((t :foreground ,fg-heading-7 :weight normal)))
      (org-level-8 ((t :foreground ,fg-heading-8 :weight normal)))
      (org-document-title ((t :foreground ,fg-heading-0 :weight normal)))
      (org-document-info ((t :foreground ,cyan-cooler)))
      (org-document-info-keyword ((t :foreground ,fg-dim)))
      (org-headline-done ((t :foreground ,fg-dim)))
      (org-archived ((t :foreground ,fg-dim)))
      (org-block ((t :background ,bg-prose-block-contents :extend t)))
      (org-block-begin-line ((t :background ,bg-dim :foreground ,fg-prose-block-delimiter :extend t)))
      (org-block-end-line ((t :background ,bg-dim :foreground ,fg-prose-block-delimiter :extend t)))
      (org-code ((t :foreground ,fg-prose-code)))
      (org-verbatim ((t :foreground ,fg-prose-verbatim)))
      (org-macro ((t :foreground ,fg-prose-macro)))
      (org-formula ((t :foreground ,yellow-warmer)))
      (org-table ((t :foreground ,fg-prose-table)))
      (org-table-header ((t :background ,bg-dim :foreground ,fg-main :weight normal)))
      (org-drawer ((t :foreground ,fg-dim)))
      (org-special-keyword ((t :foreground ,fg-dim)))
      (org-meta-line ((t :foreground ,fg-dim :slant italic)))
      (org-quote ((t :foreground ,fg-dim :slant italic :extend t)))
      (org-verse ((t :inherit org-quote)))
      (org-ellipsis ((t :foreground ,yellow-warmer)))
      (org-link ((t :inherit link)))
      (org-footnote ((t :foreground ,cyan-cooler :underline t)))
      (org-date ((t :foreground ,cyan-cooler :underline t)))
      (org-date-selected ((t :background ,bg-cyan-intense :foreground ,fg-main)))
      (org-sexp-date ((t :foreground ,cyan-cooler)))
      (org-todo ((t :foreground ,prose-todo :weight normal)))
      (org-done ((t :foreground ,prose-done :weight normal)))
      (org-checkbox ((t :foreground ,green-warmer :weight normal)))
      (org-checkbox-statistics-todo ((t :foreground ,prose-todo)))
      (org-checkbox-statistics-done ((t :foreground ,prose-done)))
      (org-priority ((t :foreground ,magenta-cooler)))
      (org-tag ((t :foreground ,fg-prose-tag :weight normal)))
      (org-tag-group ((t :foreground ,fg-prose-tag :weight normal)))
      (org-agenda-structure ((t :foreground ,cyan-warmer :weight normal)))
      (org-agenda-date ((t :foreground ,fg-heading-2 :weight normal)))
      (org-agenda-date-today ((t :foreground ,cyan :weight normal :underline t)))
      (org-agenda-date-weekend ((t :foreground ,fg-dim :weight normal)))
      (org-agenda-current-time ((t :foreground ,cyan :weight normal)))
      (org-agenda-done ((t :foreground ,prose-done)))
      (org-scheduled ((t :foreground ,yellow)))
      (org-scheduled-today ((t :foreground ,yellow-warmer :weight normal)))
      (org-scheduled-previously ((t :foreground ,red-faint)))
      (org-upcoming-deadline ((t :foreground ,red-faint)))
      (org-warning ((t :foreground ,warning :weight normal)))
      (org-time-grid ((t :foreground ,fg-dim)))
      (org-column ((t :background ,bg-dim)))
      (org-column-title ((t :background ,bg-dim :foreground ,fg-main :weight normal :underline t)))
      (org-hide ((t :foreground ,bg-main)))
      (org-indent ((t :inherit (org-hide fixed-pitch))))

;;; outline (fallback / prog headings)
      ;; Defined directly, not via `:inherit org-level-N': the stock
      ;; `org-level-N' faces already inherit `outline-N', so inheriting
      ;; back the other way produces a face inheritance cycle.
      (outline-1 ((t :foreground ,fg-heading-1 :weight normal)))
      (outline-2 ((t :foreground ,fg-heading-2 :weight normal)))
      (outline-3 ((t :foreground ,fg-heading-3 :weight normal)))
      (outline-4 ((t :foreground ,fg-heading-4 :weight normal)))
      (outline-5 ((t :foreground ,fg-heading-5 :weight normal)))
      (outline-6 ((t :foreground ,fg-heading-6 :weight normal)))
      (outline-7 ((t :foreground ,fg-heading-7 :weight normal)))
      (outline-8 ((t :foreground ,fg-heading-8 :weight normal)))
      (outline-minor-1 ((t :inherit outline-1)))

;;; markdown
      (markdown-header-face-1 ((t :inherit org-level-1)))
      (markdown-header-face-2 ((t :inherit org-level-2)))
      (markdown-header-face-3 ((t :inherit org-level-3)))
      (markdown-header-face-4 ((t :inherit org-level-4)))
      (markdown-header-face-5 ((t :inherit org-level-5)))
      (markdown-header-face-6 ((t :inherit org-level-6)))
      (markdown-header-delimiter-face ((t :foreground ,fg-dim)))
      (markdown-metadata-key-face ((t :foreground ,fg-dim)))
      (markdown-metadata-value-face ((t :foreground ,fg-main)))
      (markdown-code-face ((t :background ,bg-prose-block-contents :extend t)))
      (markdown-inline-code-face ((t :foreground ,fg-prose-code)))
      (markdown-pre-face ((t :foreground ,fg-main)))
      (markdown-language-keyword-face ((t :foreground ,fg-dim :slant italic)))
      (markdown-list-face ((t :foreground ,yellow-warmer)))
      (markdown-markup-face ((t :foreground ,fg-dim)))
      (markdown-blockquote-face ((t :foreground ,fg-dim :slant italic)))
      (markdown-link-face ((t :inherit link)))
      (markdown-url-face ((t :foreground ,fg-dim)))
      (markdown-bold-face ((t :foreground ,fg-main :weight normal)))
      (markdown-italic-face ((t :foreground ,fg-main :slant italic)))
      (markdown-table-face ((t :foreground ,fg-prose-table)))
      (markdown-gfm-checkbox-face ((t :foreground ,green-warmer)))

;;; whitespace-mode
      (whitespace-space ((t :background ,bg-main :foreground ,bg-alt)))
      (whitespace-hspace ((t :background ,bg-main :foreground ,bg-alt)))
      (whitespace-tab ((t :background ,bg-main :foreground ,bg-alt)))
      (whitespace-newline ((t :foreground ,bg-alt)))
      (whitespace-trailing ((t :background ,bg-red-intense)))
      (whitespace-line ((t :background ,bg-yellow-subtle)))
      (whitespace-empty ((t :background ,bg-yellow-subtle)))
      (whitespace-indentation ((t :background ,bg-main :foreground ,bg-alt)))
      (whitespace-big-indent ((t :background ,bg-red-subtle)))
      (whitespace-space-after-tab ((t :background ,bg-yellow-subtle)))
      (whitespace-space-before-tab ((t :background ,bg-red-subtle)))

;;; misc structural
      (highlight-numbers-number ((t :foreground ,number)))
      (rainbow-delimiters-depth-1-face ((t :foreground ,fg-main)))
      (rainbow-delimiters-depth-2-face ((t :foreground ,cyan-cooler)))
      (rainbow-delimiters-depth-3-face ((t :foreground ,green)))
      (rainbow-delimiters-depth-4-face ((t :foreground ,yellow-warmer)))
      (rainbow-delimiters-depth-5-face ((t :foreground ,magenta-cooler)))
      (rainbow-delimiters-depth-6-face ((t :foreground ,green-warmer)))
      (rainbow-delimiters-depth-7-face ((t :foreground ,blue)))
      (rainbow-delimiters-depth-8-face ((t :foreground ,rust)))
      (rainbow-delimiters-depth-9-face ((t :foreground ,fg-dim)))
      (rainbow-delimiters-mismatched-face ((t :foreground ,bg-main :background ,red-warmer :weight normal)))
      (rainbow-delimiters-unmatched-face ((t :foreground ,bg-main :background ,red-warmer :weight normal)))

;;; hl-todo / comment keywords
      (hl-todo ((t :foreground ,red-warmer :weight normal)))

;;; tree-sitter extras
      (font-lock-misc-punctuation-face ((t :foreground ,punctuation)))

;;; widgets
      (widget-field ((t :background ,bg-dim :foreground ,fg-main :extend t)))
      (widget-single-line-field ((t :background ,bg-dim :foreground ,fg-main)))
      (widget-button ((t :inherit button)))
      (widget-button-pressed ((t :foreground ,cyan-warmer)))
      (widget-documentation ((t :foreground ,docstring)))
      (widget-inactive ((t :foreground ,fg-dim)))
      (custom-button ((t :background ,bg-alt :foreground ,fg-main :box (:line-width 1 :color ,border))))
      (custom-button-mouse ((t :background ,bg-active :foreground ,fg-main :box (:line-width 1 :color ,border))))
      (custom-button-pressed ((t :background ,bg-active :foreground ,cyan-warmer :box (:line-width 1 :color ,border))))
      (custom-group-tag ((t :foreground ,fg-heading-2 :weight normal)))
      (custom-group-tag-1 ((t :foreground ,fg-heading-3 :weight normal)))
      (custom-variable-tag ((t :foreground ,fg-main :weight normal)))
      (custom-variable-obsolete ((t :foreground ,fg-dim)))
      (custom-state ((t :foreground ,success)))
      (custom-changed ((t :foreground ,warning)))
      (custom-modified ((t :foreground ,warning)))
      (custom-invalid ((t :foreground ,err :weight normal)))
      (custom-rogue ((t :foreground ,red-warmer)))
      (custom-set ((t :foreground ,success)))
      (custom-comment ((t :foreground ,fg-dim :slant italic)))
      (custom-comment-tag ((t :foreground ,fg-dim)))
      (custom-link ((t :inherit link)))

;;; info
      (info-title-1 ((t :inherit org-level-1)))
      (info-title-2 ((t :inherit org-level-2)))
      (info-title-3 ((t :inherit org-level-3)))
      (info-title-4 ((t :inherit org-level-4)))
      (info-menu-header ((t :foreground ,cyan-warmer :weight normal)))
      (info-menu-star ((t :foreground ,red-warmer)))
      (info-node ((t :foreground ,cyan-warmer :weight normal :slant italic)))
      (Info-quoted ((t :foreground ,fg-prose-verbatim)))

;;; message / gnus / notmuch essentials
      (message-header-name ((t :foreground ,fg-dim)))
      (message-header-to ((t :foreground ,fg-main :weight normal)))
      (message-header-cc ((t :foreground ,fg-main)))
      (message-header-subject ((t :foreground ,cyan-warmer :weight normal)))
      (message-header-other ((t :foreground ,fg-dim)))
      (message-header-newsgroups ((t :foreground ,yellow-warmer :weight normal)))
      (message-header-xheader ((t :foreground ,fg-dim)))
      (message-mml ((t :foreground ,green-warmer)))
      (message-cited-text-1 ((t :foreground ,cyan-cooler)))
      (message-cited-text-2 ((t :foreground ,green)))
      (message-cited-text-3 ((t :foreground ,yellow-warmer)))
      (message-cited-text-4 ((t :foreground ,magenta-cooler)))
      (message-separator ((t :foreground ,fg-dim)))

;;; ansi-color (Emacs 28+ vector via face list)
      (ansi-color-black ((t :background ,bg-inactive :foreground ,bg-inactive)))
      (ansi-color-red ((t :background ,red-warmer :foreground ,red-warmer)))
      (ansi-color-green ((t :background ,green-warmer :foreground ,green-warmer)))
      (ansi-color-yellow ((t :background ,yellow :foreground ,yellow)))
      (ansi-color-blue ((t :background ,blue :foreground ,blue)))
      (ansi-color-magenta ((t :background ,magenta :foreground ,magenta)))
      (ansi-color-cyan ((t :background ,cyan-cooler :foreground ,cyan-cooler)))
      (ansi-color-white ((t :background ,fg-alt :foreground ,fg-alt)))
      (ansi-color-bright-black ((t :background ,fg-dim :foreground ,fg-dim)))
      (ansi-color-bright-white ((t :background ,fg-main :foreground ,fg-main)))
      )))

(defun nostalgy--variables ()
  "Return the custom-variable specification for the theme."
  (nostalgy-with-colors
    `((ansi-color-names-vector
       [,bg-inactive ,red-warmer ,green-warmer ,yellow ,blue ,magenta ,cyan-cooler ,fg-alt]))))


;;;; Apply

(apply #'custom-theme-set-faces 'nostalgy (nostalgy--faces))
(apply #'custom-theme-set-variables 'nostalgy (nostalgy--variables))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'nostalgy)

(run-hooks 'nostalgy-after-load-theme-hook)

(provide 'nostalgy-theme)

;;; nostalgy-theme.el ends here
