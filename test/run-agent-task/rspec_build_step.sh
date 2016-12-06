#!/usr/bin/env bash

export CACHE_DIR=$AGENT_CACHE_DIR

mkdir -p $AGENT_WORK_DIR/public
ln -s $CACHE_DIR/public_assets/ $AGENT_WORK_DIR/public/assets

mkdir -p $AGENT_WORK_DIR/reports/
ln -s $CACHE_DIR/reports_parallel_tests/ $AGENT_WORK_DIR/reports/parallel_tests

mkdir -p $AGENT_WORK_DIR/tmp/cache
ln -s $CACHE_DIR/cache_assets/ $AGENT_WORK_DIR/tmp/cache/assets

# Setup bundler to use local cache
docker run \
    -v runagenttask_datavolume:/opt/buildAgent \
    -w "$AGENT_WORK_DIR" \
    jetthoughts/oa-rspec:latest bundle config --global path "$CACHE_DIR/gems"

docker run \
    -v runagenttask_datavolume:/opt/buildAgent \
    -v runagenttask_datavolume:/opt/buildAgent \
    -w "$AGENT_WORK_DIR" \
    jetthoughts/oa-rspec:latest bundle config --local path "$CACHE_DIR/gems"

docker run \
  --net runagenttask_default \
  -v runagenttask_datavolume:/opt/buildAgent \
  -w "$AGENT_WORK_DIR" \
  -e DATABASE_URL="$DATABASE_URL" \
  -e CI="true" \
  -e TEST_AGENTS_NUM=1 \
  -e TEST_GROUP=1 \
  jetthoughts/oa-rspec:latest
