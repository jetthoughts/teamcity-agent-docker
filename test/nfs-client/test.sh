#!/usr/bin/env bash


echo "First Invoke: create file"
docker-compose up --build --remove-orphans

echo "Second Invoke: reuse previous created file"
docker-compose up --build --remove-orphans

echo "Should see the old files on the second invoke!"