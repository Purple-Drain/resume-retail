#!/bin/bash
# Script to rename resume files to Australian naming standards
# Format: FirstnameLastname_DocumentType_Company_Location.pdf

# Set your name here
FIRSTNAME="Aaron"
LASTNAME="DeVries"
FULLNAME="${FIRSTNAME}${LASTNAME}"

# Create backup directory
mkdir -p .backup_originals
echo "Creating backups in .backup_originals/"

# Function to rename and backup
rename_file() {
    local old_path="$1"
    local new_path="$2"

    if [ -f "$old_path" ]; then
        # Backup original
        cp "$old_path" ".backup_originals/$(basename $old_path)"
        # Rename
        mv "$old_path" "$new_path"
        echo "✓ Renamed: $(basename $old_path) → $(basename $new_path)"
    else
        echo "⚠ File not found: $old_path"
    fi
}

echo "========================================="
echo "Renaming files to Australian standards"
echo "Format: ${FULLNAME}_DocumentType_Details"
echo "========================================="
echo ""

# Main Resume
rename_file "resume/main/Resume_Main.pdf" "resume/main/${FULLNAME}_Resume.pdf"
rename_file "resume/main/Resume_Main.docx" "resume/main/${FULLNAME}_Resume.docx"

# Cover Letters - Main
rename_file "resume/main/Cover_Letter_Main.pdf" "resume/main/${FULLNAME}_CoverLetter.pdf"

# JB Hi-Fi files
rename_file "resume/jb/Cover_Letter_JBHiFi_Burwood_Blue_Final.pdf" "resume/jb/${FULLNAME}_CoverLetter_JBHiFi_Burwood.pdf"
rename_file "resume/jb/Application_Pack_JBHiFi_Burwood_Blue_Final.pdf" "resume/jb/${FULLNAME}_ApplicationPack_JBHiFi_Burwood.pdf"
rename_file "resume/jb/JB_HiFi_Burwood_Form_Answers_Expanded.pdf" "resume/jb/${FULLNAME}_FormAnswers_JBHiFi_Burwood.pdf"
rename_file "resume/jb/Checklist_JBHiFi_Burwood.pdf" "resume/jb/${FULLNAME}_Checklist_JBHiFi_Burwood.pdf"

# The Good Guys files
rename_file "resume/tgg/Cover_Letter_TGG.pdf" "resume/tgg/${FULLNAME}_CoverLetter_TheGoodGuys.pdf"
rename_file "resume/tgg/Application_Pack_TGG.pdf" "resume/tgg/${FULLNAME}_ApplicationPack_TheGoodGuys.pdf"

# Rebel Sport files
rename_file "resume/rebel/Cover_Letter_Rebel.pdf" "resume/rebel/${FULLNAME}_CoverLetter_RebelSport.pdf"
rename_file "resume/rebel/Application_Pack_Rebel.pdf" "resume/rebel/${FULLNAME}_ApplicationPack_RebelSport.pdf"

# Application Pack Main
rename_file "resume/main/Application_Pack_Main.pdf" "resume/main/${FULLNAME}_ApplicationPack.pdf"

echo ""
echo "========================================="
echo "Rename complete!"
echo "Original files backed up to .backup_originals/"
echo "========================================="
