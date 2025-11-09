# Resume Retail

A LaTeX-based resume and cover letter system optimized for retail job applications, with automated PDF/DOCX generation, professional DOCX compression, and employer-specific customizations.

## Repository Structure

```
resume-retail/
├── resume/
│   ├── main/                    # Default/master resume files
│   │   ├── AaronDeVries_Resume.tex      # Main resume (promoted from JB Blue)
│   │   ├── AaronDeVries_CoverLetter.tex
│   │   ├── AaronDeVries_ApplicationPack.tex
│   │   └── colors.sty           # Shared color definitions
│   │
│   ├── jb/                      # JB Hi-Fi specific assets
│   │   ├── AaronDeVries_CoverLetter_JBHiFi_Burwood.tex
│   │   ├── AaronDeVries_FormAnswers_JBHiFi_Burwood.tex
│   │   ├── AaronDeVries_AaronDeVries_Checklist_JBHiFi_Burwood.tex
│   │   └── AaronDeVries_ApplicationPack_JBHiFi_Burwood.tex
│   │
│   ├── tgg/                     # The Good Guys specific assets
│   │   ├── AaronDeVries_CoverLetter_TheGoodGuys.tex
│   │   └── AaronDeVries_ApplicationPack_TheGoodGuys.tex
│   │
│   └── rebel/                   # Rebel Sport specific assets
│       ├── AaronDeVries_CoverLetter_RebelSport.tex
│       └── AaronDeVries_ApplicationPack_RebelSport.tex
│
├── .github/workflows/           # CI/CD automation
│   ├── build.yml               # Main build workflow
│   ├── latex.yml               # LaTeX build workflow
│   └── release.yml             # Release workflow
│
├── Makefile                    # Build system
└── scripts/                    # Build scripts
    ├── enhance_docx.py         # DOCX generation with compression
    ├── compress_docx.py        # Professional DOCX formatting
    └── setup_docx.py           # Dependency setup
```

## Design Philosophy

- **Single Source of Truth**: The master resume lives in `resume/main/AaronDeVries_Resume.tex`
- **Employer-Specific Assets Only**: Each employer folder (`jb/`, `tgg/`, `rebel/`) contains only variable content:
  - Cover letters
  - Form answers
  - Application-specific checklists
  - Custom application packs that import the main resume
- **DRY Principle**: All employer packs automatically include the latest main resume
- **Professional DOCX Output**: 1-page compressed DOCX matching PDF layout with proper fonts and formatting

## Quick Start

### Initial Setup (One-time)
```bash
# Install DOCX compression dependencies
python3 scripts/setup_docx.py

# Or manually:
pip install python-docx
```

### Build Everything
```bash
make all                    # Build all PDFs and professional DOCX files
```

### Build Specific Employer Packs
```bash
make pdf-jb                 # JB Hi-Fi PDFs only
make pdf-tgg                # The Good Guys PDFs only
make pdf-rebel              # Rebel Sport PDFs only

make docx-jb                # JB Hi-Fi DOCX only (with compression)
make docx-tgg               # The Good Guys DOCX only (with compression)
make docx-rebel             # Rebel Sport DOCX only (with compression)
```

### Professional DOCX Generation

The system now includes **automatic DOCX compression** that converts the typical 3-page pandoc output into a **professional 1-page DOCX** matching your PDF:

```bash
# Automatic (recommended)
make docx                   # Full pipeline: pandoc + compression

# Manual compression only (if DOCX already exists)
python3 scripts/compress_docx.py resume/main/AaronDeVries_Resume.docx

# Enhanced generation pipeline
python3 scripts/enhance_docx.py  # Pandoc + automatic compression
```

**DOCX Features:**
- ✅ **1-page layout** matching PDF exactly
- ✅ **Times New Roman fonts** with proper sizing
- ✅ **Blue section headers** with professional underlines
- ✅ **Unicode icons** (📍📞✉️💼) replacing FontAwesome
- ✅ **1.2cm margins** matching LaTeX geometry
- ✅ **Smart paragraph spacing** (single + 3pt)
- ✅ **Professional contact block** with colored formatting

### Create Distribution Packages
```bash
make pack                   # Create source and full repo tarballs
make pack-jb                # Create JB Hi-Fi application pack
make pack-tgg               # Create The Good Guys application pack
make pack-rebel             # Create Rebel Sport application pack
```

### Windows Support
```powershell
.\scripts\quick_build.ps1         # PDFs + DOCX (fallbacks)
.\scripts\quick_build.ps1 -NoDocx # PDFs only
.\scripts\build.ps1 -Docx         # PDFs + DOCX
```

## DOCX Compression System

### How It Works

1. **Pandoc Conversion**: LaTeX → Basic DOCX (usually 3 pages)
2. **Smart Compression**: `compress_docx.py` applies professional formatting:
   - Adjusts margins to 1.2cm
   - Compresses paragraph spacing
   - Sets proper fonts (Times New Roman)
   - Adds blue section headers with underlines
   - Replaces FontAwesome icons with Unicode
   - Optimizes bullet lists and content spacing
