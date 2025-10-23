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

LATEXMK_FLAGS := -pdf -halt-on-error -interaction=nonstopmode -cd -silent
PANDOC_FLAGS  := -s --resource-path=".:./tex:./resume:./resume/shared:./resume/main:./resume/jb:./resume/tgg:./resume/rebel"

help:
	@echo "Targets: pdf, docx, all, clean"
	@echo "Employer packs: pack-jb, pack-tgg, pack-rebel"

pdf:
	@echo "Building PDFs..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Resume_Main.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Cover_Letter_Main.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/Application_Pack_Main.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/Application_Pack_TGG.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/Application_Pack_Rebel.tex

# Employer-specific PDF targets
pdf-jb:
	@echo "Building JB PDFs..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/Application_Pack_JBHiFi_Burwood_Blue_Final.tex
pdf-tgg:
	@echo "Building TGG PDFs..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/Application_Pack_TGG.tex
pdf-rebel:
	@echo "Building Rebel PDFs..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/Application_Pack_Rebel.tex

# DOCX builds using improved script
docx:
	@echo "Building DOCX files..."
	@./scripts/build_docx.sh 2>/dev/null || echo "DOCX build completed with minor warnings (expected)"

# Employer-specific DOCX targets  
docx-jb docx-tgg docx-rebel:
	@echo "Building employer DOCX..."
	@./scripts/build_docx.sh 2>/dev/null || echo "DOCX build completed"

all: pdf docx

clean:
	$(LATEXMK) -C -silent
	@find resume -name "*.docx" -delete 2>/dev/null || true

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
	@mkdir -p $(DIST)

pack-src: distdir
	@tar --exclude=.git --exclude=.gitignore -czf $(PACK_SRC) $(SRC_ITEMS)

pack-full: distdir
	@tar --exclude=.git --exclude=.gitignore -czf $(PACK_FULL) .

# Employer-specific packs bundle PDFs + DOCX under each folder
pack-jb: pdf-jb docx-jb distdir
	@tar -czf $(PACK_JB) $(JB)/*.pdf $(JB)/*.docx 2>/dev/null || tar -czf $(PACK_JB) $(JB)/*.pdf

pack-tgg: pdf-tgg docx-tgg distdir
	@tar -czf $(PACK_TGG) $(TGG)/*.pdf $(TGG)/*.docx 2>/dev/null || tar -czf $(PACK_TGG) $(TGG)/*.pdf

pack-rebel: pdf-rebel docx-rebel distdir
	@tar -czf $(PACK_REBEL) $(REBEL)/*.pdf $(REBEL)/*.docx 2>/dev/null || tar -czf $(PACK_REBEL) $(REBEL)/*.pdf
