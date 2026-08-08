const express = require('express');

const app = express();
const port = process.env.PORT || 3000;
const version = process.env.APP_VERSION || 'dev';

app.get('/', (req, res) => {
  res.json({ service: 'status-api', version, uptime: process.uptime() });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

app.listen(port, () => {
  console.log(`status-api listening on ${port}, version ${version}`);
});
