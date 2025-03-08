const express = require('express');
const path = require('path');
const https = require('https');
const fs = require('fs');
const app = express();
const port = 3000;

app.use(express.static(path.join(__dirname, 'public')));

const options = {
  key: fs.readFileSync('./certs/pem_cert/test01Keystore.pem'), // Private key
  cert: fs.readFileSync('./certs/pem_cert/vishal-dev.com_1.pem'), // SSL certificate
};

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

https.createServer(options, app).listen(443, () => {
  console.log('Server is running on https://localhost:443');
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
