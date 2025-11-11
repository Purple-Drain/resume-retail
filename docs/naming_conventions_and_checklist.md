# Naming Conventions

This document outlines the naming conventions for folders and files used in the job application system to ensure consistency and easy navigation.

## Folder Naming

- Use the format `CompanyName-Role-Location` for application folders. Example: `HarveyNorman-OnlineCustomerService-HomebushWest`
- Separate different document types within an application folder into `source` and `exports` subfolders:
  - `source`: Contains LaTeX source files, logs, and auxiliary files.
  - `exports`: Contains compiled PDFs, DOCX files, and merged application packs.

## File Naming

- Cover letters should be named `coverletter.tex` in the `source` folder.
- Exported files should match the role and company with a timestamp, e.g., `HarveyNorman-OnlineCustomerService-HomebushWest-20251111.pdf` in `exports`.
- README or `jobdetails.txt` files should capture job description, contact info, and application notes.

## General Notes

- Maintain consistent casing (camelCase or PascalCase) across folders and files.
- Use dashes (`-`) to separate words within folder names for readability.
- Update the job tracker CSV to include folder paths matching this naming scheme.

---

# Application Checklist

A checklist for managing your job applications effectively:

- [ ] Tailor cover letters per role and location.
- [ ] Maintain a centralized master resume in the `resumemain` folder.
- [ ] Maintain separate application folder with source and exports subfolders.
- [ ] Export both PDF and DOCX formats for cover letters and application packs.
- [ ] Include README or `jobdetails.txt` with key application details.
- [ ] Update job tracker CSV with application progress and folder paths.
- [ ] Use version control for all documents and track changes.

---

# LaTeX Cover Letter Template

A base template to create new cover letters.

```latex
% coverlettertemplate.tex
\documentclass[a4paper,11pt]{article}
\usepackage{geometry}
\geometry{a4paper, margin=1in}
\usepackage{parskip}
\usepackage{hyperref}
\begin{document}

\vspace*{2cm}
\noindent
Your Name \\
Your Address \\
Your City, State ZIP \\
\vspace{1cm}
\noindent
Date: \today \\

\noindent
Recipient Name \\
Recipient Title \\
Company Name \\
Company Address \\

\vspace{1cm}
\noindent
Dear Hiring Manager, 

\vspace{0.5cm}
\noindent
I am writing to express my interest in the [Job Title] position at [Company]. With my skills and experience, I believe I would be a strong fit for the role.

\vspace{0.5cm}
\noindent
[Paragraph about your qualifications and why you want the job.]

\vspace{0.5cm}
\noindent
Thank you for considering my application. I look forward to the opportunity to discuss my qualifications further.

\vspace{0.5cm}
\noindent
Sincerely, 

\vspace{1cm}
\noindent
Your Name

\end{document}
```

---

# README.md Example for Applications

```markdown
# Job Application Details

**Role:** Online Customer Service Officer

**Company:** Harvey Norman

**Location:** Homebush West, NSW

**Application URL:** [Harvey Norman Careers](https://harveynormancareers.com.au)

**Date Applied:** 11.11.2025

**Notes:** Supports Harvey Norman Domayne & Joyce Mayne brands. Fast-paced online customer service. Immediate start + Christmas period.
```

---

This documentation and templates folder can be pushed to your GitHub repository to complete your job application system setup.