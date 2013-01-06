#!/bin/bash

set -e

custom_buildpack_example="fixture/custom-example"

rm -fr $custom_buildpack_example
mkdir -p $custom_buildpack_example

echo -e "#\!/usr/bin/env bash\n echo hello world" > "$custom_buildpack_example/program"
echo -e "program: ./program" > "$custom_buildpack_example/Procfile"
chmod +x "$custom_buildpack_example/program"

dir=`pwd`
cd $custom_buildpack_example
git init
git add -A
git commit -m "first commit"
cd $dir

export BUILDPACK_URL=https://github.com/ryandotsmith/null-buildpack.git
expect << EOF
  spawn ./pre-receive-launcher.sh custom-example
  expect "Fetching custom buildpack"
  expect "Null app detected"
  expect "Nothing to do"
  expect "Procfile declares types -> program"
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
  expect "hello world"
  expect eof
EOF

rm -fr /tmp/buildpacks/buildpacks/custom
