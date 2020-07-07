#!/bin/bash
set -e

docker run \
    --rm \
    --name kong \
    --publish 5004:5004 \
    elifesciences/kong:${IMAGE_TAG:-latest} 

# stop+remove with:
# docker rm -f loris
