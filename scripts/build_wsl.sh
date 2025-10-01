#!/usr/bin/env bash
set -euo pipefail
FILES=(
resume/main/Resume_Main.tex
resume/jb/Resume_JBHiFi_Burwood_Blue_Final.tex
resume/main/Cover_Letter_Main.tex
resume/jb/Cover_Letter_JBHiFi_Burwood_Blue_Final.tex
resume/main/Application_Pack_Main.tex
resume/jb/Application_Pack_JBHiFi_Burwood_Blue_Final.tex
)
for f in "${FILES[@]}"; do latexmk -pdf -halt-on-error -interaction=nonstopmode "$f"; done
for f in "${FILES[@]}"; do pandoc -s "$f" -o "${f%.tex}.docx"; done
