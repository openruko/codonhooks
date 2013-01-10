#!/bin/bash

set -e

php_example="/tmp/checkout"

rm -fr $php_example
mkdir -p $php_example

cat >> "$php_example/index.php" <<EOF
  I have <?= 1+1 ?> foo.
EOF

cat >> "$php_example/Procfile" <<EOF
web: sh boot.sh
EOF

dir=`pwd`
cd $php_example
git init
git add -A
git commit -m "first commit"
cd $dir

expect << EOF
  spawn ./pre-receive-launcher.sh
  expect "PHP app detected"
  expect "Bundling Apache version"
  expect "Bundling PHP version"
  expect "Discovering process types"
  expect "Default process types for PHP -> web"
  expect "Compiled slug size is "
  expect "Using slug_id: 1234"
  expect eof
EOF

rm -fr /app/*
mv /tmp/checkout/* /app

cd /app
cat >> .env << EOF
PATH=bin:$PATH
PORT=9999
EOF

expect << EOF
  spawn foreman start
  expect "Launching apache"
  expect "Apache/"
  expect eof
EOF

expect << EOF
  spawn curl localhost:9999
  expect "I have 2 foo"
  expect eof
EOF

pkill httpd
