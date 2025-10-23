# Resume Retail

A LaTeX-based resume and cover letter system optimized for retail job applications, with automated PDF/DOCX generation and employer-specific customizations.

## Repository Structure

```
resume-retail/
├── resume/
│   ├── main/                    # Default/master resume files
│   │   ├── Resume_Main.tex      # Main resume (promoted from JB Blue)
│   │   ├── Cover_Letter_Main.tex
│   │   ├── Application_Pack_Main.tex
│   │   └── colors.sty           # Shared color definitions
│   │
│   ├── jb/                      # JB Hi-Fi specific assets
│   │   ├── Cover_Letter_JBHiFi_Burwood_Blue_Final.tex
│   │   ├── JB_HiFi_Burwood_Form_Answers_Expanded.tex
│   │   ├── Checklist_JBHiFi_Burwood.tex
│   │   └── Application_Pack_JBHiFi_Burwood_Blue_Final.tex
│   │
│   ├── tgg/                     # The Good Guys specific assets
│   │   ├── Cover_Letter_TGG.tex
│   │   └── Application_Pack_TGG.tex
│   │
│   └── rebel/                   # Rebel Sport specific assets
│       ├── Cover_Letter_Rebel.tex
│       └── Application_Pack_Rebel.tex
│
├── .github/workflows/           # CI/CD automation
│   ├── build.yml               # Main build workflow
│   ├── latex.yml               # LaTeX build workflow
│   └── release.yml             # Release workflow
│
├── Makefile                    # Build system
└── scripts/                    # Build scripts
```

## Design Philosophy

- **Single Source of Truth**: The master resume lives in `resume/main/Resume_Main.tex`
- **Employer-Specific Assets Only**: Each employer folder (`jb/`, `tgg/`, `rebel/`) contains only variable content:
  - Cover letters
  - Form answers
  - Application-specific checklists
  - Custom application packs that import the main resume
- **DRY Principle**: All employer packs automatically include the latest main resume

## Quick Start

### Build Everything
```bash
make all                    # Build all PDFs and DOCX files
```

### Build Specific Employer Packs
```bash
make pdf-jb                 # JB Hi-Fi PDFs only
make pdf-tgg                # The Good Guys PDFs only
make pdf-rebel              # Rebel Sport PDFs only

make docx-jb                # JB Hi-Fi DOCX only
make docx-tgg               # The Good Guys DOCX only
make docx-rebel             # Rebel Sport DOCX only
```

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
   ```

## Features

- **FontAwesome5 Icons**: Professional contact block with clickable links
- **ATS-Friendly**: Clean structure optimized for Applicant Tracking Systems
- **Responsive Design**: Fits on single page with optimal spacing
- **Multiple Formats**: Generates both PDF and DOCX versions
- **Automated CI/CD**: GitHub Actions automatically builds and publishes artifacts
- **Version Control**: Date and git hash tracking in distribution packages
- **Cross-Platform**: Supports Windows PowerShell, macOS, Linux, and WSL

## Dependencies

- LaTeX distribution with:
  - `texlive-latex-recommended`
  - `texlive-latex-extra`
  - `texlive-fonts-recommended`
  - `texlive-fonts-extra` (for FontAwesome5)
  - `texlive-xetex`
- `latexmk` for PDF generation
- `pandoc` for DOCX conversion

## GitHub Actions

Two workflows handle automated building:

- **build.yml**: Main workflow triggered on push to main
- **latex.yml**: Branch workflow triggered on any push

Both include FontAwesome5 package installation and produce downloadable artifacts.

## Customization

### Contact Information
Update the `ContactBlock` macro in `resume/main/Resume_Main.tex`:

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
5. Submit a pull request

## License

Personal resume repository - not licensed for redistribution.