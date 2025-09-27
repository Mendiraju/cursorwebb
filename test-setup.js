#!/usr/bin/env node

// Simple test script to verify the Cursor Website setup
const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.join(__dirname, 'database.sqlite');

console.log('🧪 Testing Cursor Website Setup...\n');

// Test 1: Check if database exists and is accessible
console.log('1. Testing database connection...');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.log('❌ Database connection failed:', err.message);
    process.exit(1);
  } else {
    console.log('✅ Database connection successful');
  }
});

// Test 2: Check if tables exist
console.log('2. Testing database tables...');
db.all("SELECT name FROM sqlite_master WHERE type='table'", (err, rows) => {
  if (err) {
    console.log('❌ Failed to query tables:', err.message);
    process.exit(1);
  }
  
  const tableNames = rows.map(row => row.name);
  const requiredTables = ['prompts', 'admin'];
  
  for (const table of requiredTables) {
    if (tableNames.includes(table)) {
      console.log(`✅ Table '${table}' exists`);
    } else {
      console.log(`❌ Table '${table}' missing`);
      process.exit(1);
    }
  }
});

// Test 3: Check if admin user exists
console.log('3. Testing admin user...');
db.get('SELECT COUNT(*) as count FROM admin', (err, row) => {
  if (err) {
    console.log('❌ Failed to check admin users:', err.message);
    process.exit(1);
  }
  
  if (row.count > 0) {
    console.log('✅ Admin user exists');
  } else {
    console.log('❌ No admin users found');
    process.exit(1);
  }
});

// Test 4: Check if sample prompts exist
console.log('4. Testing sample prompts...');
db.get('SELECT COUNT(*) as count FROM prompts', (err, row) => {
  if (err) {
    console.log('❌ Failed to check prompts:', err.message);
    process.exit(1);
  }
  
  if (row.count > 0) {
    console.log(`✅ Found ${row.count} sample prompts`);
  } else {
    console.log('⚠️  No prompts found (run npm run db:seed to add sample data)');
  }
});

// Test 5: Check file permissions
console.log('5. Testing file permissions...');
const fs = require('fs');
try {
  fs.accessSync(dbPath, fs.constants.R_OK | fs.constants.W_OK);
  console.log('✅ Database file is readable and writable');
} catch (err) {
  console.log('❌ Database file permission issues:', err.message);
  process.exit(1);
}

// Close database and finish
db.close((err) => {
  if (err) {
    console.log('❌ Error closing database:', err.message);
    process.exit(1);
  }
  
  console.log('\n🎉 All tests passed! Your Cursor Website is ready to deploy.');
  console.log('\nNext steps:');
  console.log('1. Run: npm run build');
  console.log('2. Run: npm start');
  console.log('3. Visit: http://localhost:3000');
  console.log('4. Admin panel: http://localhost:3000/admin');
  console.log('5. Default credentials: admin / admin123');
  console.log('\nFor VPS deployment, follow the instructions in README.md');
});
