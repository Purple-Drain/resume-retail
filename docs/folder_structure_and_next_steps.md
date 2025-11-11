# Folder structure for job applications

resume-retail/
├── applications/
│   ├── HarveyNorman-OnlineCustomerService-HomebushWest/
│   │   ├── source/
│   │   │   ├── coverletter.tex
│   │   │   └── jobdetails.txt
│   │   ├── exports/
│   │   │   ├── HarveyNorman-OnlineCustomerService-HomebushWest-20251111.pdf
│   │   │   └── HarveyNorman-OnlineCustomerService-HomebushWest-20251111.docx
│   │   └── README.md
│   └── ChemistWarehouse-PharmacyAssistant-VariousLocations/
│       ├── source/
│       │   ├── coverletter.tex
│       │   └── jobdetails.txt
│       ├── exports/
│       │   ├── ChemistWarehouse-PharmacyAssistant-VariousLocations-20251111.pdf
│       │   └── ChemistWarehouse-PharmacyAssistant-VariousLocations-20251111.docx
│       └── README.md
├── docs/
│   └── naming_conventions_and_checklist.md
├── templates/
│   └── coverlettertemplate.tex
├── job_application_tracker.csv
├── resume/
│   └── main/
│       ├── AaronDeVries_Resume.tex
│       └── colors.sty
└── Makefile


# Key notes:
- Each application folder has separate source and exports folders
- Source contains editable LaTeX and job details text files
- Exports contain final PDF and DOCX files
- README files within each folder capture job-specific details and notes
- The main resume remains centralized in resume/main
- Docs folder contains naming conventions and checklist
- Templates folder holds the base LaTeX cover letter template
- Makefile supports building all documents

---

# To-do next:

- Implement automation scripts using Makefile or CI/CD for pdf/docx generation
- Populate application source folders with actual LaTeX cover letters
- Track application progress by updating job_application_tracker.csv with folder paths
- Consider adding scripts to automate moving exports to cloud storage or sending applications

---

This folder structure and documentation layout will help manage applications efficiently and keep consistent version control with git.
