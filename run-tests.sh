#!/bin/bash

set -e

cd test
for i in *-test.sh; do "./$i"; done
