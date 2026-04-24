#!/bin/bash

# Test Validation Script for Task Management App
# This script validates that the testing environment is ready

echo "========================================"
echo "🧪 Test Validation Script"
echo "========================================"
echo

echo "📦 Checking Python installation..."
if ! command -v python &> /dev/null && ! command -v python3 &> /dev/null; then
    echo "❌ Python not found"
    echo "Please install Python 3.8+"
    exit 1
else
    echo "✅ Python found"
    PYTHON_CMD=$(command -v python3 || command -v python)
fi

echo
echo "📦 Checking pytest installation..."
if ! $PYTHON_CMD -c "import pytest" &> /dev/null; then
    echo "❌ pytest not installed"
    echo "Installing pytest..."
    pip install pytest pytest-cov
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install pytest"
        exit 1
    fi
else
    echo "✅ pytest found"
fi

echo
echo "📦 Checking Flask installation..."
if ! $PYTHON_CMD -c "import flask" &> /dev/null; then
    echo "❌ Flask not installed"
    echo "Installing Flask and dependencies..."
    pip install -r requirements.txt
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install dependencies"
        exit 1
    fi
else
    echo "✅ Flask found"
fi

echo
echo "🧪 Running backend tests..."
cd backend
$PYTHON_CMD -m pytest test_app.py -v --tb=short
if [ $? -ne 0 ]; then
    echo "❌ Tests failed"
    exit 1
else
    echo "✅ All tests passed"
fi

echo
echo "🎉 Test validation completed successfully!"
echo
echo "Next steps:"
echo "- Run 'docker-compose up -d' to start services"
echo "- Run 'make test' for Docker-based testing"
echo "- Check docs/TESTING_GUIDE.md for detailed test information"