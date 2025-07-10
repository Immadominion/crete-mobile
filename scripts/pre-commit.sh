#!/bin/bash
# Pre-commit hook for Crete Flutter project
# This script runs before each commit to ensure code quality

set -e

echo "🔍 Pre-commit checks for Crete"
echo "=============================="

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[CHECK]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Initialize error counter
errors=0

# Check 1: Ensure code generation is up to date
print_status "Checking if code generation is up to date..."
if [ -n "$(git status --porcelain | grep -E '\.(g|config)\.dart$')" ]; then
    print_warning "Generated files have uncommitted changes"
    print_status "Running code generation..."
    dart run build_runner build --delete-conflicting-outputs
    if [ $? -ne 0 ]; then
        print_error "Code generation failed"
        ((errors++))
    else
        print_success "Code generation completed"
    fi
fi

# Check 2: Flutter analysis
print_status "Running Flutter analysis..."
flutter analyze --no-congratulate
if [ $? -eq 0 ]; then
    print_success "Analysis passed"
else
    print_error "Analysis failed - please fix issues before committing"
    ((errors++))
fi

# Check 3: Code formatting
print_status "Checking code formatting..."
dart format --set-exit-if-changed lib/ test/ 
if [ $? -eq 0 ]; then
    print_success "Code formatting is correct"
else
    print_error "Code formatting issues found - run 'dart format lib/ test/' to fix"
    ((errors++))
fi

# Check 4: Check for debugging statements
print_status "Checking for debugging statements..."
if grep -r "debugPrint\|print(" lib/ --include="*.dart" | grep -v "// ignore:"; then
    print_warning "Found debugging print statements - consider removing or ignoring with '// ignore: avoid_print'"
fi

# Check 5: Check for TODO/FIXME comments
print_status "Checking for TODO/FIXME comments..."
todo_count=$(grep -r "TODO\|FIXME" lib/ --include="*.dart" | wc -l)
if [ "$todo_count" -gt 0 ]; then
    print_warning "Found $todo_count TODO/FIXME comments"
fi

# Check 6: Ensure environment files are not committed
print_status "Checking environment files..."
if git diff --cached --name-only | grep -E "\.env\.(dev|staging|prod)$"; then
    print_error "Environment files should not be committed"
    print_error "Please remove .env.dev, .env.staging, .env.prod from commit"
    ((errors++))
fi

# Check 7: Run quick tests (optional, can be disabled for faster commits)
if [ "$SKIP_TESTS" != "true" ]; then
    print_status "Running quick tests..."
    flutter test --coverage
    if [ $? -eq 0 ]; then
        print_success "Tests passed"
    else
        print_error "Tests failed - please fix before committing"
        ((errors++))
    fi
else
    print_warning "Tests skipped (SKIP_TESTS=true)"
fi

# Summary
echo ""
if [ $errors -eq 0 ]; then
    print_success "All pre-commit checks passed! ✨"
    echo ""
    echo "💡 Tip: To skip tests for faster commits, use: SKIP_TESTS=true git commit"
    exit 0
else
    print_error "Pre-commit checks failed with $errors error(s)"
    echo ""
    echo "🛠️  Please fix the issues above before committing"
    echo "💡 To bypass checks (not recommended), use: git commit --no-verify"
    exit 1
fi
