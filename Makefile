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
	@echo "Building all individual PDFs..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/AaronDeVries_Resume.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/AaronDeVries_CoverLetter.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/AaronDeVries_ApplicationPack.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/AaronDeVries_CoverLetter_JBHiFi_Burwood.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/AaronDeVries_FormAnswers_JBHiFi_Burwood.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/AaronDeVries_AaronDeVries_Checklist_JBHiFi_Burwood.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(JB)/AaronDeVries_ApplicationPack_JBHiFi_Burwood.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/AaronDeVries_CoverLetter_TheGoodGuys.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/AaronDeVries_ApplicationPack_TheGoodGuys.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/AaronDeVries_CoverLetter_RebelSport.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/AaronDeVries_ApplicationPack_RebelSport.tex
# Employer-specific PDF targets
pdf-main:
	@echo "Building main resume components..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/AaronDeVries_Resume.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/AaronDeVries_CoverLetter.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(MAIN)/AaronDeVries_ApplicationPack.tex
pdf-jb: resume/main/AaronDeVries_Resume.pdf
	$(MAKE) -C resume/jb pdf

resume/main/AaronDeVries_Resume.pdf:
	$(MAKE) -C resume/main pdf
pdf-tgg:
	@echo "Building TGG employer pack..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/AaronDeVries_CoverLetter_TheGoodGuys.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(TGG)/AaronDeVries_ApplicationPack_TheGoodGuys.tex
pdf-rebel:
	@echo "Building Rebel employer pack..."
	@$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/AaronDeVries_CoverLetter_RebelSport.tex
	@$(LATEXMK) $(LATEXMK_FLAGS) $(REBEL)/AaronDeVries_ApplicationPack_RebelSport.tex
# Employer-specific DOCX targets  
docx-jb docx-tgg docx-rebel:
	@echo "Building employer DOCX..."
	@python3 scripts/enhance_docx.py
all: pdf docx
clean:
	@echo "Cleaning all build artifacts..."
	@find . -name "*.fls" -exec latexmk -C -silent {} \; 2>/dev/null || true
	@find . -name "*.aux" -delete 2>/dev/null || true
	@find . -name "*.fls" -delete 2>/dev/null || true
	@find . -name "*.fdb_latexmk" -delete 2>/dev/null || true
	@find . -name "*.log" -delete 2>/dev/null || true
	@find . -name "*.out" -delete 2>/dev/null || true
	@find . -name "*.synctex.gz" -delete 2>/dev/null || true
	@find . -name "*.docx" -delete 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@echo "✅ Cleanup complete"
clean-pdf:
	@echo "Cleaning PDF files only..."
	@find . -name "*.pdf" -delete 2>/dev/null || true
	@echo "✅ PDFs removed"
clean-all: clean clean-pdf
	@echo "Deep clean: removing distribution files..."
	@rm -rf dist/ 2>/dev/null || true
	@echo "✅ Everything cleaned"
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
	@tar --exclude=.git --exclude=.gitignore --exclude=dist -czf $(PACK_FULL) .
# Employer-specific packs bundle PDFs + DOCX under each folder
pack-jb: pdf-jb docx-jb distdir
	@tar -czf $(PACK_JB) $(JB)/*.pdf $(JB)/*.docx 2>/dev/null || tar -czf $(PACK_JB) $(JB)/*.pdf
pack-tgg: pdf-tgg docx-tgg distdir
	@tar -czf $(PACK_TGG) $(TGG)/*.pdf $(TGG)/*.docx 2>/dev/null || tar -czf $(PACK_TGG) $(TGG)/*.pdf
pack-rebel: pdf-rebel docx-rebel distdir
	@tar -czf $(PACK_REBEL) $(REBEL)/*.pdf $(REBEL)/*.docx 2>/dev/null || tar -czf $(PACK_REBEL) $(REBEL)/*.pdf
