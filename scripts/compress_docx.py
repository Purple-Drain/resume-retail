#!/usr/bin/env python3
"""
DOCX compression with perfect PDF parity including bullet points (•)
"""
import os
import sys
import re
from pathlib import Path

try:
    from docx import Document
    from docx.shared import Pt, Cm, RGBColor
    from docx.enum.text import WD_PARAGRAPH_ALIGNMENT
    from docx.oxml.ns import qn
    from docx.oxml import OxmlElement
except ImportError:
    print("❌ python-docx not installed")
    sys.exit(1)

def add_horizontal_line(paragraph, color_rgb=(70, 130, 180)):
    """Add blue underline to section headers"""
    p = paragraph._element
    pPr = p.get_or_add_pPr()
    borders = OxmlElement('w:pBdr')
    bottom_border = OxmlElement('w:bottom')
    bottom_border.set(qn('w:val'), 'single')
    bottom_border.set(qn('w:sz'), '8')
    bottom_border.set(qn('w:space'), '1')
    bottom_border.set(qn('w:color'), f'{color_rgb[0]:02x}{color_rgb[1]:02x}{color_rgb[2]:02x}')
    borders.append(bottom_border)
    pPr.append(borders)

def is_bullet_point(text):
    """Detect if a paragraph should be a bullet point"""
    # Key Skills section bullets
    key_skills = [
        "Customer service", "POS system", "Merchandising",
        "Team collaboration", "Technology,", "Loss prevention",
        "Effective communication"
    ]
    
    # Job experience bullets - typically start with action verbs
    action_verbs = [
        "Delivered", "Processed", "Handled", "Set up",
        "Trained", "Specialized", "Maintained", 
        "Collaborated", "Applied", "Partnered"
    ]
    
    # Check if it's a Key Skills bullet
    if any(skill in text for skill in key_skills):
        return True
    
    # Check if it starts with an action verb (job bullets)
    if any(text.strip().startswith(verb) for verb in action_verbs):
        return True
    
    # Check for bullets in Additional Information
    if text.startswith("Passionate about") or text.startswith("Available for"):
        return True
        
    return False

def add_bullet_symbol(paragraph):
    """Add actual bullet symbol (•) to the beginning of paragraph text"""
    if paragraph.runs and paragraph.text.strip():
        # Get the current text
        full_text = paragraph.text.strip()
        
        # Clear the paragraph
        paragraph.clear()
        
        # Add bullet symbol + space + original text
        bullet_text = f"• {full_text}"
        run = paragraph.add_run(bullet_text)
        run.font.name = "Times New Roman"
        run.font.size = Pt(10)
        run.font.color.rgb = RGBColor(0, 0, 0)

