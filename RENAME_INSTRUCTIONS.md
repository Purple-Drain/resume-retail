# Resume File Renaming - Australian Standards

## What This Does

Renames all resume and cover letter files to follow Australian naming conventions:
- Format: FirstnameLastname_DocumentType_Company_Location.pdf
- Removes version markers like "Final", "Main", "Blue"
- Uses consistent underscore separators
- Makes files immediately identifiable to recruiters

## File Mappings

### Main Resume
- Resume_Main.pdf → AaronDeVries_Resume.pdf
- Resume_Main.docx → AaronDeVries_Resume.docx
- Cover_Letter_Main.pdf → AaronDeVries_CoverLetter.pdf
- Application_Pack_Main.pdf → AaronDeVries_ApplicationPack.pdf

### JB Hi-Fi
- Cover_Letter_JBHiFi_Burwood_Blue_Final.pdf → AaronDeVries_CoverLetter_JBHiFi_Burwood.pdf
- Application_Pack_JBHiFi_Burwood_Blue_Final.pdf → AaronDeVries_ApplicationPack_JBHiFi_Burwood.pdf
- JB_HiFi_Burwood_Form_Answers_Expanded.pdf → AaronDeVries_FormAnswers_JBHiFi_Burwood.pdf
- Checklist_JBHiFi_Burwood.pdf → AaronDeVries_Checklist_JBHiFi_Burwood.pdf

### The Good Guys
- Cover_Letter_TGG.pdf → AaronDeVries_CoverLetter_TheGoodGuys.pdf
- Application_Pack_TGG.pdf → AaronDeVries_ApplicationPack_TheGoodGuys.pdf

### Rebel Sport
- Cover_Letter_Rebel.pdf → AaronDeVries_CoverLetter_RebelSport.pdf
- Application_Pack_Rebel.pdf → AaronDeVries_ApplicationPack_RebelSport.pdf

## How to Run

### Linux/macOS/WSL:
```bash
chmod +x rename_resume_files.sh
./rename_resume_files.sh
```

### Windows PowerShell:
```powershell
.\rename_resume_files.ps1
```

### Git Add (after renaming):
```bash
git add -A
git commit -m "refactor: rename files to Australian resume standards"
git push
```

## Customization

Edit the name at the top of either script:
```bash
FIRSTNAME="Aaron"
LASTNAME="DeVries"
```

Or in PowerShell:
```powershell
$FirstName = "Aaron"
$LastName = "DeVries"
```

## Safety

- Original files are backed up to `.backup_originals/` directory
- You can restore originals if needed
- Add `.backup_originals/` to .gitignore to avoid committing backups

## Next Steps

After running the script, you'll need to:
1. Update Makefile targets to use new filenames
2. Update README.md references
3. Update GitHub Actions workflows if they reference specific filenames
4. Test builds with `make all`
