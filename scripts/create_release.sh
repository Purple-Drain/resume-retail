#!/bin/bash
# Quick release script

# Get current version
CURRENT=$(cat VERSION)
echo "Current version: $CURRENT"

# Ask for new version
read -p "New version (e.g., 1.0.2): " NEW_VERSION

# Validate format
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Invalid version format. Use X.Y.Z (e.g., 1.0.2)"
    exit 1
fi

# Update VERSION file
echo "$NEW_VERSION" > VERSION

# Build locally to test
echo "🔨 Building locally first..."
make clean-all
make all

# Check if build succeeded
if [ $? -ne 0 ]; then
    echo "❌ Build failed. Fix errors before releasing."
    exit 1
fi

echo "✅ Local build successful!"

# Commit version bump
git add VERSION
git commit -m "Bump version to $NEW_VERSION"
git push origin main

# Create and push tag
git tag "v$NEW_VERSION"
git push origin "v$NEW_VERSION"

echo "🎉 Release v$NEW_VERSION created!"
echo "📦 GitHub Actions will build and attach assets automatically"
echo "🔗 Check: https://github.com/Purple-Drain/resume-retail/releases"
