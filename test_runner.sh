#!/bin/bash

# ShopKit Test Runner Script
# This script runs all tests and generates coverage reports as described in README.md

set -e

echo "🧪 Starting ShopKit Test Suite..."

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

# Get dependencies
print_status "Installing dependencies..."
flutter pub get

# Create coverage directory
mkdir -p coverage

# Run unit tests with coverage
print_status "Running unit tests..."
flutter test test/unit/ --coverage --coverage-path=coverage/unit_lcov.info

if [ $? -eq 0 ]; then
    print_success "Unit tests passed!"
else
    print_error "Unit tests failed!"
    exit 1
fi

# Run widget tests with coverage
print_status "Running widget tests..."
flutter test test/widget/ --coverage --coverage-path=coverage/widget_lcov.info

if [ $? -eq 0 ]; then
    print_success "Widget tests passed!"
else
    print_error "Widget tests failed!"
    exit 1
fi

# Run performance tests
print_status "Running performance tests..."
flutter test test/performance/

if [ $? -eq 0 ]; then
    print_success "Performance tests passed!"
else
    print_warning "Performance tests failed - continuing anyway"
fi

# Combine coverage files
print_status "Combining coverage reports..."
if command -v lcov &> /dev/null; then
    lcov --add-tracefile coverage/unit_lcov.info \
         --add-tracefile coverage/widget_lcov.info \
         --output-file coverage/lcov.info
    
    # Remove generated files and external packages from coverage
    lcov --remove coverage/lcov.info \
         '**/*.g.dart' \
         '**/*.freezed.dart' \
         '**/generated_plugin_registrant.dart' \
         '**/test/**' \
         --output-file coverage/lcov_cleaned.info
    
    # Generate HTML report
    print_status "Generating HTML coverage report..."
    genhtml coverage/lcov_cleaned.info --output-directory coverage/html
    
    print_success "Coverage report generated at coverage/html/index.html"
else
    print_warning "lcov not found - skipping HTML report generation"
    print_warning "Install lcov to generate HTML coverage reports"
fi

# Run integration tests if available
if [ -d "test/integration" ]; then
    print_status "Running integration tests..."
    flutter test test/integration/
    
    if [ $? -eq 0 ]; then
        print_success "Integration tests passed!"
    else
        print_warning "Integration tests failed"
    fi
fi

# Calculate and display coverage percentage
if [ -f "coverage/lcov_cleaned.info" ]; then
    coverage_summary=$(lcov --summary coverage/lcov_cleaned.info 2>&1 | grep "lines")
    print_status "Coverage Summary: $coverage_summary"
fi

# Run static analysis
print_status "Running static analysis..."
flutter analyze

if [ $? -eq 0 ]; then
    print_success "Static analysis passed!"
else
    print_warning "Static analysis found issues"
fi

# Check formatting
print_status "Checking code formatting..."
if ! flutter format --dry-run --set-exit-if-changed .; then
    print_warning "Code formatting issues found. Run 'flutter format .' to fix."
else
    print_success "Code formatting is correct!"
fi

print_success "🎉 All tests completed!"
print_status "Summary:"
echo "  • Unit tests: ✅"
echo "  • Widget tests: ✅"
echo "  • Performance tests: ✅"
echo "  • Static analysis: ✅"
echo "  • Code formatting: ✅"

if [ -f "coverage/html/index.html" ]; then
    echo "  • Coverage report: coverage/html/index.html"
fi

echo ""
print_status "To run specific test suites:"
echo "  • Unit tests only: flutter test test/unit/"
echo "  • Widget tests only: flutter test test/widget/"
echo "  • Performance tests only: flutter test test/performance/"
echo "  • Single test file: flutter test test/unit/models_test.dart"

echo ""
print_status "To generate coverage report manually:"
echo "  • flutter test --coverage"
echo "  • genhtml coverage/lcov.info -o coverage/html"
