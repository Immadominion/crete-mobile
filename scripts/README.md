# Crete Project Scripts

This directory contains utility scripts to help with development and deployment of the Crete Flutter project.

## 📋 Available Scripts

### **🏗️ Build Scripts**

#### `build.sh`

Complete build script that performs a full clean build with all checks.

```bash
./scripts/build.sh
```

**What it does:**

- Cleans previous builds
- Gets Flutter dependencies
- Runs code generation
- Performs Flutter analysis
- Runs tests
- Provides build summary

#### `watch.sh`

Continuous code generation during development.

```bash
./scripts/watch.sh
```

**What it does:**

- Watches for file changes
- Automatically regenerates code when files change
- Useful during active development

### **🔍 Quality Assurance**

#### `pre-commit.sh`

Pre-commit checks to ensure code quality before commits.

```bash
./scripts/pre-commit.sh
```

**What it does:**

- Checks if code generation is up to date
- Runs Flutter analysis
- Checks code formatting
- Warns about debugging statements
- Prevents committing environment files
- Runs tests (optional)

#### `setup-hooks.sh`

Installs Git hooks for automated quality checks.

```bash
./scripts/setup-hooks.sh
```

**What it does:**

- Installs pre-commit hook
- Sets up automatic quality checks
- Only needs to be run once per repository

### **✅ Validation Scripts**

#### `validate_step1.dart`

Validates that Step 1 (Environment & Configuration) is complete.

```bash
dart run scripts/validate_step1.dart
```

#### `validate_step2.dart`

Validates that Step 2 (Dependencies & Code Generation) is complete.

```bash
dart run scripts/validate_step2.dart
```

## 🚀 Quick Start

1. **Initial Setup** (run once):

   ```bash
   ./scripts/setup-hooks.sh  # Set up Git hooks
   ```

2. **Development Workflow**:

   ```bash
   ./scripts/watch.sh        # Start watching for changes
   # ... make your changes ...
   git commit                # Pre-commit hooks run automatically
   ```

3. **Before Release**:
   ```bash
   ./scripts/build.sh        # Full build and test
   ```

## 💡 Tips

### Skip Tests in Pre-commit

```bash
SKIP_TESTS=true git commit
```

### Bypass Pre-commit Checks (Not Recommended)

```bash
git commit --no-verify
```

### Manual Quality Check

```bash
./scripts/pre-commit.sh
```

### Watch Code Generation Only

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 📁 Script Requirements

- **Flutter SDK** installed and in PATH
- **Dart SDK** (included with Flutter)
- **Git** (for hooks and version control)
- **Unix-like environment** (macOS, Linux, WSL on Windows)

## 🛠️ Customization

All scripts are designed to be modular and can be customized for specific project needs:

- **Colors**: Modify color constants in each script
- **Checks**: Add or remove quality checks in `pre-commit.sh`
- **Build Steps**: Customize build process in `build.sh`
- **Watch Patterns**: Modify watch patterns in `watch.sh`

## 📖 Integration

These scripts integrate with:

- **VS Code Tasks**: Available through Command Palette (`Ctrl+Shift+P` > "Tasks: Run Task")
- **Git Hooks**: Automatic execution on git operations
- **CI/CD**: Can be used in automated build pipelines
- **Development Workflow**: Part of the daily development process

Happy coding! 🎉
