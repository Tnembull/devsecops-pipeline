const express = require('express');
const helmet = require('helmet');

const app = express();
const PORT = process.env.PORT || 8080;

// Apply OWASP recommended HTTP security headers
app.use(helmet());
app.use(express.json({ limit: '10kb' }));

// Health probe endpoint for Kubernetes / Docker
app.get('/healthz', (req, res) => {
  res.status(200).json({ status: 'healthy', timestamp: new Date().toISOString() });
});

app.get('/api/v1/info', (req, res) => {
  res.json({
    service: 'secure-node-api',
    environment: process.env.NODE_ENV || 'production',
  });
});

if (require.main === module) {
  app.listen(PORT, '0.0.0.0', () => {
    console.log(`Application listening on port ${PORT}`);
  });
}

module.exports = app;
