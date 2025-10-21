# ---- Source items for packaging (tex optional) ----
SRC_ITEMS := resume Makefile README.md VERSION scripts
ifneq ("$(wildcard tex)","")
  SRC_ITEMS += tex
endif

.PHONY: help pdf docx all clean

MAIN := resume/main
JB   := resume/jb

LATEXMK := latexmk
PANDOC  := pandoc

LATEXMK_FLAGS := -pdf -halt-on-error -interaction=nonstopmode -cd
PANDOC_FLAGS  := -s --resource-path=".:./tex:./resume:./resume/main:./resume/jb"

help:
	@echo "Targets: pdf, docx, all, clean"

pdf:
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Resume_Main.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Cover_Letter_Main.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Application_Pack_Main.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/Resume_JBHiFi_Burwood_Blue_Final.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/Cover_Letter_JBHiFi_Burwood_Blue_Final.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex

docx:
	$(PANDOC) $(PANDOC_FLAGS) $(MAIN)/Resume_Main.tex -o $(MAIN)/Resume_Main.docx
	$(PANDOC) $(PANDOC_FLAGS) $(MAIN)/Cover_Letter_Main.tex -o $(MAIN)/Cover_Letter_Main.docx
	$(PANDOC) $(PANDOC_FLAGS) $(MAIN)/Application_Pack_Main.tex -o $(MAIN)/Application_Pack_Main.docx
	$(PANDOC) $(PANDOC_FLAGS) $(JB)/Resume_JBHiFi_Burwood_Blue_Final.tex -o $(JB)/Resume_JBHiFi_Burwood_Blue_Final.docx
	$(PANDOC) $(PANDOC_FLAGS) $(JB)/Cover_Letter_JBHiFi_Burwood_Blue_Final.tex -o $(JB)/Cover_Letter_JBHiFi_Burwood_Blue_Final.docx
	$(PANDOC) $(PANDOC_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex -o $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.docx

all: pdf docx

clean:
	$(LATEXMK) -C

# ---- Packaging (date + git hash) ----
DATE := $(shell date +%F)
HASH := $(shell git rev-parse --short HEAD 2>/dev/null || echo NOHASH)
DIST := dist
PACK_SRC  := $(DIST)/resume-retail_src_$(DATE)_$(HASH).tar.gz
PACK_FULL := $(DIST)/resume-retail_full_$(DATE)_$(HASH).tar.gz

.PHONY: pack pack-src pack-full distdir
pack: pack-src pack-full

distdir:
	mkdir -p $(DIST)

pack-src: distdir
	tar --exclude=.git --exclude=.gitignore -czf $(PACK_SRC) $(SRC_ITEMS)

pack-full: distdir
	tar --exclude=.git --exclude=.gitignore -czf $(PACK_FULL) .
