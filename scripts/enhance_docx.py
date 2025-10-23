#!/usr/bin/env python3
"""
Enhanced DOCX generation using advanced pandoc options + automatic compression
Generates professional 1-page DOCX matching PDF layout
"""

import subprocess
import os
import sys
from pathlib import Path

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

def compress_docx_post_processing():
    """Run automatic DOCX compression for professional 1-page output"""
    
    docx_path = "resume/main/Resume_Main.docx"
    
    if not os.path.exists(docx_path):
        print(f"❌ DOCX file not found for compression: {docx_path}")
        return False
    
    print("🎨 Running automatic DOCX compression and formatting...")
    
    try:
        # Run the compression script
        compress_cmd = [
            'python3', 
            'scripts/compress_docx.py',
            docx_path
        ]
        
        result = subprocess.run(compress_cmd, 
                              capture_output=True, 
                              text=True, 
                              check=True)
        
        print("✅ DOCX compression completed successfully!")
        print("🏆 Professional 1-page DOCX ready with proper formatting")
        return True
        
    except subprocess.CalledProcessError as e:
        print(f"⚠️  DOCX compression failed: {e}")
        print(f"stderr: {e.stderr}")
        print("📝 DOCX file still available, but without compression")
        return False  # Don't fail the whole process
    
    except FileNotFoundError:
        print("⚠️  compress_docx.py script not found")
        print("💡 Install python-docx: pip install python-docx")
        return False

def main():
    """Main function with integrated compression pipeline"""
    
    print("🚀 Starting enhanced DOCX generation pipeline...")
    
    # Step 1: Generate DOCX with pandoc
    pandoc_success = enhance_docx_formatting()
    
    if not pandoc_success:
        print("❌ DOCX generation failed completely")
        return False
    
    # Step 2: Apply compression and professional formatting
    compression_success = compress_docx_post_processing()
    
    if pandoc_success and compression_success:
        print("🎉 COMPLETE: Professional 1-page DOCX generated!")
        print("📄 Features: Proper fonts, blue headers, icons, 1.2cm margins")
        print("📍 Location: resume/main/Resume_Main.docx")
        return True
    elif pandoc_success:
        print("✅ DOCX generated (basic formatting only)")
        print("💡 For full compression: pip install python-docx")
        return True
    else:
        print("❌ DOCX generation pipeline failed")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)