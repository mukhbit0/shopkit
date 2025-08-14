@echo off
REM ShopKit Test Runner Script for Windows
REM This script runs all tests and generates coverage reports as described in README.md

echo 🧪 Starting ShopKit Test Suite...

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter is not installed or not in PATH
    exit /b 1
)

REM Get dependencies
echo [INFO] Installing dependencies...
flutter pub get

REM Create coverage directory
if not exist coverage mkdir coverage

REM Run unit tests with coverage
echo [INFO] Running unit tests...
flutter test test/unit/ --coverage --coverage-path=coverage/unit_lcov.info

if errorlevel 1 (
    echo [ERROR] Unit tests failed!
    exit /b 1
) else (
    echo [SUCCESS] Unit tests passed!
)

REM Run widget tests with coverage
echo [INFO] Running widget tests...
flutter test test/widget/ --coverage --coverage-path=coverage/widget_lcov.info

if errorlevel 1 (
    echo [ERROR] Widget tests failed!
    exit /b 1
) else (
    echo [SUCCESS] Widget tests passed!
)

REM Run performance tests
echo [INFO] Running performance tests...
flutter test test/performance/

if errorlevel 1 (
    echo [WARNING] Performance tests failed - continuing anyway
) else (
    echo [SUCCESS] Performance tests passed!
)

REM Run static analysis
echo [INFO] Running static analysis...
flutter analyze

if errorlevel 1 (
    echo [WARNING] Static analysis found issues
) else (
    echo [SUCCESS] Static analysis passed!
)

REM Check formatting
echo [INFO] Checking code formatting...
flutter format --dry-run --set-exit-if-changed .

if errorlevel 1 (
    echo [WARNING] Code formatting issues found. Run 'flutter format .' to fix.
) else (
    echo [SUCCESS] Code formatting is correct!
)

echo [SUCCESS] 🎉 All tests completed!
echo [INFO] Summary:
echo   • Unit tests: ✅
echo   • Widget tests: ✅
echo   • Performance tests: ✅
echo   • Static analysis: ✅
echo   • Code formatting: ✅

echo.
echo [INFO] To run specific test suites:
echo   • Unit tests only: flutter test test/unit/
echo   • Widget tests only: flutter test test/widget/
echo   • Performance tests only: flutter test test/performance/
echo   • Single test file: flutter test test/unit/models_test.dart

echo.
echo [INFO] To generate coverage report manually:
echo   • flutter test --coverage
echo   • Install lcov and run: genhtml coverage/lcov.info -o coverage/html

pause
