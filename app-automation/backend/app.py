"""
Backend Flask API for the fullstack application.
Provides endpoints for health checks and data management.
"""

from flask import Flask, jsonify, request
from flask_cors import CORS
import os
from datetime import datetime
import logging

app = Flask(__name__)
CORS(app)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# In-memory database (for simplicity)
tasks = []

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint."""
    logger.info("Health check requested")
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'service': 'backend-api'
    }), 200

@app.route('/api/tasks', methods=['GET'])
def get_tasks():
    """Get all tasks."""
    logger.info("GET /api/tasks - retrieving all tasks")
    return jsonify(tasks), 200

@app.route('/api/tasks', methods=['POST'])
def create_task():
    """Create a new task."""
    try:
        data = request.get_json()
        if not data or 'title' not in data:
            return jsonify({'error': 'Title is required'}), 400
        
        task = {
            'id': len(tasks) + 1,
            'title': data['title'],
            'description': data.get('description', ''),
            'completed': False,
            'created_at': datetime.now().isoformat()
        }
        tasks.append(task)
        logger.info(f"Created new task: {task['id']}")
        return jsonify(task), 201
    except Exception as e:
        logger.error(f"Error creating task: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/tasks/<int:task_id>', methods=['GET'])
def get_task(task_id):
    """Get a specific task by ID."""
    task = next((t for t in tasks if t['id'] == task_id), None)
    if not task:
        return jsonify({'error': 'Task not found'}), 404
    logger.info(f"GET /api/tasks/{task_id}")
    return jsonify(task), 200

@app.route('/api/tasks/<int:task_id>', methods=['PUT'])
def update_task(task_id):
    """Update a task."""
    try:
        task = next((t for t in tasks if t['id'] == task_id), None)
        if not task:
            return jsonify({'error': 'Task not found'}), 404
        
        data = request.get_json()
        task.update({
            'title': data.get('title', task['title']),
            'description': data.get('description', task['description']),
            'completed': data.get('completed', task['completed'])
        })
        logger.info(f"Updated task: {task_id}")
        return jsonify(task), 200
    except Exception as e:
        logger.error(f"Error updating task: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    """Delete a task."""
    global tasks
    task = next((t for t in tasks if t['id'] == task_id), None)
    if not task:
        return jsonify({'error': 'Task not found'}), 404
    
    tasks = [t for t in tasks if t['id'] != task_id]
    logger.info(f"Deleted task: {task_id}")
    return jsonify({'message': 'Task deleted'}), 200

@app.route('/api/info', methods=['GET'])
def info():
    """Get application info."""
    return jsonify({
        'application': 'Task Management API',
        'version': '1.0.0',
        'environment': os.getenv('ENVIRONMENT', 'development')
    }), 200

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors."""
    return jsonify({'error': 'Not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors."""
    logger.error(f"Internal server error: {str(error)}")
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    debug = os.getenv('DEBUG', 'False') == 'True'
    app.run(host='0.0.0.0', port=port, debug=debug)