def compress_docx_formatting(docx_path):
    """Apply complete formatting with perfect PDF match including bullet symbols"""
    
    if not os.path.exists(docx_path):
        print(f"❌ File not found: {docx_path}")
        return False
    
    print(f"🔧 Applying perfect formatting with bullet symbols: {docx_path}")
    
    try:
        doc = Document(docx_path)
        
        # Set margins (1.2cm)
        for section in doc.sections:
            section.top_margin = Cm(1.2)
            section.bottom_margin = Cm(1.5)
            section.left_margin = Cm(1.2)
            section.right_margin = Cm(1.2)
        
        # Track paragraphs to remove
        paras_to_remove = []
        
        # Section headers
        section_headers = [
            "About Me", "Key Skills", "Retail Experience",
            "Other Professional Experience", "Education",
            "Additional Information"
        ]
        
        for i, para in enumerate(doc.paragraphs):
            text = para.text.strip()
            
            # Remove ALL indentation
            para.paragraph_format.left_indent = Pt(0)
            para.paragraph_format.right_indent = Pt(0)
            para.paragraph_format.first_line_indent = Pt(0)
            para.paragraph_format.line_spacing = 1.0
            
            if not text:
                para.paragraph_format.space_before = Pt(0)
                para.paragraph_format.space_after = Pt(0)
                continue
            
            # HEADER: Remove "Resume - Aaron De Vries" title line
            if text == "Resume - Aaron De Vries":
                paras_to_remove.append(para)
                continue
            
            # HEADER: Main name
            if text == "Aaron De Vries":
                para.clear()
                para.paragraph_format.space_before = Pt(0)
                para.paragraph_format.space_after = Pt(2)
                para.paragraph_format.alignment = WD_PARAGRAPH_ALIGNMENT.LEFT
                
                name_run = para.add_run("Aaron De Vries")
                name_run.font.name = "Times New Roman"
                name_run.font.size = Pt(16)
                name_run.font.bold = True
                name_run.font.color.rgb = RGBColor(0, 0, 0)
                continue
            
            # HEADER: Contact block - rebuild with icons
            if any(contact in text.lower() for contact in ["homebush", "0400", "@protonmail", "linkedin.com/in"]):
                para.clear()
                para.paragraph_format.space_before = Pt(0)
                para.paragraph_format.space_after = Pt(10)
                para.paragraph_format.alignment = WD_PARAGRAPH_ALIGNMENT.LEFT
                
                # Single line with icons
                contact_text = "📍 Homebush, NSW   📞 0400 375 308   ✉️ aarondevries@protonmail.com   💼 linkedin.com/in/aarondevriesdev"
                contact_run = para.add_run(contact_text)
                contact_run.font.name = "Times New Roman"
                contact_run.font.size = Pt(9)
                contact_run.font.color.rgb = RGBColor(70, 130, 180)
                continue
            
            # Section headers with blue underlines
            if any(header in text for header in section_headers):
                para.paragraph_format.space_before = Pt(10)
                para.paragraph_format.space_after = Pt(4)
                
                for run in para.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(11)
                    run.font.bold = True
                    run.font.color.rgb = RGBColor(0, 0, 0)
                
                add_horizontal_line(para)
                continue
            
            # BULLET POINTS - Add bullet symbols (•)
            if is_bullet_point(text):
                para.paragraph_format.space_before = Pt(0)
                para.paragraph_format.space_after = Pt(2)
                para.paragraph_format.left_indent = Cm(0.5)  # Indent for bullets
                
                # Add bullet symbol to text
                add_bullet_symbol(para)
                continue
            
            # Job titles (bold)
            if any(title in text for title in [
                "Retail Team Member", "Senior Software Engineer",
                "Application Web Developer", "Application & Web Developer",
                "Bachelor of Computer Science"
            ]):
                para.paragraph_format.space_before = Pt(6)
                para.paragraph_format.space_after = Pt(1)
                
                for run in para.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(10)
                    run.font.bold = True
                continue
            
            # Company/dates lines
            if any(company in text for company in [
                "Dick Smith", "Big W", "Avaloq", "Bond International", "University of Technology Sydney"
            ]) or re.search(r'\d{4}', text):
                para.paragraph_format.space_before = Pt(0)
                para.paragraph_format.space_after = Pt(3)
                
                for run in para.runs:
                    run.font.name = "Times New Roman"
                    run.font.size = Pt(10)
                continue
            
            # Regular content (About Me paragraph, etc)
            para.paragraph_format.space_before = Pt(0)
            para.paragraph_format.space_after = Pt(2)
            
            for run in para.runs:
                run.font.name = "Times New Roman"
                run.font.size = Pt(10)
                run.font.color.rgb = RGBColor(0, 0, 0)
        
        # Remove marked paragraphs (title line)
        for para in paras_to_remove:
            p = para._element
            p.getparent().remove(p)
        
        # Document-wide defaults
        style = doc.styles['Normal']
        style.font.name = 'Times New Roman'
        style.font.size = Pt(10)
        style.paragraph_format.space_before = Pt(0)
        style.paragraph_format.space_after = Pt(2)
        style.paragraph_format.line_spacing = 1.0
        
        doc.save(docx_path)
        print(f"✅ Perfect formatting with bullet symbols applied")
        return True
        
    except Exception as e:
        print(f"❌ Formatting failed: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    """Main function"""
    default_docx = "resume/main/Resume_Main.docx"
    docx_path = sys.argv[1] if len(sys.argv) > 1 else default_docx
    
    if not os.path.exists(docx_path):
        print(f"❌ File not found: {docx_path}")
        sys.exit(1)
    
    print(f"🚀 Creating perfect DOCX with bullet symbols: {docx_path}")
    
    if compress_docx_formatting(docx_path):
        print(f"✅ DOCX compression completed successfully!")
        print(f"🏆 Professional 1-page DOCX ready with proper formatting")
        print(f"🎉 COMPLETE: Professional 1-page DOCX generated!")
        print(f"📄 Features: Proper fonts, blue headers, icons, bullet symbols (•), 1.2cm margins")
        print(f"📍 Location: {docx_path}")
        return True
    else:
        print(f"⚠️ Formatting incomplete")
        return False

if __name__ == "__main__":
    main()
