#!/usr/bin/env bash

set -e

echo "Downloading update"
git pull origin main

echo "Killing docker container"
docker kill uischemes
docker rm uischemes

echo "Rebuilding docker container"
docker build -t uis:latest .

echo "Starting docker container"
docker run -d -p 32769:80 --name uischemes uis:latest