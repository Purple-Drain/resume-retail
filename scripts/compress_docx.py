#!/usr/bin/env python3
"""
Post-export DOCX compression script
Compresses 3-page DOCX to 1-page matching PDF layout
Requires: pip install python-docx
"""

import os
import sys
from pathlib import Path

try:
    from docx import Document
    from docx.shared import Pt, Cm
    from docx.enum.text import WD_PARAGRAPH_ALIGNMENT
    from docx.enum.section import WD_SECTION
except ImportError:
    print("❌ python-docx not installed. Install with: pip install python-docx")
    sys.exit(1)

def compress_docx_formatting(docx_path):
    """Compress DOCX formatting to match 1-page PDF layout"""
    
    if not os.path.exists(docx_path):
        print(f"❌ DOCX file not found: {docx_path}")
        return False
        
    print(f"🔧 Compressing DOCX formatting: {docx_path}")
    
    try:
        # Load the document
        doc = Document(docx_path)
        
        # 1. Set page margins to 1.2cm (matching LaTeX geometry)
        for section in doc.sections:
            section.top_margin = Cm(1.2)
            section.bottom_margin = Cm(1.2) 
            section.left_margin = Cm(1.2)
            section.right_margin = Cm(1.2)
            section.gutter = Cm(0)
            
        # 2. Compress all paragraphs
        for paragraph in doc.paragraphs:
            # Set paragraph spacing
            paragraph.paragraph_format.space_before = Pt(3)
            paragraph.paragraph_format.space_after = Pt(3)
            paragraph.paragraph_format.line_spacing = 1.0  # Single spacing
            
            # Handle different paragraph types
            text_content = paragraph.text.strip()
            
            # Contact block (name + contact info) - tighter spacing
            if "Aaron De Vries" in text_content:
                paragraph.paragraph_format.space_after = Pt(6)
                for run in paragraph.runs:
                    if "Aaron De Vries" in run.text:
                        run.font.size = Pt(12)  # Name slightly larger
                    else:
                        run.font.size = Pt(10)
                        
            # Section headers - minimal spacing
            elif any(header in text_content for header in [
                "About Me", "Key Skills", "Retail Experience", 
                "Other Professional Experience", "Education", 
                "Additional Information"
            ]):
                paragraph.paragraph_format.space_before = Pt(6)
                paragraph.paragraph_format.space_after = Pt(2)
                for run in paragraph.runs:
                    run.font.size = Pt(11)
                    run.font.bold = True
                    
            # Job titles and companies - tight spacing
            elif any(company in text_content for company in [
                "Dick Smith Electronics", "Big W", "Avaloq", 
                "Bond International Software", "Retail Team Member",
                "Senior Software Engineer", "Application & Web Developer"
            ]):
                paragraph.paragraph_format.space_before = Pt(4)
                paragraph.paragraph_format.space_after = Pt(1)
                for run in paragraph.runs:
                    run.font.size = Pt(10)
                    
            # Regular content and bullets
            else:
                paragraph.paragraph_format.space_before = Pt(1)
                paragraph.paragraph_format.space_after = Pt(1)
                for run in paragraph.runs:
                    run.font.size = Pt(10)
                    run.font.name = "Times New Roman"
        
        # 3. Handle tables if any exist
        for table in doc.tables:
            for row in table.rows:
                for cell in row.cells:
                    for paragraph in cell.paragraphs:
                        paragraph.paragraph_format.space_before = Pt(0)
                        paragraph.paragraph_format.space_after = Pt(0)
                        
        # 4. Set default font for entire document
        style = doc.styles['Normal']
        font = style.font
        font.name = 'Times New Roman'
        font.size = Pt(10)
        
        # 5. Save the compressed document
        doc.save(docx_path)
        print(f"✅ DOCX compressed successfully: {docx_path}")
        return True
        
    except Exception as e:
        print(f"❌ DOCX compression failed: {e}")
        return False

def fix_icons_in_docx(docx_path):
    """Replace missing FontAwesome icons with Unicode equivalents"""
    
    print(f"🔧 Fixing icons in: {docx_path}")
    
    try:
        doc = Document(docx_path)
        
        icon_replacements = {
            # FontAwesome to Unicode mappings
            "\uf3c5": "📍",  # map-marker-alt
            "\uf095": "📞",  # phone
            "\uf0e0": "✉️",   # envelope  
            "\uf08c": "💼",  # linkedin (or use "in:")
            "fa-map-marker-alt": "📍",
            "fa-phone": "📞", 
            "fa-envelope": "✉️",
            "fa-linkedin": "💼"
        }
        
        for paragraph in doc.paragraphs:
            for run in paragraph.runs:
                for old_icon, new_icon in icon_replacements.items():
                    if old_icon in run.text:
                        run.text = run.text.replace(old_icon, new_icon)
        
        doc.save(docx_path)
        print(f"✅ Icons fixed in: {docx_path}")
        return True
        
    except Exception as e:
        print(f"❌ Icon fixing failed: {e}")
        return False

def main():
    """Main function to compress DOCX files"""
    
    # Default path
    default_docx = "resume/main/Resume_Main.docx"
    
    # Use command line argument if provided
    docx_path = sys.argv[1] if len(sys.argv) > 1 else default_docx
    
    if not os.path.exists(docx_path):
        print(f"❌ DOCX file not found: {docx_path}")
        print(f"Usage: python3 scripts/compress_docx.py [path_to_docx]")
        print(f"Default: python3 scripts/compress_docx.py (uses {default_docx})")
        sys.exit(1)
    
    # Step 1: Compress formatting
    compression_success = compress_docx_formatting(docx_path)
    
    # Step 2: Fix icons
    icon_success = fix_icons_in_docx(docx_path)
    
    if compression_success and icon_success:
        print(f"🎉 DOCX successfully compressed to 1-page format: {docx_path}")
        return True
    else:
        print(f"⚠️  Some issues occurred during compression")
        return False

if __name__ == "__main__":
    main()
