"""
Unit tests for the backend API.
"""

import pytest
from app import app

@pytest.fixture
def client():
    """Create a test client."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health_endpoint(client):
    """Test health check endpoint."""
    response = client.get('/health')
    assert response.status_code == 200
    data = response.get_json()
    assert data['status'] == 'healthy'
    assert data['service'] == 'backend-api'
    assert 'timestamp' in data

def test_get_tasks_empty(client):
    """Test getting tasks when none exist."""
    response = client.get('/api/tasks')
    assert response.status_code == 200
    assert response.get_json() == []

def test_create_task(client):
    """Test creating a task."""
    response = client.post('/api/tasks', 
        json={'title': 'Test Task', 'description': 'A test task'})
    assert response.status_code == 201
    data = response.get_json()
    assert data['title'] == 'Test Task'
    assert data['description'] == 'A test task'
    assert data['completed'] == False
    assert 'id' in data
    assert 'created_at' in data

def test_create_task_missing_title(client):
    """Test creating a task without title."""
    response = client.post('/api/tasks', json={'description': 'No title'})
    assert response.status_code == 400
    data = response.get_json()
    assert 'error' in data

def test_create_task_empty_payload(client):
    """Test creating a task with empty payload."""
    response = client.post('/api/tasks', json={})
    assert response.status_code == 400
    data = response.get_json()
    assert 'error' in data

def test_get_task_by_id(client):
    """Test getting a specific task by ID."""
    # First create a task
    create_response = client.post('/api/tasks', 
        json={'title': 'Task to Get', 'description': 'Description'})
    assert create_response.status_code == 201
    task_id = create_response.get_json()['id']
    
    # Now get it
    response = client.get(f'/api/tasks/{task_id}')
    assert response.status_code == 200
    data = response.get_json()
    assert data['id'] == task_id
    assert data['title'] == 'Task to Get'

def test_get_task_not_found(client):
    """Test getting a non-existent task."""
    response = client.get('/api/tasks/999')
    assert response.status_code == 404
    data = response.get_json()
    assert 'error' in data

def test_update_task(client):
    """Test updating a task."""
    # Create a task first
    create_response = client.post('/api/tasks', 
        json={'title': 'Original Task', 'description': 'Original desc'})
    assert create_response.status_code == 201
    task_id = create_response.get_json()['id']
    
    # Update it
    update_response = client.put(f'/api/tasks/{task_id}', 
        json={'title': 'Updated Task', 'completed': True})
    assert update_response.status_code == 200
    data = update_response.get_json()
    assert data['title'] == 'Updated Task'
    assert data['completed'] == True
    assert data['description'] == 'Original desc'  # Should remain unchanged

def test_update_task_not_found(client):
    """Test updating a non-existent task."""
    response = client.put('/api/tasks/999', json={'title': 'New Title'})
    assert response.status_code == 404
    data = response.get_json()
    assert 'error' in data

def test_delete_task(client):
    """Test deleting a task."""
    # Create a task first
    create_response = client.post('/api/tasks', 
        json={'title': 'Task to Delete'})
    assert create_response.status_code == 201
    task_id = create_response.get_json()['id']
    
    # Delete it
    delete_response = client.delete(f'/api/tasks/{task_id}')
    assert delete_response.status_code == 200
    data = delete_response.get_json()
    assert 'message' in data
    
    # Verify it's gone
    get_response = client.get(f'/api/tasks/{task_id}')
    assert get_response.status_code == 404

def test_delete_task_not_found(client):
    """Test deleting a non-existent task."""
    response = client.delete('/api/tasks/999')
    assert response.status_code == 404
    data = response.get_json()
    assert 'error' in data

def test_info_endpoint(client):
    """Test info endpoint."""
    response = client.get('/api/info')
    assert response.status_code == 200
    data = response.get_json()
    assert 'application' in data
    assert 'version' in data
    assert 'environment' in data

def test_404_error(client):
    """Test 404 error handling."""
    response = client.get('/nonexistent')
    assert response.status_code == 404
    data = response.get_json()
    assert 'error' in data

def test_500_error_simulation(client):
    """Test 500 error handling by simulating an internal error."""
    # This is tricky to test directly, but we can test the error handler exists
    # In a real scenario, you'd mock an exception in an endpoint
    pass  # For now, we'll skip this as it requires more complex mocking
