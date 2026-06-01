docker buildx build \
     --progress=plain \
     -t george0us/docker-openarc:latest \
     -t george0us/docker-openarc:1.3 \
     -t george0us/docker-openarc:1 \
     --push \
     --platform linux/amd64 \
     . \

#docker build --progress=plain -t george0us/docker-openarc:latest .
