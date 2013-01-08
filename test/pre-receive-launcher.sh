#!/bin/bash

set -e

# first argument is the dir name of the example to compile in fixture
example=$1

export GIT_WORK_TREE=
export dyno_web_url="test.mymachine.me"
export slug_id=1234

BUILDPACKS_DIR="/tmp/buildpacks"
if [ ! -d "$BUILDPACKS_DIR/buildpacks" ]; then
  mkdir -p $BUILDPACKS_DIR
  curl -o "$BUILDPACKS_DIR/buildpacks.tgz" https://buildkits.herokuapp.com/buildkit/default.tgz
  tar xvzf "$BUILDPACKS_DIR/buildpacks.tgz" -C "$BUILDPACKS_DIR"
fi

rm -fr "/tmp/cache"

OLDREV="master"
NEWREV="master"
REF="refs/heads/master"

../pre-receive <<< "$OLDREV $NEWREV $REF"

