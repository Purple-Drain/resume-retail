#!/usr/bin/env python3
"""
Post-export DOCX compression script with complete formatting
Compresses 3-page DOCX to 1-page matching PDF layout with professional styling
Requires: pip install python-docx
"""

import os
import sys
import re
from pathlib import Path

try:
    from docx import Document
    from docx.shared import Pt, Cm, RGBColor
    from docx.enum.text import WD_PARAGRAPH_ALIGNMENT
    from docx.enum.section import WD_SECTION
    from docx.oxml.ns import qn
    from docx.oxml import OxmlElement
except ImportError:
    print("❌ python-docx not installed. Install with: pip install python-docx")
    sys.exit(1)

def add_horizontal_line(paragraph, color_rgb=(70, 130, 180)):
    """Add a horizontal line after paragraph (matching LaTeX titlerule)"""
    p = paragraph._element
    pPr = p.get_or_add_pPr()
    
    # Add bottom border
    borders = OxmlElement('w:pBdr')
    bottom_border = OxmlElement('w:bottom')
    bottom_border.set(qn('w:val'), 'single')
    bottom_border.set(qn('w:sz'), '6')  # Line thickness
    bottom_border.set(qn('w:space'), '1')
    bottom_border.set(qn('w:color'), f'{color_rgb[0]:02x}{color_rgb[1]:02x}{color_rgb[2]:02x}')
    borders.append(bottom_border)
    pPr.append(borders)

def set_blue_color(run, color_rgb=(70, 130, 180)):
    """Set text color to MidBlue matching LaTeX"""
    run.font.color.rgb = RGBColor(color_rgb[0], color_rgb[1], color_rgb[2])

def compress_docx_formatting(docx_path):
    """Compress DOCX formatting to match 1-page PDF layout with professional styling"""
    
    if not os.path.exists(docx_path):
        print(f"❌ DOCX file not found: {docx_path}")
        return False
        
    print(f"🔧 Compressing DOCX with professional formatting: {docx_path}")
    
    try:
        # Load the document
        doc = Document(docx_path)
        
        # 1. Set page margins to 1.2cm (matching LaTeX geometry)
        for section in doc.sections:
            section.top_margin = Cm(1.2)
            section.bottom_margin = Cm(1.5)  # Slightly more for page numbers
            section.left_margin = Cm(1.2)
            section.right_margin = Cm(1.2)
            section.gutter = Cm(0)
            
        # 2. Process all paragraphs with smart formatting
        for i, paragraph in enumerate(doc.paragraphs):
            text_content = paragraph.text.strip()
            
            # Skip empty paragraphs but keep minimal spacing
            if not text_content:
                paragraph.paragraph_format.space_before = Pt(0)
                paragraph.paragraph_format.space_after = Pt(0)
                continue
            
            # Set default spacing
            paragraph.paragraph_format.line_spacing = 1.0  # Single spacing
            
            # 🎯 HEADER: Name + Contact Block
            if "Aaron De Vries" in text_content:
                paragraph.paragraph_format.space_before = Pt(0)
                paragraph.paragraph_format.space_after = Pt(8)
                paragraph.paragraph_format.alignment = WD_PARAGRAPH_ALIGNMENT.LEFT
                
                # Style the name and contact info
                for run in paragraph.runs:
                    if "Aaron De Vries" in run.text:
                        run.font.name = "Times New Roman"
                        run.font.size = Pt(14)  # Large name
                        run.font.bold = True
                        run.font.color.rgb = RGBColor(0, 0, 0)  # Black
                    else:
                        run.font.name = "Times New Roman"
                        run.font.size = Pt(9)   # Smaller contact info
                        set_blue_color(run)     # Blue contact details
            
            # 🎯 SECTION HEADERS with blue underlines
            elif any(header in text_content for header in [
                "About Me", "Key Skills", "Retail Experience", 
                "Other Professional Experience", "Education", 
                "Additional Information"
            ]):
                paragraph.paragraph_format.space_before = Pt(8)
                paragraph.paragraph_format.space_after = Pt(4)
                
                for run in paragraph.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(11)
                    run.font.bold = True
                    run.font.color.rgb = RGBColor(0, 0, 0)  # Black headers
                    
                # Add blue underline
                add_horizontal_line(paragraph)
            
            # 🎯 JOB TITLES (bold entries)
            elif any(title in text_content for title in [
                "Retail Team Member", "Senior Software Engineer", 
                "Application & Web Developer", "Bachelor of Computer Science"
            ]):
                paragraph.paragraph_format.space_before = Pt(6)
                paragraph.paragraph_format.space_after = Pt(2)
                
                for run in paragraph.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(10)
                    # Keep existing bold formatting for job titles
                    
            # 🎯 COMPANY NAMES & DATES (with proper spacing)
            elif any(company in text_content for company in [
                "Dick Smith Electronics", "Big W", "Avaloq", 
                "Bond International Software", "University of Technology Sydney"
            ]) or re.search(r'\d{4}--\d{4}|\d{4}--\w+\s+\d{4}', text_content):
                paragraph.paragraph_format.space_before = Pt(1)
                paragraph.paragraph_format.space_after = Pt(3)
                
                for run in paragraph.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(10)
            
            # 🎯 BULLET POINTS & REGULAR CONTENT
            else:
                paragraph.paragraph_format.space_before = Pt(1)
                paragraph.paragraph_format.space_after = Pt(2)
                
                for run in paragraph.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(10)
                    run.font.color.rgb = RGBColor(0, 0, 0)  # Ensure black text
        
        # 3. Handle tables with tight spacing
        for table in doc.tables:
            for row in table.rows:
                for cell in row.cells:
                    for paragraph in cell.paragraphs:
                        paragraph.paragraph_format.space_before = Pt(0)
                        paragraph.paragraph_format.space_after = Pt(1)
                        
        # 4. Set document-wide defaults
        style = doc.styles['Normal']
        font = style.font
        font.name = 'Times New Roman'
        font.size = Pt(10)
        
        # Paragraph style defaults
        paragraph_format = style.paragraph_format
        paragraph_format.space_before = Pt(1)
        paragraph_format.space_after = Pt(2)
        paragraph_format.line_spacing = 1.0
        
        # 5. Save the professionally formatted document
        doc.save(docx_path)
        print(f"✅ Professional DOCX formatting applied: {docx_path}")
        return True
        
    except Exception as e:
        print(f"❌ DOCX formatting failed: {e}")
        return False

