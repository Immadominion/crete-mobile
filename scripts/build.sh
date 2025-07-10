#!/bin/bash
# Build script for code generation in Crete Flutter project

set -e  # Exit on any error

echo "🔧 Crete Build Script"
echo "===================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter version:"
flutter --version

# Step 1: Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
print_success "Clean completed"

# Step 2: Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    print_success "Dependencies installed successfully"
else
    print_error "Failed to get dependencies"
    exit 1
fi

# Step 3: Run code generation
print_status "Running code generation..."
dart run build_runner build --delete-conflicting-outputs
if [ $? -eq 0 ]; then
    print_success "Code generation completed successfully"
else
    print_error "Code generation failed"
    exit 1
fi

# Step 4: Run analysis
print_status "Running Flutter analysis..."
flutter analyze
if [ $? -eq 0 ]; then
    print_success "Analysis passed"
else
    print_warning "Analysis found issues - please review above"
fi

# Step 5: Run tests
print_status "Running tests..."
flutter test
if [ $? -eq 0 ]; then
    print_success "All tests passed"
else
    print_warning "Some tests failed - please review above"
fi

print_success "Build script completed successfully!"
echo ""
echo "🚀 Ready to run the app with:"
echo "   flutter run --flavor dev --dart-define-from-file=.env.dev"
echo "   flutter run --flavor staging --dart-define-from-file=.env.staging"
echo "   flutter run --flavor prod --dart-define-from-file=.env.prod"
