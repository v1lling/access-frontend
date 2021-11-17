const https = require('https');
const fs = require('fs');

const express = require('express');
const path = require('path');
const app = express();
var session = require('express-session');
var cookieParser = require('cookie-parser');

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

/*
  Session Middleware 
*/

app.use(cookieParser());

function allowCrossDomain(req, res, next) {
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  
  const allowedOrigins = ['http://localhost:8081', 'https://fluttify.herokuapp.com', 'http://localhost:8080'];
  const origin = req.headers.origin;
  if (allowedOrigins.includes(origin)) {
        res.setHeader('Access-Control-Allow-Origin', origin);
  }

  res.setHeader('Access-Control-Allow-Credentials', true);
  res.setHeader("Access-Control-Allow-Headers", [
    "X-Requested-With",
    "Origin",
    "Accept",
    "Content-Type",
    "Cookie",
    "Content-Length",
    "Accept-Language"
  ]);
  if (req.method === 'OPTIONS') {
    res.send(200);
  } else {
      next();
  }
}
app.use(allowCrossDomain);

app.use(session({
    secret: 'CHANGEMELATERSPOTIFLY',
    cookie: {
      secure: false, //change later?
      httpOnly: false, //change later?!
      //maxAge: 1000 * 60 * 60 * 24 * 7 // 1 week
    }
}));

/*
    Middleware to force HTTPS
*/
/*
app.use((req, res, next) => {
  if (!req.secure && req.get('x-forwarded-proto') !== 'https') {
    res.redirect(`https://${req.header('host')}${req.url}`)
  } else {
    next();
  }
});
*/

/* 
    Middleware for serving Vue App
*/
const staticFileMiddleware = express.static(path.join(__dirname + '/../build/web'));
console.log(path.join(__dirname + '/../build/web'));
app.use(staticFileMiddleware);

const options = {
  key: fs.readFileSync('localhost-key.pem'),
  cert: fs.readFileSync('localhost.pem'),
};

var port = 8080;
https
  .createServer(options, app)
  .listen(port, () => {
      console.log("Server listening on port " + port)
  });


  