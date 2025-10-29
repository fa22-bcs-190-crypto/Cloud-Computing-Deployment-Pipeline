class TaskManager {
    constructor() {
        this.apiUrl = '/api/tasks';
        this.init();
    }

    async init() {
        this.setupEventListeners();
        await this.loadTasks();
        await this.checkHealth();
    }

    setupEventListeners() {
        const taskForm = document.getElementById('taskForm');
        taskForm.addEventListener('submit', (e) => this.handleAddTask(e));
    }

    async handleAddTask(e) {
        e.preventDefault();
        
        const title = document.getElementById('taskTitle').value;
        const description = document.getElementById('taskDescription').value;

        if (!title.trim()) return;

        try {
            const response = await fetch(this.apiUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ title, description }),
            });

            if (response.ok) {
                document.getElementById('taskTitle').value = '';
                document.getElementById('taskDescription').value = '';
                await this.loadTasks();
            } else {
                console.error('Failed to add task');
            }
        } catch (error) {
            console.error('Error adding task:', error);
        }
    }

    async loadTasks() {
        try {
            const response = await fetch(this.apiUrl);
            const tasks = await response.json();
            this.renderTasks(tasks);
        } catch (error) {
            console.error('Error loading tasks:', error);
            this.renderError('Failed to load tasks. Check if MongoDB is running.');
        }
    }

    renderTasks(tasks) {
        const taskList = document.getElementById('taskList');
        
        if (tasks.length === 0) {
            taskList.innerHTML = '<p>No tasks yet. Add your first task above!</p>';
            return;
        }

        taskList.innerHTML = tasks.map(task => `
            <div class="task-item ${task.completed ? 'completed' : ''}">
                <h3>${this.escapeHtml(task.title)}</h3>
                <p>${this.escapeHtml(task.description || 'No description')}</p>
                <small>Created: ${new Date(task.createdAt).toLocaleString()}</small>
                <div class="task-actions">
                    <button class="complete-btn" onclick="taskManager.toggleTask('${task._id}', ${!task.completed})">
                        ${task.completed ? 'Undo' : 'Complete'}
                    </button>
                    <button class="delete-btn" onclick="taskManager.deleteTask('${task._id}')">
                        Delete
                    </button>
                </div>
            </div>
        `).join('');
    }

    renderError(message) {
        const taskList = document.getElementById('taskList');
        taskList.innerHTML = `<div class="error-message" style="color: #dc3545; padding: 20px; text-align: center;">${message}</div>`;
    }

    async toggleTask(id, completed) {
        try {
            const response = await fetch(`${this.apiUrl}/${id}`, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ completed }),
            });

            if (response.ok) {
                await this.loadTasks();
            }
        } catch (error) {
            console.error('Error updating task:', error);
        }
    }

    async deleteTask(id) {
        if (!confirm('Are you sure you want to delete this task?')) return;

        try {
            const response = await fetch(`${this.apiUrl}/${id}`, {
                method: 'DELETE',
            });

            if (response.ok) {
                await this.loadTasks();
            }
        } catch (error) {
            console.error('Error deleting task:', error);
        }
    }

    async checkHealth() {
        try {
            const response = await fetch('/health');
            const health = await response.json();
            
            document.getElementById('environment').textContent = health.environment;
            document.getElementById('healthStatus').textContent = '✅ Healthy';
            document.getElementById('healthStatus').style.color = '#28a745';
            
            // Update deployment status based on environment
            this.updateDeploymentStatus(health.environment);
        } catch (error) {
            document.getElementById('healthStatus').textContent = '❌ Unhealthy';
            document.getElementById('healthStatus').style.color = '#dc3545';
        }
    }

    updateDeploymentStatus(environment) {
        // Simulate deployment pipeline status
        const dockerStatus = document.getElementById('dockerStatus');
        const aksStatus = document.getElementById('aksStatus');
        const githubStatus = document.getElementById('githubStatus');

        // These would be updated based on actual deployment status
        dockerStatus.textContent = '✅';
        dockerStatus.className = 'status completed';

        if (environment === 'production') {
            aksStatus.textContent = '✅';
            aksStatus.className = 'status completed';
        } else {
            aksStatus.textContent = '⏳';
            aksStatus.className = 'status pending';
        }

        githubStatus.textContent = '✅';
        githubStatus.className = 'status completed';
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Initialize the task manager when the page loads
const taskManager = new TaskManager();