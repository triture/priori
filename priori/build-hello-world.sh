#!/bin/bash

rm -rf /priori/hello-world                      && \
haxelib run priori create -p ./hello-world      && \

cd /priori/hello-world                          && \
haxelib run priori build