#!/usr/bin/env python3
"""
Setup script for DOCX compression dependencies
Installs python-docx for professional DOCX formatting
"""

import subprocess
import sys
import importlib.util

def check_dependency(package_name, import_name=None):
    """Check if a package is installed"""
    if import_name is None:
        import_name = package_name
    
    spec = importlib.util.find_spec(import_name)
    return spec is not None

def install_package(package_name):
    """Install package using pip"""
    print(f"🔧 Installing {package_name}...")
    
    # Try pip3 first, then pip
    for pip_cmd in ['pip3', 'pip']:
        try:
            result = subprocess.run(
                [pip_cmd, 'install', package_name],
                capture_output=True,
                text=True,
                check=True
            )
            print(f"✅ Successfully installed {package_name} with {pip_cmd}")
            return True
            
        except (subprocess.CalledProcessError, FileNotFoundError) as e:
            print(f"⚠️  {pip_cmd} failed: {e}")
            continue
    
    print(f"❌ Failed to install {package_name} with any pip command")
    return False

def main():
    """Main setup function"""
    
    print("🚀 Setting up DOCX compression dependencies...")
    
    # Check if python-docx is already installed
    if check_dependency('python-docx', 'docx'):
        print("✅ python-docx is already installed")
        print("🎉 DOCX compression is ready to use!")
        return True
    
    print("📦 python-docx not found, installing...")
    
    # Install python-docx
    if install_package('python-docx'):
        # Verify installation
        if check_dependency('python-docx', 'docx'):
            print("🎉 Setup complete! DOCX compression is ready.")
            print("🔧 You can now run: make docx")
            print("📄 Or directly: python3 scripts/enhance_docx.py")
            return True
        else:
            print("❌ Installation verification failed")
            return False
    else:
        print("❌ Failed to install python-docx")
        print("💡 Try manually: pip install python-docx")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)