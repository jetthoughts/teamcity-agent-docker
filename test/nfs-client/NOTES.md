Run docker in swarm as siblings by reusing parent docker

```shell
  docker service create --network logging --name logspout --mode global --mount source=/var/run/docker.sock,type=bind,target=/var/run/docker.sock -e SYSLOG_FORMAT=rfc3164 gliderlabs/logspout syslog://logstash:51415
```