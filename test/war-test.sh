#!/bin/bash

set -e

war_example="/tmp/checkout"

rm -fr $war_example

git clone --depth 1 https://github.com/heroku/devcenter-webapp-runner.git $war_example
echo "java.runtime.version=1.7" > $war_example/system.properties

export PATH=bin:$PATH

expect << EOF
  spawn ./pre-receive-launcher.sh
  expect "Java app detected"
  expect "Installing OpenJDK 1.7"
  expect "Installing Maven"
  expect "Installing settings.xml"
  expect "mvn"
  expect "Discovering process types"
  expect "Default process types for Java -> web"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

cd $war_example
cat >> .env << EOF
PATH=bin:$PATH
PORT=9999
EOF

foreman start

expect << EOF
  spawn curl localhost:9999
  expect "Hello World!"
  expect eof
EOF
