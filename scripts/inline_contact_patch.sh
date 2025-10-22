#!/usr/bin/env bash
set -euo pipefail

# Inline ContactBlock (FontAwesome5 + hidelinks)
read -r -d '' BLOCK <<'BLK'
% --- Inline Contact Block (FontAwesome5 + clickable links) ---
\usepackage{fontawesome5}
\usepackage[hidelinks]{hyperref}
\makeatletter
\providecommand{\ContactBlock}{}
\renewcommand{\ContactBlock}{%
{\Large \textbf{Aaron De Vries}}\par
{\color{MidBlue}\small
\faIcon{map-marker-alt}\, Homebush, NSW \quad\textbar\quad
\faIcon{phone}\, \href{tel:+61400375308}{0400 375 308} \quad\textbar\quad
\faIcon{envelope}\, \href{mailto:aarondevries@protonmail.com}{aarondevries@protonmail.com} \quad\textbar\quad
\faIcon[brands]{linkedin}\, \href{https://linkedin.com/in/aarondevriesdev}{linkedin.com/in/aarondevriesdev}%
}\par}
\makeatother
% --- End Inline Contact Block ---
BLK

fix_file () {
  f="$1"
  # Remove any macros_contact includes
  /usr/bin/sed -i '' -e 's@\\input{../../tex/macros_contact\.tex}@@g' \
                     -e 's@\\input{../tex/macros_contact\.tex}@@g' \
                     -e 's@\\input{./tex/macros_contact\.tex}@@g' "$f"

  perl -0777 -i -pe '
    # ensure fontawesome5 + hyperref after \documentclass (if missing)
    if (!/\\usepackage(?:\[[^\]]*\])?\{fontawesome5\}/) {
      s/(\\documentclass[^\n]*\n)/$1\\usepackage{fontawesome5}\n/s;
    }
    if (!/\\usepackage(?:\[[^\]]*\])?\{hyperref\}/) {
      s/(\\documentclass[^\n]*\n)/$1\\usepackage[hidelinks]{hyperref}\n/s;
    }

    # inject ContactBlock definition once before \begin{document}
    if (!/\\(re)?newcommand\{\\ContactBlock\}/s) {
      s/(\\begin\{document\})/$ENV{BLOCK}\n\n$1/s;
    }

    # ensure a call to \ContactBlock immediately after \begin{document}
    if ($ARGV ne "" && -T $ARGV) {
      if (/\\begin\{document\}((?:(?!\\end\{document\}).)*)/s) {
        my $body = $1;
        if ($body !~ /\\ContactBlock/) {
          s/\\begin\{document\}/\\begin{document}\n\\ContactBlock/s;
        }
      }
    }
  ' "$f"
}

export BLOCK

# Touch all TeX sources under resume/
find resume -type f -name '*.tex' | while read -r f; do
  fix_file "$f"
done

# Optional: quiet the harmless colors warning (ProvidesPackage vs \input)
for c in resume/main/colors.sty resume/jb/colors.sty; do
  [ -f "$c" ] && /usr/bin/sed -i '' 's/\\ProvidesPackage{colors}/\\ProvidesFile{colors.sty}/' "$c"
done

echo "Inline contact patch applied."
