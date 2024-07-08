#!/bin/bash

haxelib dev priori /priori      && \
bash build-priori-runner.sh     && \
bash build-hello-world.sh       && \

cd examples/example-builder && haxelib run priori build