@echo off
REM Test Validation Script for Task Management App
REM This script validates that the testing environment is ready

echo ========================================
echo 🧪 Test Validation Script
echo ========================================
echo.

echo 📦 Checking Python installation...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found in PATH
    echo Please install Python or add it to PATH
    goto :error
) else (
    echo ✅ Python found
)

echo.
echo 📦 Checking pytest installation...
python -c "import pytest; print('pytest version:', pytest.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pytest not installed
    echo Installing pytest...
    pip install pytest pytest-cov
    if %errorlevel% neq 0 (
        echo ❌ Failed to install pytest
        goto :error
    )
) else (
    echo ✅ pytest found
)

echo.
echo 📦 Checking Flask installation...
python -c "import flask; print('Flask version:', flask.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flask not installed
    echo Installing Flask...
    pip install -r requirements.txt
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies
        goto :error
    )
) else (
    echo ✅ Flask found
)

echo.
echo 🧪 Running backend tests...
cd backend
python -m pytest test_app.py -v --tb=short
if %errorlevel% neq 0 (
    echo ❌ Tests failed
    goto :error
) else (
    echo ✅ All tests passed
)

echo.
echo 🎉 Test validation completed successfully!
echo.
echo Next steps:
echo - Run 'docker-compose up -d' to start services
echo - Run 'make test' for Docker-based testing
echo - Check docs/TESTING_GUIDE.md for detailed test information
goto :end

:error
echo.
echo ❌ Test validation failed. Please fix the issues above.
exit /b 1

:end
echo.
pause