#!/usr/bin/env node
/**
 * Integration Tests for Cloud Pipeline Application
 */

const http = require('http');
const mongoose = require('mongoose');

console.log('🔗 Running Integration Tests...\n');

// Test configuration
const API_BASE = process.env.API_BASE || 'http://localhost:3000';
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://admin:password123@localhost:27017/cloudpipeline?authSource=admin';

// Helper function to make HTTP requests
function makeRequest(url, options = {}) {
    return new Promise((resolve, reject) => {
        const req = http.request(url, options, (res) => {
            let data = '';
            res.on('data', chunk => data += chunk);
            res.on('end', () => {
                resolve({
                    statusCode: res.statusCode,
                    headers: res.headers,
                    body: data
                });
            });
        });
        
        req.on('error', reject);
        
        if (options.body) {
            req.write(options.body);
        }
        
        req.end();
    });
}

// Test 1: Database Connection
async function testDatabaseConnection() {
    console.log('Test 1: Database Connection');
    
    try {
        await mongoose.connect(MONGODB_URI);
        console.log('✅ MongoDB connection successful');
        
        // Test database ping
        await mongoose.connection.db.admin().ping();
        console.log('✅ Database ping successful');
        
        await mongoose.disconnect();
        console.log('✅ Database disconnection successful\n');
    } catch (error) {
        console.error('❌ Database connection failed:', error.message);
        throw error;
    }
}

// Test 2: Health Endpoint
async function testHealthEndpoint() {
    console.log('Test 2: Health Endpoint');
    
    try {
        const response = await makeRequest(`${API_BASE}/health`);
        
        if (response.statusCode !== 200) {
            throw new Error(`Expected status 200, got ${response.statusCode}`);
        }
        
        const healthData = JSON.parse(response.body);
        
        if (!healthData.status) {
            throw new Error('Health response missing status field');
        }
        
        console.log(`✅ Health endpoint returned: ${healthData.status}`);
        console.log(`✅ Environment: ${healthData.environment || 'unknown'}\n`);
    } catch (error) {
        console.error('❌ Health endpoint test failed:', error.message);
        throw error;
    }
}

// Test 3: API Tasks Endpoint
async function testTasksEndpoint() {
    console.log('Test 3: Tasks API Endpoint');
    
    try {
        const response = await makeRequest(`${API_BASE}/api/tasks`);
        
        if (response.statusCode !== 200) {
            throw new Error(`Expected status 200, got ${response.statusCode}`);
        }
        
        const tasks = JSON.parse(response.body);
        
        if (!Array.isArray(tasks)) {
            throw new Error('Tasks response should be an array');
        }
        
        console.log(`✅ Tasks endpoint returned ${tasks.length} tasks`);
        
        // Check if sample tasks exist
        if (tasks.length > 0) {
            const sampleTask = tasks[0];
            if (!sampleTask._id || !sampleTask.title) {
                throw new Error('Task objects missing required fields');
            }
            console.log(`✅ Task structure validation passed`);
        }
        
        console.log('✅ Tasks API endpoint test passed\n');
    } catch (error) {
        console.error('❌ Tasks endpoint test failed:', error.message);
        throw error;
    }
}

// Test 4: CORS Headers
async function testCORSHeaders() {
    console.log('Test 4: CORS Headers');
    
    try {
        const response = await makeRequest(`${API_BASE}/api/tasks`);
        
        const corsHeader = response.headers['access-control-allow-origin'];
        if (!corsHeader) {
            throw new Error('CORS headers not found');
        }
        
        console.log(`✅ CORS header present: ${corsHeader}`);
        console.log('✅ CORS configuration test passed\n');
    } catch (error) {
        console.error('❌ CORS test failed:', error.message);
        throw error;
    }
}

// Test 5: Content Type Headers
async function testContentTypeHeaders() {
    console.log('Test 5: Content Type Headers');
    
    try {
        const response = await makeRequest(`${API_BASE}/api/tasks`);
        
        const contentType = response.headers['content-type'];
        if (!contentType || !contentType.includes('application/json')) {
            throw new Error('Expected JSON content type');
        }
        
        console.log(`✅ Content-Type header: ${contentType}`);
        console.log('✅ Content type test passed\n');
    } catch (error) {
        console.error('❌ Content type test failed:', error.message);
        throw error;
    }
}

// Run all integration tests
async function runIntegrationTests() {
    console.log(`🎯 Testing API at: ${API_BASE}`);
    console.log(`🗄️ Testing Database at: ${MONGODB_URI.replace(/\/\/.*@/, '//***:***@')}\n`);
    
    try {
        await testDatabaseConnection();
        await testHealthEndpoint();
        await testTasksEndpoint();
        await testCORSHeaders();
        await testContentTypeHeaders();
        
        console.log('🎉 All integration tests passed!');
        console.log('📊 Tests run: 5, Passed: 5, Failed: 0');
        process.exit(0);
    } catch (error) {
        console.error('\n❌ Integration tests failed:', error.message);
        process.exit(1);
    }
}

// Add timeout for tests
setTimeout(() => {
    console.error('❌ Integration tests timed out after 30 seconds');
    process.exit(1);
}, 30000);

runIntegrationTests();