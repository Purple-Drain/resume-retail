# Resume Retail Makefile (Extended)

LATEXMK := latexmk
LATEXMK_FLAGS := -pdf -interaction=nonstopmode

# Source file paths (original names)
MAIN_DIR := resume/main
JB_DIR := resume/jb
TGG_DIR := resume/tgg
REBEL_DIR := resume/rebel

APPLICATIONS_DIR := applications

.PHONY: all pdf pdf-main pdf-jb pdf-tgg pdf-rebel pdf-applications docx clean dirs

# Build all PDFs
all: pdf
	@echo "✅ All files built successfully"

pdf: pdf-main pdf-jb pdf-tgg pdf-rebel pdf-applications

# Main resume
pdf-main:
	@echo "Building main resume..."
	cd $(MAIN_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Resume_Main.tex
	@if [ -f $(MAIN_DIR)/Resume_Main.pdf ]; then \
		mv $(MAIN_DIR)/Resume_Main.pdf $(MAIN_DIR)/AaronDeVries_Resume.pdf; \
		echo "✓ Created AaronDeVries_Resume.pdf"; \
	fi
	@echo "Building main cover letter..."
	cd $(MAIN_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Cover_Letter_Main.tex
	@if [ -f $(MAIN_DIR)/Cover_Letter_Main.pdf ]; then \
		mv $(MAIN_DIR)/Cover_Letter_Main.pdf $(MAIN_DIR)/AaronDeVries_CoverLetter.pdf; \
		echo "✓ Created AaronDeVries_CoverLetter.pdf"; \
	fi
	@echo "Building main application pack..."
	cd $(MAIN_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Application_Pack_Main.tex
	@if [ -f $(MAIN_DIR)/Application_Pack_Main.pdf ]; then \
		mv $(MAIN_DIR)/Application_Pack_Main.pdf $(MAIN_DIR)/AaronDeVries_ApplicationPack.pdf; \
		echo "✓ Created AaronDeVries_ApplicationPack.pdf"; \
	fi

# JB Hi-Fi
pdf-jb:
	@echo "Building JB Hi-Fi documents..."
	cd $(JB_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Cover_Letter_JBHiFi_Burwood_Blue_Final.tex
	@if [ -f $(JB_DIR)/Cover_Letter_JBHiFi_Burwood_Blue_Final.pdf ]; then \
		mv $(JB_DIR)/Cover_Letter_JBHiFi_Burwood_Blue_Final.pdf $(JB_DIR)/AaronDeVries_CoverLetter_JBHiFi_Burwood.pdf; \
		echo "✓ Created AaronDeVries_CoverLetter_JBHiFi_Burwood.pdf"; \
	fi
	cd $(JB_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Application_Pack_JBHiFi_Burwood_Blue_Final.tex
	@if [ -f $(JB_DIR)/Application_Pack_JBHiFi_Burwood_Blue_Final.pdf ]; then \
		mv $(JB_DIR)/Application_Pack_JBHiFi_Burwood_Blue_Final.pdf $(JB_DIR)/AaronDeVries_ApplicationPack_JBHiFi_Burwood.pdf; \
		echo "✓ Created AaronDeVries_ApplicationPack_JBHiFi_Burwood.pdf"; \
	fi
	cd $(JB_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) JB_HiFi_Burwood_Form_Answers_Expanded.tex
	@if [ -f $(JB_DIR)/JB_HiFi_Burwood_Form_Answers_Expanded.pdf ]; then \
		mv $(JB_DIR)/JB_HiFi_Burwood_Form_Answers_Expanded.pdf $(JB_DIR)/AaronDeVries_FormAnswers_JBHiFi_Burwood.pdf; \
		echo "✓ Created AaronDeVries_FormAnswers_JBHiFi_Burwood.pdf"; \
	fi
	cd $(JB_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Checklist_JBHiFi_Burwood.tex
	@if [ -f $(JB_DIR)/Checklist_JBHiFi_Burwood.pdf ]; then \
		mv $(JB_DIR)/Checklist_JBHiFi_Burwood.pdf $(JB_DIR)/AaronDeVries_Checklist_JBHiFi_Burwood.pdf; \
		echo "✓ Created AaronDeVries_Checklist_JBHiFi_Burwood.pdf"; \
	fi

# The Good Guys
pdf-tgg:
	@echo "Building The Good Guys documents..."
	cd $(TGG_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Cover_Letter_TGG.tex
	@if [ -f $(TGG_DIR)/Cover_Letter_TGG.pdf ]; then \
		mv $(TGG_DIR)/Cover_Letter_TGG.pdf $(TGG_DIR)/AaronDeVries_CoverLetter_TheGoodGuys.pdf; \
		echo "✓ Created AaronDeVries_CoverLetter_TheGoodGuys.pdf"; \
	fi
	cd $(TGG_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Application_Pack_TGG.tex
	@if [ -f $(TGG_DIR)/Application_Pack_TGG.pdf ]; then \
		mv $(TGG_DIR)/Application_Pack_TGG.pdf $(TGG_DIR)/AaronDeVries_ApplicationPack_TheGoodGuys.pdf; \
		echo "✓ Created AaronDeVries_ApplicationPack_TheGoodGuys.pdf"; \
	fi

# Rebel Sport
pdf-rebel:
	@echo "Building Rebel Sport documents..."
	cd $(REBEL_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Cover_Letter_Rebel.tex
	@if [ -f $(REBEL_DIR)/Cover_Letter_Rebel.pdf ]; then \
		mv $(REBEL_DIR)/Cover_Letter_Rebel.pdf $(REBEL_DIR)/AaronDeVries_CoverLetter_RebelSport.pdf; \
		echo "✓ Created AaronDeVries_CoverLetter_RebelSport.pdf"; \
	fi
	cd $(REBEL_DIR) && $(LATEXMK) $(LATEXMK_FLAGS) Application_Pack_Rebel.tex
	@if [ -f $(REBEL_DIR)/Application_Pack_Rebel.pdf ]; then \
		mv $(REBEL_DIR)/Application_Pack_Rebel.pdf $(REBEL_DIR)/AaronDeVries_ApplicationPack_RebelSport.pdf; \
		echo "✓ Created AaronDeVries_ApplicationPack_RebelSport.pdf"; \
	fi

# Applications
pdf-applications:
	@echo "Building application cover letters..."
	cd $(APPLICATIONS_DIR)/HarveyNorman-OnlineCustomerService-HomebushWest/source && $(LATEXMK) $(LATEXMK_FLAGS) coverletter.tex
	@if [ -f $(APPLICATIONS_DIR)/HarveyNorman-OnlineCustomerService-HomebushWest/source/coverletter.pdf ]; then \
		mv $(APPLICATIONS_DIR)/HarveyNorman-OnlineCustomerService-HomebushWest/source/coverletter.pdf $(APPLICATIONS_DIR)/HarveyNorman-OnlineCustomerService-HomebushWest/exports/HarveyNorman_CoverLetter.pdf; \
		echo "✓ Created HarveyNorman_CoverLetter.pdf"; \
	fi
	cd $(APPLICATIONS_DIR)/ChemistWarehouse-PharmacyAssistant-VariousLocations/source && $(LATEXMK) $(LATEXMK_FLAGS) coverletter.tex
	@if [ -f $(APPLICATIONS_DIR)/ChemistWarehouse-PharmacyAssistant-VariousLocations/source/coverletter.pdf ]; then \
		mv $(APPLICATIONS_DIR)/ChemistWarehouse-PharmacyAssistant-VariousLocations/source/coverletter.pdf $(APPLICATIONS_DIR)/ChemistWarehouse-PharmacyAssistant-VariousLocations/exports/ChemistWarehouse_CoverLetter.pdf; \
		echo "✓ Created ChemistWarehouse_CoverLetter.pdf"; \
	fi

# Convert PDFs to DOCX (requires pandoc installed)
docx:
	@echo "Converting PDFs to DOCX..."
	pandoc $(APPLICATIONS_DIR)/HarveyNorman-OnlineCustomerService-HomebushWest/source/coverletter.tex -o $(APPLICATIONS_DIR)/HarveyNorman-OnlineCustomerService-HomebushWest/exports/HarveyNorman_CoverLetter.docx
	pandoc $(APPLICATIONS_DIR)/ChemistWarehouse-PharmacyAssistant-VariousLocations/source/coverletter.tex -o $(APPLICATIONS_DIR)/ChemistWarehouse-PharmacyAssistant-VariousLocations/exports/ChemistWarehouse_CoverLetter.docx

# Clean build artifacts
clean:
	@echo "Cleaning all build artifacts..."
	@find resume -name "*.aux" -delete
	@find resume -name "*.log" -delete
	@find resume -name "*.out" -delete
	@find resume -name "*.synctex.gz" -delete
	@find resume -name "*.fdb_latexmk" -delete
	@find resume -name "*.fls" -delete
	@find $(APPLICATIONS_DIR) -name "*.aux" -delete
	@find $(APPLICATIONS_DIR) -name "*.log" -delete
	@find $(APPLICATIONS_DIR) -name "*.out" -delete
	@find $(APPLICATIONS_DIR) -name "*.synctex.gz" -delete
	@find $(APPLICATIONS_DIR) -name "*.fdb_latexmk" -delete
	@find $(APPLICATIONS_DIR) -name "*.fls" -delete
	@echo "✅ Cleanup complete"

# Create export directories if not exist
dirs:
	mkdir -p $(APPLICATIONS_DIR)/HarveyNorman-OnlineCustomerService-HomebushWest/exports
	mkdir -p $(APPLICATIONS_DIR)/ChemistWarehouse-PharmacyAssistant-VariousLocations/exports

