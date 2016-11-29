#!/bin/sh

until nc -z -v mysql 3306; do
  >&2 echo "MySql is unavailable - sleeping"
  sleep 1
done

>&2 echo "MySql is up - executing command"


docker run --net conncettomysql_default alpine /bin/sh -c "nc -z -v mysql 3306 || echo 'no connect'"


