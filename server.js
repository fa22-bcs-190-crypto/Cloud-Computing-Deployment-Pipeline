const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(express.static('public'));

// MongoDB Connection
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://admin:password123@localhost:27017/cloudpipeline?authSource=admin';

mongoose.connect(MONGODB_URI)
  .then(() => {
    console.log('✅ Connected to MongoDB');
    console.log('📊 Database:', mongoose.connection.db.databaseName);
  })
  .catch(err => {
    console.error('❌ MongoDB connection error:', err);
    console.error('🔧 Make sure MongoDB is running with: docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password123 mongo:7.0');
  });

// Task Schema
const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: String,
  completed: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }
});

const Task = mongoose.model('Task', taskSchema);

// Routes
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// API Routes
app.get('/api/tasks', async (req, res) => {
  try {
    // Check if MongoDB is connected
    if (mongoose.connection.readyState !== 1) {
      return res.status(503).json({ 
        error: 'Database not connected',
        status: 'MongoDB connection is not ready'
      });
    }
    
    const tasks = await Task.find().sort({ createdAt: -1 });
    console.log(`📋 Retrieved ${tasks.length} tasks`);
    res.json(tasks);
  } catch (error) {
    console.error('❌ Error fetching tasks:', error);
    res.status(500).json({ 
      error: error.message,
      details: 'Failed to fetch tasks from database'
    });
  }
});

app.post('/api/tasks', async (req, res) => {
  try {
    const task = new Task(req.body);
    await task.save();
    res.status(201).json(task);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.put('/api/tasks/:id', async (req, res) => {
  try {
    const task = await Task.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(task);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.delete('/api/tasks/:id', async (req, res) => {
  try {
    await Task.findByIdAndDelete(req.params.id);
    res.status(204).send();
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  const dbStatus = mongoose.connection.readyState;
  const dbStates = {
    0: 'disconnected',
    1: 'connected',
    2: 'connecting',
    3: 'disconnecting'
  };
  
  res.json({ 
    status: dbStatus === 1 ? 'healthy' : 'unhealthy', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development',
    database: {
      status: dbStates[dbStatus],
      name: mongoose.connection.db?.databaseName || 'not connected'
    }
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📱 Frontend: http://localhost:${PORT}`);
  console.log(`🔗 API: http://localhost:${PORT}/api/tasks`);
});