def fix_icons_and_formatting(docx_path):
    """Replace missing FontAwesome icons and enhance contact block formatting"""
    
    print(f"🎨 Enhancing icons and contact formatting: {docx_path}")
    
    try:
        doc = Document(docx_path)
        
        # Better icon replacements with professional Unicode symbols
        icon_replacements = {
            # FontAwesome codes to clean Unicode
            "\\uf3c5": "📍 ",   # map-marker-alt
            "\\uf095": "📞 ",   # phone  
            "\\uf0e0": "✉️ ",   # envelope
            "\\uf08c": "💼 ",   # linkedin
            # Alternative patterns
            "fa-map-marker-alt": "📍 ",
            "fa-phone": "📞 ",
            "fa-envelope": "✉️ ",
            "fa-linkedin": "💼 ",
            # LaTeX icon commands
            "\\faIcon{map-marker-alt}": "📍",
            "\\faIcon{phone}": "📞",
            "\\faIcon{envelope}": "✉️",
            "\\faIcon[brands]{linkedin}": "💼",
        }
        
        for paragraph in doc.paragraphs:
            text_content = paragraph.text
            
            # Enhanced contact block formatting
            if "Aaron De Vries" in text_content or any(contact in text_content.lower() for contact in ["homebush", "0400", "@", "linkedin"]):
                
                for run in paragraph.runs:
                    original_text = run.text
                    modified_text = original_text
                    
                    # Apply icon replacements
                    for old_icon, new_icon in icon_replacements.items():
                        modified_text = modified_text.replace(old_icon, new_icon)
                    
                    # Clean up extra spaces and formatting
                    modified_text = re.sub(r'\\,\\s*', ' ', modified_text)  # LaTeX spacing
                    modified_text = re.sub(r'\\quad\\textbar\\quad', ' | ', modified_text)  # LaTeX separators
                    modified_text = re.sub(r'\\textbar', '|', modified_text)
                    modified_text = re.sub(r'\\s+', ' ', modified_text)  # Multiple spaces
                    
                    if modified_text != original_text:
                        run.text = modified_text
                        
                        # Apply blue color to contact info (not name)
                        if "Aaron De Vries" not in run.text:
                            set_blue_color(run)
        
        # Clean up any remaining LaTeX commands in the entire document
        for paragraph in doc.paragraphs:
            for run in paragraph.runs:
                if run.text:
                    # Remove common LaTeX artifacts
                    run.text = re.sub(r'\\[a-zA-Z]+\{[^}]*\}', '', run.text)  # \command{arg}
                    run.text = re.sub(r'\\[a-zA-Z]+', '', run.text)  # \command
                    run.text = re.sub(r'\{|\}', '', run.text)  # Stray braces
                    run.text = run.text.replace('\\', '')  # Stray backslashes
        
        doc.save(docx_path)
        print(f"✅ Icons and contact formatting enhanced: {docx_path}")
        return True
        
    except Exception as e:
        print(f"❌ Icon and formatting enhancement failed: {e}")
        return False

