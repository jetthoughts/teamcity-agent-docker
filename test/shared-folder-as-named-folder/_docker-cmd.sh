#!/bin/sh


# create folder for sibling to be run
echo "volume list:"
docker volume ls

echo "pre run review ls:"
ls /shared
echo "test" > /shared/sibling.ping

echo "added ping message:"
ls /shared

docker run \
  -v sharedfolderasnamedfolder_datavolume:/shared \
  alpine \
  /bin/sh -c "echo \"run sibling check\"; ls /shared; echo \"done from next stage\" > /shared/sibling.pong"

echo "check pong message:"
ls /shared

if [ ! -f /shared/sibling.pong ]; then
  echo "Failed! No such file!"
else
  echo "Success!"
  cat /shared/sibling.pong
fi
