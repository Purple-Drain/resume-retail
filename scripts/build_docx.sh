#!/bin/bash
# Build DOCX files by expanding \input statements

build_docx_from_template() {
    local template_file="$1"
    local output_file="$2"
    local temp_file="${output_file%.docx}_temp.tex"
    
    # Start with the template
    cp "$template_file" "$temp_file"
    
    # Replace \input{../main/Resume_Main} with actual content
    if grep -q "\\input{../main/Resume_Main}" "$temp_file"; then
        # Get everything before \input
        sed '/\\input{..\/main\/Resume_Main}/q' "$temp_file" | sed '$d' > "${temp_file}.tmp"
        
        # Add the main resume content (skip documentclass and begin/end document)
        sed -n '/\\begin{document}/,/\\end{document}/p' resume/main/Resume_Main.tex | \
            sed '1d;$d' >> "${temp_file}.tmp"
        
        # Add everything after \input
        sed -n '/\\input{..\/main\/Resume_Main}/,$p' "$temp_file" | sed '1d' >> "${temp_file}.tmp"
        
        mv "${temp_file}.tmp" "$temp_file"
    fi
    
    # Convert to DOCX with proper resource path
    pandoc -s --resource-path=".:./resume:./resume/shared:./resume/main:./resume/jb:./resume/tgg:./resume/rebel" \
           "$temp_file" -o "$output_file"
    
    # Clean up
    rm "$temp_file"
}

# Build main DOCX (no \input issues)
pandoc -s --resource-path=".:./resume:./resume/shared:./resume/main" \
       resume/main/Resume_Main.tex -o resume/main/Resume_Main.docx

pandoc -s --resource-path=".:./resume:./resume/shared:./resume/main" \
       resume/main/Cover_Letter_Main.tex -o resume/main/Cover_Letter_Main.docx

# Build employer DOCX with content expansion
build_docx_from_template "resume/jb/Application_Pack_JBHiFi_Burwood_Blue_Final.tex" "resume/jb/Application_Pack_JBHiFi_Burwood_Blue_Final.docx"
build_docx_from_template "resume/tgg/Application_Pack_TGG.tex" "resume/tgg/Application_Pack_TGG.docx" 
build_docx_from_template "resume/rebel/Application_Pack_Rebel.tex" "resume/rebel/Application_Pack_Rebel.docx"

