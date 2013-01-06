#!/bin/bash

set -e

node_example="fixture/node-example"

rm -fr $node_example
mkdir -p $node_example

cat >> "$node_example/server.js" <<EOF
  var express = require('express');
  var app = express();
  app.get('/', function(req, res){
    res.send('Hello World');
  });
  var port = process.env.PORT;
  app.listen(port);
  console.log('Listening on port ' + port);
EOF

cat >> "$node_example/Procfile" << EOF
web: node server.js
EOF

cat >> "$node_example/package.json" <<EOF
{
  "name": "hello-world",
  "description": "hello world test app",
  "version": "0.0.1",
  "private": true,
  "engines": {
    "node": "0.8.x",
    "npm": "1.1.x"
  },
  "dependencies": {
    "express": "3.x"
  }
}
EOF

dir=`pwd`
cd $node_example
git init
git add -A
git commit -m "first commit"
cd $dir

expect << EOF
  spawn ./pre-receive-launcher.sh node-example
  expect "Node.js app detected"
  expect "Fetching Node.js binaries"
  expect "Vendoring node into slug"
  expect "Installing dependencies with npm"
  expect "express"
  expect "Discovering process types"
  expect "Procfile declares types -> web"
  expect "Default process types for nodejs"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

cd /tmp/checkout
cat >> .env << EOF
PATH=bin:$PATH
PORT=9999
EOF

expect << EOF
  spawn foreman start
  expect "Listening on port"
  expect eof
EOF

