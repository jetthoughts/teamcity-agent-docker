#!/bin/sh

echo "[cleanup]"
rm -rf /shared/*

# create folder for sibling to be run
echo "[volume list:]"
docker volume ls

echo "[pre run review ls:]"
ls -al /shared

echo "[create cache folder]"
mkdir -p /shared/cache
ls -al /shared

echo "[add ping message from cache]"
echo "test" > /shared/cache/sibling.ping

echo "[create link folder]"
rm -rf /shared/linked
ln -sf /shared/cache /shared/linked
ls -al /shared/cache

echo "[check ping message]"
docker run \
  -v sharedfolderasnamedfolder_datavolume:/shared \
  alpine \
  /bin/sh -c "cat /shared/linked/sibling.ping"

docker run \
  -v sharedfolderasnamedfolder_datavolume:/shared \
  alpine \
  /bin/sh -c "mkdir -p /shared/linked/first_folder"

echo "[test re-linking when there is existed link]"
rm -rf /shared/linked
ln -sf /shared/cache /shared/linked
ls -al /shared/cache/

docker run \
  -v sharedfolderasnamedfolder_datavolume:/shared \
  alpine \
  /bin/sh -c "echo \"test create file in the shared folder\"; ls /shared/linked; echo \"done from next stage\" > /shared/linked/first_folder/sibling.pong"

docker run \
  -v sharedfolderasnamedfolder_datavolume:/shared \
  alpine \
  /bin/sh -c "echo \"test file has been created in shared folder\"; ls /shared/linked/first_folder"

echo "[check pong message:]"
ls /shared

if [ ! -f /shared/cache/first_folder/sibling.pong ]; then
  echo "[Failed! No such file!]"
  exit 1
else
  echo "[Success!]"
  cat /shared/cache/first_folder/sibling.pong
fi

echo "[check  there is no extra nested links]"
ls -al /shared/cache/

if [ ! -f /shared/cache/cache/sibling.ping ]; then
  echo "[Success!]"
else
  echo "[Failed! Cache should not be re-linked to him self]"
  exit 1
fi

echo "[ls -al /shared/cache/first_folder]"
ls -al /shared/cache/first_folder

echo "[Success All Tests has been passed!]"