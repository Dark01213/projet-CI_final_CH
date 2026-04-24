"""
Tests for the Flask backend API.
"""

import pytest
import json
from app import app


@pytest.fixture
def client():
    """Create a test client for the Flask app."""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


# ──────────────────────────────────────────────
# Health & Info
# ──────────────────────────────────────────────

def test_health_check(client):
    """Test the /health endpoint returns 200 and correct fields."""
    response = client.get('/health')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['status'] == 'healthy'
    assert 'timestamp' in data
    assert data['service'] == 'backend-api'


def test_info_endpoint(client):
    """Test the /api/info endpoint."""
    response = client.get('/api/info')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['application'] == 'Task Management API'
    assert data['version'] == '1.0.0'
    assert 'environment' in data


# ──────────────────────────────────────────────
# GET /api/tasks
# ──────────────────────────────────────────────

def test_get_tasks_empty(client):
    """Test GET /api/tasks returns an empty list initially."""
    response = client.get('/api/tasks')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert isinstance(data, list)


# ──────────────────────────────────────────────
# POST /api/tasks
# ──────────────────────────────────────────────

def test_create_task(client):
    """Test POST /api/tasks creates a task successfully."""
    payload = {'title': 'Test Task', 'description': 'A test task'}
    response = client.post(
        '/api/tasks',
        data=json.dumps(payload),
        content_type='application/json'
    )
    assert response.status_code == 201
    data = json.loads(response.data)
    assert data['title'] == 'Test Task'
    assert data['description'] == 'A test task'
    assert data['completed'] is False
    assert 'id' in data
    assert 'created_at' in data


def test_create_task_missing_title(client):
    """Test POST /api/tasks returns 400 when title is missing."""
    payload = {'description': 'No title here'}
    response = client.post(
        '/api/tasks',
        data=json.dumps(payload),
        content_type='application/json'
    )
    assert response.status_code == 400
    data = json.loads(response.data)
    assert 'error' in data


def test_create_task_empty_body(client):
    """Test POST /api/tasks returns 400 when body is empty."""
    response = client.post(
        '/api/tasks',
        data=json.dumps({}),
        content_type='application/json'
    )
    assert response.status_code == 400


# ──────────────────────────────────────────────
# GET /api/tasks/<id>
# ──────────────────────────────────────────────

def test_get_task_by_id(client):
    """Test GET /api/tasks/<id> returns the correct task."""
    # Create a task first
    payload = {'title': 'Task for GET'}
    post_resp = client.post(
        '/api/tasks',
        data=json.dumps(payload),
        content_type='application/json'
    )
    task_id = json.loads(post_resp.data)['id']

    response = client.get(f'/api/tasks/{task_id}')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['id'] == task_id
    assert data['title'] == 'Task for GET'


def test_get_task_not_found(client):
    """Test GET /api/tasks/<id> returns 404 for non-existent task."""
    response = client.get('/api/tasks/99999')
    assert response.status_code == 404
    data = json.loads(response.data)
    assert 'error' in data


# ──────────────────────────────────────────────
# PUT /api/tasks/<id>
# ──────────────────────────────────────────────

def test_update_task(client):
    """Test PUT /api/tasks/<id> updates a task correctly."""
    payload = {'title': 'Original Title'}
    post_resp = client.post(
        '/api/tasks',
        data=json.dumps(payload),
        content_type='application/json'
    )
    task_id = json.loads(post_resp.data)['id']

    update_payload = {'title': 'Updated Title', 'completed': True}
    response = client.put(
        f'/api/tasks/{task_id}',
        data=json.dumps(update_payload),
        content_type='application/json'
    )
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['title'] == 'Updated Title'
    assert data['completed'] is True


def test_update_task_not_found(client):
    """Test PUT /api/tasks/<id> returns 404 for non-existent task."""
    response = client.put(
        '/api/tasks/99999',
        data=json.dumps({'title': 'Ghost'}),
        content_type='application/json'
    )
    assert response.status_code == 404


# ──────────────────────────────────────────────
# DELETE /api/tasks/<id>
# ──────────────────────────────────────────────

def test_delete_task(client):
    """Test DELETE /api/tasks/<id> removes a task."""
    payload = {'title': 'Task to Delete'}
    post_resp = client.post(
        '/api/tasks',
        data=json.dumps(payload),
        content_type='application/json'
    )
    task_id = json.loads(post_resp.data)['id']

    response = client.delete(f'/api/tasks/{task_id}')
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data['message'] == 'Task deleted'

    # Verify it's actually gone
    get_resp = client.get(f'/api/tasks/{task_id}')
    assert get_resp.status_code == 404


def test_delete_task_not_found(client):
    """Test DELETE /api/tasks/<id> returns 404 for non-existent task."""
    response = client.delete('/api/tasks/99999')
    assert response.status_code == 404


# ──────────────────────────────────────────────
# 404 handler
# ──────────────────────────────────────────────

def test_404_handler(client):
    """Test that unknown routes return 404 JSON."""
    response = client.get('/this/route/does/not/exist')
    assert response.status_code == 404
    data = json.loads(response.data)
    assert 'error' in data