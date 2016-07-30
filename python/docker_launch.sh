#!/usr/bin/env bash

docker run --rm -v $PWD:/tmp/build ardrone /tmp/build/build.sh
