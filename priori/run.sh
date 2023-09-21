#!/bin/bash

bash build-priori-unit.sh                   && \
neko ./build/test/priori-unit-test.n        && \
bash run-build.sh                           