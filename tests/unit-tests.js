#!/usr/bin/env node
/**
 * Unit Tests for Cloud Pipeline Application
 */

const http = require('http');
const assert = require('assert');

console.log('🧪 Running Unit Tests...\n');

// Test 1: Server Configuration
function testServerConfig() {
    console.log('Test 1: Server Configuration');
    const PORT = process.env.PORT || 3000;
    assert(PORT === 3000 || PORT === '3000', 'Default port should be 3000');
    console.log('✅ Server configuration test passed\n');
}

// Test 2: Environment Variables
function testEnvironmentVariables() {
    console.log('Test 2: Environment Variables');
    const nodeEnv = process.env.NODE_ENV || 'development';
    assert(typeof nodeEnv === 'string', 'NODE_ENV should be a string');
    console.log(`✅ Environment: ${nodeEnv}\n`);
}

// Test 3: MongoDB URI Format
function testMongoDBURI() {
    console.log('Test 3: MongoDB URI Format');
    const mongoUri = process.env.MONGODB_URI || 'mongodb://admin:password123@localhost:27017/cloudpipeline?authSource=admin';
    assert(mongoUri.includes('mongodb://'), 'MongoDB URI should start with mongodb://');
    assert(mongoUri.includes('cloudpipeline'), 'MongoDB URI should include database name');
    console.log('✅ MongoDB URI format test passed\n');
}

// Test 4: Package Dependencies
function testPackageDependencies() {
    console.log('Test 4: Package Dependencies');
    const packageJson = require('../package.json');
    
    const requiredDeps = ['express', 'mongoose', 'cors', 'dotenv'];
    requiredDeps.forEach(dep => {
        assert(packageJson.dependencies[dep], `${dep} should be in dependencies`);
    });
    console.log('✅ Package dependencies test passed\n');
}

// Test 5: Application Structure
function testApplicationStructure() {
    console.log('Test 5: Application Structure');
    const fs = require('fs');
    
    const requiredFiles = ['server.js', 'package.json', 'public/index.html'];
    requiredFiles.forEach(file => {
        assert(fs.existsSync(file), `${file} should exist`);
    });
    console.log('✅ Application structure test passed\n');
}

// Run all tests
async function runTests() {
    try {
        testServerConfig();
        testEnvironmentVariables();
        testMongoDBURI();
        testPackageDependencies();
        testApplicationStructure();
        
        console.log('🎉 All unit tests passed!');
        console.log('📊 Tests run: 5, Passed: 5, Failed: 0');
        process.exit(0);
    } catch (error) {
        console.error('❌ Unit test failed:', error.message);
        process.exit(1);
    }
}

runTests();