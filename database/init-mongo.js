// MongoDB initialization script
db = db.getSiblingDB('cloudpipeline');

// Create a user for the application
db.createUser({
  user: 'appuser',
  pwd: 'apppassword',
  roles: [
    {
      role: 'readWrite',
      db: 'cloudpipeline'
    }
  ]
});

// Create initial collection and sample data
db.tasks.insertMany([
  {
    title: 'Welcome to Cloud Pipeline',
    description: 'This is a sample task created during database initialization',
    completed: false,
    createdAt: new Date()
  },
  {
    title: 'Setup Docker Containers',
    description: 'Configure frontend, backend, and database containers',
    completed: true,
    createdAt: new Date()
  }
]);

print('Database initialized successfully!');