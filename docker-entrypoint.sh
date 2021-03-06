#!/bin/bash

#export HOSTNAME="freeze"

export AGENT_DIR="/opt/buildAgent/$HOSTNAME"
export DATABASE_URL="mysql2://root@mysql/$HOSTNAME"

#export AGENT_WORK_DIR=$AGENT_DIR/work

# Setup Cache Directories
export AGENT_CACHE_DIR=$AGENT_DIR/cache
mkdir -p $AGENT_CACHE_DIR/

mkdir -p $AGENT_CACHE_DIR/public_assets/
mkdir -p $AGENT_CACHE_DIR/cache_assets/
mkdir -p $AGENT_CACHE_DIR/gems/
mkdir -p $AGENT_CACHE_DIR/reports_parallel_tests/


if [ -z "$TEAMCITY_SERVER" ]; then
    echo "TEAMCITY_SERVER variable not set, launch with -e TEAMCITY_SERVER=http://mybuildserver"
    exit 1
fi

if [ ! -d "$AGENT_DIR/bin" ]; then
    echo "$AGENT_DIR doesn't exist pulling build-agent from server $TEAMCITY_SERVER";
    let waiting=0
    until curl -s -f -I -X GET $TEAMCITY_SERVER/update/buildAgent.zip; do
        let waiting+=3
        sleep 3
        if [ $waiting -eq 120 ]; then
            echo "Teamcity server did not respond within 120 seconds"...
            exit 42
        fi
    done
    wget $TEAMCITY_SERVER/update/buildAgent.zip && unzip -d $AGENT_DIR buildAgent.zip && rm buildAgent.zip
    echo "Downloaded agent to $AGENT_DIR"
    chmod +x $AGENT_DIR/bin/agent.sh
    echo "serverUrl=${TEAMCITY_SERVER}" > $AGENT_DIR/conf/buildAgent.properties
fi

echo "Starting buildagent..."
#chown -R teamcity:teamcity /opt/buildAgent

#gosu teamcity /opt/buildAgent/bin/agent.sh run
sh $AGENT_DIR/bin/agent.sh run
