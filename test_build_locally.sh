#!/bin/bash
set -e

echo "🧪 Testing build locally..."
make clean-all

echo "📄 Building main resume..."
make pdf-main || (echo "❌ Failed"; cat resume/main/Resume_Main.log; exit 1)

for pack in jb tgg rebel; do
    echo "📦 Building $pack..."
    make pdf-$pack || (find resume/$pack -name "*.log" -exec cat {} \;; exit 1)
done

echo "✅ All builds successful!"
