const http = require('http');
const { spawn } = require('child_process');

const child = spawn('node', ['server.js'], {
  env: { ...process.env, PORT: '3999' },
});

setTimeout(() => {
  http.get('http://localhost:3999/health', (res) => {
    if (res.statusCode !== 200) {
      console.error(`expected 200, got ${res.statusCode}`);
      child.kill();
      process.exit(1);
    }
    console.log('health check passed');
    child.kill();
    process.exit(0);
  }).on('error', (err) => {
    console.error(err.message);
    child.kill();
    process.exit(1);
  });
}, 800);
