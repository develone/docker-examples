#!/bin/bash
#this is how the docker simple-node-server are stop
#docker container stop $(docker container ls -aq)
echo "stating a simple-node-server port 4000"
docker run --rm -p 4000:80 simple-node-server &
echo "stating a simple-node-server port 4001"
docker run --rm -p 4001:80 simple-node-server &
echo "stating a simple-node-server port 4002"
docker run --rm -p 4002:80 simple-node-server &
