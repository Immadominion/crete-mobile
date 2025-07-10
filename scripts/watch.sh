#!/bin/bash
# Watch script for continuous code generation during development

set -e

echo "👀 Crete Code Generation Watch"
echo "=============================="
echo "This will watch for file changes and automatically regenerate code."
echo "Press Ctrl+C to stop watching."
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[WATCH]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[GENERATED]${NC} $1"
}

# Ensure dependencies are up to date
print_status "Ensuring dependencies are up to date..."
flutter pub get

# Start watching for changes
print_status "Starting watch mode for code generation..."
print_status "Watching for changes in:"
print_status "  - lib/**/*.dart (for Injectable DI)"
print_status "  - lib/data/models/**/*.dart (for JSON serialization)"
print_status "  - lib/data/datasources/**/*.dart (for Retrofit API clients)"
echo ""

dart run build_runner watch --delete-conflicting-outputs
