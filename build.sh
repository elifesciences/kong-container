#!/bin/bash
docker build --tag elifesciences/kong:${IMAGE_TAG:-latest} .
