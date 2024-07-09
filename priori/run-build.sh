#!/bin/bash

haxelib dev priori /priori      && \
bash build-priori-runner.sh     && \
bash build-hello-world.sh       && \

haxelib run priori build -f example-priori.json