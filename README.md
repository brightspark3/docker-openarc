# docker-openarc

Dockernized OpenARC using flowerysong fork

## Usage
### Docker
```shell
docker run -itd --restart=always -p127.0.0.1:8891:8891/tcp \
  -v/srv/openarc:/etc/openarc:ro \
  -v/srv/opendkim/dkimkeys:/etc/dkimkeys \
  --init --name openarc george0us/docker-openarc:latest
```
### Docker Compose
```shell
services:
  app:
    image: george0us/docker-openarc:latest
    container_name: openarc
    ports:
      - "127.0.0.1:8891:8891/tcp"
    volumes:
      - openarc:/etc/openarc:ro
      - /etc/dkimkeys:/etc/dkimkeys
    restart: unless-stopped
volumes:
  openarc:
```
## References
- http://www.trusteddomain.org/
- https://github.com/flowerysong/OpenARC
