# ---- Source items for packaging (tex optional) ----
SRC_ITEMS := resume Makefile README.md VERSION scripts
ifneq ("$(wildcard tex)","")
  SRC_ITEMS += tex
endif

.PHONY: help pdf docx all clean pack pack-src pack-full distdir \
        pack-jb pack-tgg pack-rebel pdf-jb pdf-tgg pdf-rebel \
        docx-jb docx-tgg docx-rebel

MAIN := resume/main
JB   := resume/jb
TGG  := resume/tgg
REBEL:= resume/rebel

LATEXMK := latexmk
PANDOC  := pandoc

LATEXMK_FLAGS := -pdf -halt-on-error -interaction=nonstopmode -cd
PANDOC_FLAGS  := -s --resource-path=".:./tex:./resume:./resume/main:./resume/jb:./resume/tgg:./resume/rebel"

help:
	@echo "Targets: pdf, docx, all, clean"
	@echo "Employer packs: pack-jb, pack-tgg, pack-rebel"

pdf:
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Resume_Main.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Cover_Letter_Main.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Application_Pack_Main.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/Application_Pack_TGG.tex
	$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/Application_Pack_Rebel.tex

# Employer-specific PDF targets
pdf-jb:
	$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex
pdf-tgg:
	$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/Application_Pack_TGG.tex
pdf-rebel:
	$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/Application_Pack_Rebel.tex

# DOCX builds
docx:
	$(PANDOC) $(PANDOC_FLAGS) $(MAIN)/Resume_Main.tex -o $(MAIN)/Resume_Main.docx
	$(PANDOC) $(PANDOC_FLAGS) $(MAIN)/Cover_Letter_Main.tex -o $(MAIN)/Cover_Letter_Main.docx
	$(PANDOC) $(PANDOC_FLAGS) $(MAIN)/Application_Pack_Main.tex -o $(MAIN)/Application_Pack_Main.docx
	$(PANDOC) $(PANDOC_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex -o $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.docx
	$(PANDOC) $(PANDOC_FLAGS) $(TGG)/Application_Pack_TGG.tex -o $(TGG)/Application_Pack_TGG.docx
	$(PANDOC) $(PANDOC_FLAGS) $(REBEL)/Application_Pack_Rebel.tex -o $(REBEL)/Application_Pack_Rebel.docx

# Employer-specific DOCX targets
docx-jb:
	$(PANDOC) $(PANDOC_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex -o $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.docx
docx-tgg:
	$(PANDOC) $(PANDOC_FLAGS) $(TGG)/Application_Pack_TGG.tex -o $(TGG)/Application_Pack_TGG.docx
docx-rebel:
	$(PANDOC) $(PANDOC_FLAGS) $(REBEL)/Application_Pack_Rebel.tex -o $(REBEL)/Application_Pack_Rebel.docx

all: pdf docx

clean:
	$(LATEXMK) -C

# ---- Packaging (date + git hash) ----
DATE := $(shell date +%F)
HASH := $(shell git rev-parse --short HEAD 2>/dev/null || echo NOHASH)
DIST := dist
PACK_SRC  := $(DIST)/resume-retail_src_$(DATE)_$(HASH).tar.gz
PACK_FULL := $(DIST)/resume-retail_full_$(DATE)_$(HASH).tar.gz

# Employer pack tarballs
PACK_JB    := $(DIST)/jb_pack_$(DATE)_$(HASH).tar.gz
PACK_TGG   := $(DIST)/tgg_pack_$(DATE)_$(HASH).tar.gz
PACK_REBEL := $(DIST)/rebel_pack_$(DATE)_$(HASH).tar.gz

pack: pack-src pack-full

distdir:
	mkdir -p $(DIST)

pack-src: distdir
	tar --exclude=.git --exclude=.gitignore -czf $(PACK_SRC) $(SRC_ITEMS)

pack-full: distdir
	tar --exclude=.git --exclude=.gitignore -czf $(PACK_FULL) .

# Employer-specific packs bundle PDFs + DOCX under each folder
pack-jb: pdf-jb docx-jb distdir
	tar -czf $(PACK_JB) $(JB)/*.pdf $(JB)/*.docx

pack-tgg: pdf-tgg docx-tgg distdir
	tar -czf $(PACK_TGG) $(TGG)/*.pdf $(TGG)/*.docx

pack-rebel: pdf-rebel docx-rebel distdir
	tar -czf $(PACK_REBEL) $(REBEL)/*.pdf $(REBEL)/*.docx