def optimize_lists_and_spacing(docx_path):
    """Optimize bullet lists and overall document spacing for 1-page compression"""
    
    print(f"🎯 Optimizing lists and spacing for 1-page layout: {docx_path}")
    
    try:
        doc = Document(docx_path)
        
        # Find and optimize bullet lists
        for paragraph in doc.paragraphs:
            text = paragraph.text.strip()
            
            # Handle bullet points (usually start with bullet or are indented)
            if (text.startswith('•') or text.startswith('-') or 
                paragraph.style.name.startswith('List') or
                any(keyword in text for keyword in [
                    "Customer service", "POS system", "Merchandising", 
                    "Team collaboration", "Delivered exceptional",
                    "Processed stock", "Specialized in", "Collaborated effectively"
                ])):
                
                # Tighter spacing for list items
                paragraph.paragraph_format.space_before = Pt(1)
                paragraph.paragraph_format.space_after = Pt(1)
                paragraph.paragraph_format.left_indent = Cm(0.5)  # Small indent
                paragraph.paragraph_format.line_spacing = 1.0
                
                # Ensure consistent font
                for run in paragraph.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(10)
        
        # Final aggressive compression pass
        for paragraph in doc.paragraphs:
            if paragraph.text.strip():  # Non-empty paragraphs
                # Minimal spacing between content
                if paragraph.paragraph_format.space_before is None or paragraph.paragraph_format.space_before > Pt(8):
                    if any(header in paragraph.text for header in ["About Me", "Key Skills"]):
                        paragraph.paragraph_format.space_before = Pt(6)
                    else:
                        paragraph.paragraph_format.space_before = Pt(2)
                
                if paragraph.paragraph_format.space_after is None or paragraph.paragraph_format.space_after > Pt(6):
                    paragraph.paragraph_format.space_after = Pt(2)
        
        doc.save(docx_path)
        print(f"✅ Lists and spacing optimized for 1-page layout: {docx_path}")
        return True
        
    except Exception as e:
        print(f"❌ List and spacing optimization failed: {e}")
        return False

def main():
    """Main function to apply complete DOCX compression and formatting"""
    
    # Default path
    default_docx = "resume/main/Resume_Main.docx"
    
    # Use command line argument if provided
    docx_path = sys.argv[1] if len(sys.argv) > 1 else default_docx
    
    if not os.path.exists(docx_path):
        print(f"❌ DOCX file not found: {docx_path}")
        print(f"Usage: python3 scripts/compress_docx.py [path_to_docx]")
        print(f"Default: python3 scripts/compress_docx.py (uses {default_docx})")
        sys.exit(1)
    
    print(f"🚀 Starting complete DOCX enhancement for: {docx_path}")
    
    # Step 1: Apply professional formatting and compression
    formatting_success = compress_docx_formatting(docx_path)
    
    # Step 2: Fix icons and enhance contact block
    icons_success = fix_icons_and_formatting(docx_path)
    
    # Step 3: Optimize lists and final spacing
    optimization_success = optimize_lists_and_spacing(docx_path)
    
    if formatting_success and icons_success and optimization_success:
        print(f"🎉 DOCX successfully enhanced with professional formatting!")
        print(f"📄 1-page layout with proper fonts, icons, and blue section headers")
        print(f"📁 File: {docx_path}")
        return True
    else:
        print(f"⚠️  Some issues occurred during enhancement")
        return False

if __name__ == "__main__":
    main()