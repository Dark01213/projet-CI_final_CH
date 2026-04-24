# Testing Guide

This guide explains how to run tests for the fullstack application and what they cover.

## Backend Tests

### Running Tests

To run the backend unit tests:

```bash
cd backend
python -m pytest test_app.py -v
```

Or using the Makefile:

```bash
make test-backend
```

### Test Coverage

The backend tests cover the following endpoints and scenarios:

#### Health Check (`/health`)
- ✅ Basic health check response
- ✅ Response contains required fields (status, service, timestamp)

#### Task Management (`/api/tasks`)
- ✅ GET all tasks (empty list)
- ✅ POST create task (valid data)
- ✅ POST create task (missing title - error 400)
- ✅ POST create task (empty payload - error 400)
- ✅ GET specific task by ID
- ✅ GET non-existent task (error 404)
- ✅ PUT update task
- ✅ PUT update non-existent task (error 404)
- ✅ DELETE task
- ✅ DELETE non-existent task (error 404)

#### Application Info (`/api/info`)
- ✅ Basic info response
- ✅ Response contains application, version, and environment

#### Error Handling
- ✅ 404 errors for non-existent routes
- ✅ Proper error response format

### Test Structure

Each test follows this pattern:
1. Setup (using pytest fixtures)
2. Execute request
3. Assert response status and data

Tests are isolated and don't depend on each other, ensuring reliable test execution.

## Frontend Tests

Currently, frontend tests are not implemented. Future enhancements could include:
- Unit tests for JavaScript functions
- Integration tests for API calls
- End-to-end tests with Selenium or Cypress

## Integration Tests

### Docker Compose Testing

To test the full application stack:

```bash
# Start all services
docker-compose up -d

# Run backend tests against running container
docker-compose exec backend python -m pytest test_app.py -v

# Test frontend accessibility
curl http://localhost:8080

# Test backend API
curl http://localhost:5000/health

# Stop services
docker-compose down
```

### CI/CD Testing

The GitHub Actions workflow includes:
- Backend unit tests
- Docker image build verification
- Health check validation
- Deployment testing

## Test Data

Tests use in-memory data that resets between test runs. No persistent data is required.

## Adding New Tests

When adding new endpoints or features:

1. Add corresponding test functions in `test_app.py`
2. Follow the naming convention: `test_<endpoint>_<scenario>`
3. Include both positive and negative test cases
4. Test error conditions and edge cases
5. Update this guide with new test coverage

## Test Reports

For detailed test reports, run:

```bash
cd backend
python -m pytest test_app.py --tb=short --cov=app --cov-report=html
```

This generates coverage reports in `htmlcov/` directory.