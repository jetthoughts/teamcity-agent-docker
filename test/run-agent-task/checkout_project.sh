#!/usr/bin/env bash

/usr/bin/git fetch --progress origin

mkdir -p $AGENT_WORK_DIR
cd $AGENT_WORK_DIR

cp -r /project/* $AGENT_WORK_DIR/

until nc -z -v mysql 3306; do
  >&2 echo "MySql is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySql is up - executing command"
