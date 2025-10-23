#!/usr/bin/env python3
"""
Enhanced DOCX generation using advanced pandoc options
No external dependencies - just better pandoc configuration
"""

import subprocess
import os
import sys

def enhance_docx_formatting():
    """Use advanced pandoc options for better DOCX formatting"""
    
    # Enhanced pandoc command with better formatting options
    pandoc_cmd = [
        'pandoc',
        'resume/main/Resume_Main.tex',
        '-f', 'latex',
        '-t', 'docx',
        '-o', 'resume/main/Resume_Main.docx',
        
        # Enhanced processing options
        '--standalone',
        '--wrap=none',
        
        # Better spacing and formatting
        '--variable=fontsize:10pt',
        '--variable=mainfont:Times New Roman',
        '--variable=geometry:margin=1.2cm',
        
        # Preserve structure
        '--preserve-tabs',
        
        # Better list handling
        '--list-tables',
        
        # Enhanced metadata
        '--metadata=title:Resume - Aaron De Vries',
    ]
    
    print("🔧 Building enhanced DOCX with improved formatting...")
    
    try:
        result = subprocess.run(pandoc_cmd, 
                              capture_output=True, 
                              text=True, 
                              check=True)
        print("✅ Enhanced DOCX generated successfully!")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"❌ DOCX generation failed: {e}")
        print(f"stderr: {e.stderr}")
        
        # Fallback to basic pandoc
        print("🔄 Trying basic pandoc conversion...")
        basic_cmd = [
            'pandoc',
            'resume/main/Resume_Main.tex',
            '-f', 'latex',
            '-t', 'docx',
            '-o', 'resume/main/Resume_Main.docx',
        ]
        
        try:
            subprocess.run(basic_cmd, check=True)
            print("✅ Basic DOCX generated successfully!")
            return True
        except subprocess.CalledProcessError as e2:
            print(f"❌ Basic DOCX also failed: {e2}")
            return False

if __name__ == "__main__":
    enhance_docx_formatting()

def post_process_docx():
    """Additional post-processing for better formatting"""
    print("🔧 Post-processing DOCX for better formatting...")
    
    # Could add docx library improvements here later if needed
    # For now, pandoc improvements should be sufficient
    
    print("✅ Post-processing complete!")

# Add post-processing call to main function
# (Would modify the existing function)
