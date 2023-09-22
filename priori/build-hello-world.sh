#!/bin/bash

rm -rf /priori/hello-world
neko ./build/runner/run.n create -p ./hello-world

cd /priori/hello-world
neko ../build/runner/run.n build