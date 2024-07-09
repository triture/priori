#!/bin/bash

rm -rf ./build/hello-world                          && \
haxelib run priori create -p ./build/hello-world    && \

cd ./build/hello-world                              && \
haxelib run priori build