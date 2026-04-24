// Configuration
const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000';

// API Functions
async function makeRequest(endpoint, options = {}) {
    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers,
            },
            ...options,
        });
        
        if (!response.ok) {
            throw new Error(`API Error: ${response.status}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error('Request failed:', error);
        throw error;
    }
}

async function checkHealth() {
    try {
        const data = await makeRequest('/health');
        updateHealthStatus(true, data);
        return true;
    } catch (error) {
        updateHealthStatus(false);
        return false;
    }
}

async function loadAppInfo() {
    try {
        const data = await makeRequest('/api/info');
        document.getElementById('header-info').textContent = 
            `${data.application} - v${data.version} (${data.environment})`;
    } catch (error) {
        console.error('Failed to load app info:', error);
    }
}

async function loadTasks() {
    try {
        const tasks = await makeRequest('/api/tasks');
        renderTasks(tasks);
    } catch (error) {
        console.error('Failed to load tasks:', error);
        alert('Error loading tasks');
    }
}

async function createTask(title, description) {
    try {
        const task = await makeRequest('/api/tasks', {
            method: 'POST',
            body: JSON.stringify({
                title,
                description
            })
        });
        return task;
    } catch (error) {
        console.error('Failed to create task:', error);
        throw error;
    }
}

async function updateTask(taskId, updates) {
    try {
        const task = await makeRequest(`/api/tasks/${taskId}`, {
            method: 'PUT',
            body: JSON.stringify(updates)
        });
        return task;
    } catch (error) {
        console.error('Failed to update task:', error);
        throw error;
    }
}

async function deleteTask(taskId) {
    try {
        await makeRequest(`/api/tasks/${taskId}`, {
            method: 'DELETE'
        });
    } catch (error) {
        console.error('Failed to delete task:', error);
        throw error;
    }
}

// UI Functions
function updateHealthStatus(isHealthy, data = null) {
    const indicator = document.getElementById('status-indicator');
    const text = document.getElementById('status-text');
    
    if (isHealthy) {
        indicator.classList.remove('unhealthy');
        text.textContent = '✓ Connected to API';
    } else {
        indicator.classList.add('unhealthy');
        text.textContent = '✗ API Unavailable';
    }
}

function renderTasks(tasks) {
    const container = document.getElementById('tasks-container');
    const countSpan = document.getElementById('task-count');
    
    countSpan.textContent = `(${tasks.length})`;
    
    if (tasks.length === 0) {
        container.innerHTML = '<p class="empty-message">No tasks yet. Create one to get started!</p>';
        return;
    }
    
    container.innerHTML = tasks.map(task => `
        <div class="task-item ${task.completed ? 'completed' : ''}">
            <div class="task-header">
                <input 
                    type="checkbox" 
                    class="task-checkbox" 
                    ${task.completed ? 'checked' : ''}
                    onchange="toggleTask(${task.id})"
                >
                <div class="task-title">${escapeHtml(task.title)}</div>
            </div>
            ${task.description ? `<div class="task-description">${escapeHtml(task.description)}</div>` : ''}
            <div class="task-meta">
                <span>Created: ${new Date(task.created_at).toLocaleDateString()}</span>
                <div class="task-actions">
                    <button class="btn-delete" onclick="removeTask(${task.id})">Delete</button>
                </div>
            </div>
        </div>
    `).join('');
}

async function toggleTask(taskId) {
    const tasks = await makeRequest('/api/tasks');
    const task = tasks.find(t => t.id === taskId);
    
    if (task) {
        try {
            await updateTask(taskId, { completed: !task.completed });
            await loadTasks();
        } catch (error) {
            alert('Error updating task');
        }
    }
}

async function removeTask(taskId) {
    if (confirm('Are you sure you want to delete this task?')) {
        try {
            await deleteTask(taskId);
            await loadTasks();
        } catch (error) {
            alert('Error deleting task');
        }
    }
}

function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}

// Event Listeners
document.getElementById('task-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const title = document.getElementById('task-title').value.trim();
    const description = document.getElementById('task-description').value.trim();
    
    if (!title) {
        alert('Please enter a task title');
        return;
    }
    
    try {
        await createTask(title, description);
        document.getElementById('task-form').reset();
        await loadTasks();
    } catch (error) {
        alert('Error creating task');
    }
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', async () => {
    await checkHealth();
    await loadAppInfo();
    await loadTasks();
    
    // Check health every 30 seconds
    setInterval(checkHealth, 30000);
});
