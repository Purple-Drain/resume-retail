#!/bin/bash
cd ~/Projects/resume-retail

# Fix the workflow to add LaTeX log capture to the matrix build job
python3 << 'PYTHON'
import re

with open('.github/workflows/build.yml', 'r') as f:
    content = f.read()

# Find the "Build ${{ matrix.name }}" step in the matrix build job
# We need to add continue-on-error, id, and the log capture steps
old_build_step = r'''      - name: Build \$\{\{ matrix\.name \}\}
        run: \|
          if \[ "\$\{\{ matrix\.pack \}\}" = "main" \]; then
            make pdf docx
          else
            make pdf-\$\{\{ matrix\.pack \}\} docx-\$\{\{ matrix\.pack \}\}
          fi'''

new_build_step = '''      - name: Build ${{ matrix.name }}
        run: |
          if [ "${{ matrix.pack }}" = "main" ]; then
            make pdf docx
          else
            make pdf-${{ matrix.pack }} docx-${{ matrix.pack }}
          fi
        continue-on-error: true
        id: build_step

      - name: Capture LaTeX logs on failure
        if: failure() && steps.build_step.outcome == 'failure'
        run: |
          echo "📋 Capturing LaTeX log files..."
          find resume -name "*.log" -type f -exec echo "=== {} ===" \\; -exec cat {} \\;

      - name: Upload LaTeX logs
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: latex-logs-${{ matrix.pack }}
          path: resume/**/*.log
          if-no-files-found: warn

      - name: Fail if build failed
        if: steps.build_step.outcome == 'failure'
        run: exit 1'''

# Replace the build step
content = re.sub(old_build_step, new_build_step, content)

# Write the updated file
with open('.github/workflows/build.yml', 'w') as f:
    f.write(content)

print("✅ Workflow file updated - LaTeX log capture added to matrix build job")
PYTHON

# Check the changes
echo ""
echo "=== Checking changes ==="
git diff .github/workflows/build.yml

# Ask for confirmation
echo ""
echo "Does this look correct? (y/n)"
read -r response

if [[ "$response" == "y" ]]; then
    git add .github/workflows/build.yml
    git commit -m "fix(ci): Add LaTeX log capture to matrix build job"
    git push origin main
    echo "✅ Changes pushed!"
else
    echo "❌ Changes not committed. Run 'git restore .github/workflows/build.yml' to discard."
fi
