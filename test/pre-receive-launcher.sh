#!/bin/bash

set -e

# first argument is the dir name of the example to compile in fixture
example=$1

export GIT_WORK_TREE=
export dyno_web_url="test.mymachine.me"
export slug_id=1234
export push_code_url="http://127.0.0.1:15612/push"

node & <<EOF
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('v42\n');
}).listen(15612);
EOF

BUILDPACKS_DIR="/tmp/buildpacks"
if [ ! -d "$BUILDPACKS_DIR/buildpacks" ]; then
  mkdir -p $BUILDPACKS_DIR
  curl -o "$BUILDPACKS_DIR/buildpacks.tgz" https://buildkits.herokuapp.com/buildkit/default.tgz
  tar xvzf "$BUILDPACKS_DIR/buildpacks.tgz" -C "$BUILDPACKS_DIR"
fi

rm -fr "/tmp/checkout"
rm -fr "/tmp/cache"
cp -r "fixture/$example" "/tmp/checkout"

OLDREV="master"
NEWREV="master"
REF="refs/heads/master"

../pre-receive <<< "$OLDREV $NEWREV $REF"