3. **1-Page Output**: Professional DOCX matching PDF layout

### Manual Compression

If you need to compress an existing DOCX file:

```bash
# Compress specific file
python3 scripts/compress_docx.py path/to/resume.docx

# Compress default main resume
python3 scripts/compress_docx.py  # Uses resume/main/AaronDeVries_Resume.docx
```

### Troubleshooting DOCX

**Missing python-docx dependency:**
```bash
python3 scripts/setup_docx.py  # Automatic setup
# Or manually: pip install python-docx
```

**DOCX still 3 pages:**
- Check that `python-docx` is installed
- Run compression manually: `python3 scripts/compress_docx.py resume/main/AaronDeVries_Resume.docx`
- Verify no manual page breaks in content

**Icons not showing:**
- The system automatically converts FontAwesome to Unicode (📍📞✉️💼)
- Compatible with all systems without special fonts

## Adding a New Employer

1. **Create employer folder**:
   ```bash
   mkdir resume/[employer-name]
   ```

2. **Add application pack** that imports the main resume:
   ```latex
   % resume/[employer-name]/Application_Pack_[Employer].tex
   \input{../main/Resume_Main}
   
   % Add employer-specific content below
   ```

3. **Add cover letter** using the template pattern:
   ```latex
   % resume/[employer-name]/Cover_Letter_[Employer].tex
   % Use existing cover letters as templates
   ```

4. **Update Makefile** with new targets:
   ```makefile
   EMPLOYER := resume/[employer-name]
   
   pdf-[employer]:
       $(LATEXMK) $(LATEXMK_FLAGS) $(EMPLOYER)/Application_Pack_[Employer].tex
       
   docx-[employer]:
       @python3 scripts/enhance_docx.py
   ```

## Features

- **FontAwesome5 Icons**: Professional contact block with clickable links (PDF)
- **Unicode Icons**: Cross-platform compatible icons for DOCX (📍📞✉️💼)
- **ATS-Friendly**: Clean structure optimized for Applicant Tracking Systems
- **Responsive Design**: Fits on single page with optimal spacing
- **Multiple Formats**: Generates both PDF and professional 1-page DOCX
- **Automated Compression**: 3-page DOCX → 1-page professional format
- **Professional Styling**: Blue headers, proper fonts, smart spacing
- **Automated CI/CD**: GitHub Actions automatically builds and publishes artifacts
- **Version Control**: Date and git hash tracking in distribution packages
- **Cross-Platform**: Supports Windows PowerShell, macOS, Linux, and WSL

## Dependencies

### LaTeX (for PDF generation)
- LaTeX distribution with:
  - `texlive-latex-recommended`
  - `texlive-latex-extra`
  - `texlive-fonts-recommended`
  - `texlive-fonts-extra` (for FontAwesome5)
  - `texlive-xetex`
- `latexmk` for PDF generation

### DOCX (for professional Word documents)
- `pandoc` for LaTeX → DOCX conversion
- `python-docx` for professional formatting and compression
  - Install: `pip install python-docx`
  - Or use: `python3 scripts/setup_docx.py`

## GitHub Actions

Two workflows handle automated building:

- **build.yml**: Main workflow triggered on push to main
- **latex.yml**: Branch workflow triggered on any push

Both include FontAwesome5 package installation and produce downloadable artifacts with both PDF and compressed DOCX files.

## Customization

### Contact Information
Update the `ContactBlock` macro in `resume/main/AaronDeVries_Resume.tex`:

```latex
\renewcommand{\ContactBlock}{%
  {\Large \textbf{Your Name}}\par
  {\color{MidBlue}\small
  \faIcon{map-marker-alt}\, Your Location \quad\textbar\quad
  \faIcon{phone}\, \href{tel:+1234567890}{Your Phone} \quad\textbar\quad
  % ... etc
  }\par
}
```

### Colors
Modify `resume/main/colors.sty` to change the color scheme:

```latex
\definecolor{MidBlue}{HTML}{2E5E8A}  # Primary accent color
% Add custom colors here
```

### DOCX Formatting
Customize `scripts/compress_docx.py` for different formatting:

```python
# Change margins
section.top_margin = Cm(1.0)  # Tighter margins

# Adjust colors
set_blue_color(run, color_rgb=(0, 100, 200))  # Different blue

# Modify spacing
paragraph.paragraph_format.space_after = Pt(1)  # Tighter spacing
```

## Release Process

1. Edit VERSION file (current: 1.0.1)
2. Commit and push changes
3. Run `make release` 
4. Push release tag: `git push origin v1.0.1`
5. GitHub Actions will create the release automatically

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Test builds locally with `make all`
5. Test DOCX compression with `python3 scripts/setup_docx.py && make docx`
6. Submit a pull request

## License

Personal resume repository - not licensed for redistribution.