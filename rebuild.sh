#!/bin/bash

docker-compose up -d                        && \
docker-compose exec haxe bash run.sh        && \
mv ./priori/run.n ./run.n

docker-compose down --rmi all -v

echo ""
echo "RUN.N GENERATED"
echo ""