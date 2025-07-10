#!/bin/bash
# Setup script to install Git hooks for Crete project

echo "🔧 Setting up Git hooks for Crete"
echo "================================"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a Git repository"
    echo "Please run this script from the project root directory"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Install pre-commit hook
echo "📦 Installing pre-commit hook..."
cp scripts/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

echo "✅ Pre-commit hook installed successfully!"
echo ""
echo "📋 The pre-commit hook will now run automatically before each commit and check:"
echo "   • Code generation is up to date"
echo "   • Flutter analysis passes"
echo "   • Code formatting is correct"
echo "   • No debugging statements (warning)"
echo "   • No environment files are committed"
echo "   • Tests pass (can be skipped with SKIP_TESTS=true)"
echo ""
echo "💡 Tips:"
echo "   • To skip tests: SKIP_TESTS=true git commit"
echo "   • To bypass all checks: git commit --no-verify"
echo "   • To manually run checks: ./scripts/pre-commit.sh"
echo ""
echo "🎉 Setup complete! Happy coding!"
