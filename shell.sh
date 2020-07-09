#!/bin/bash
set -e

docker run \
    -it \
    --rm \
    --name kong \
    --net host \
    --publish 8000:8000 \
    elifesciences/kong:${IMAGE_TAG:-latest} \
    bash

# stop+remove with:
# docker rm -f kong
