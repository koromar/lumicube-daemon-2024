#!/bin/bash
apt install qemu-user-static binfmt-support

cat > Dockerfile <<\EOF
# FROM debian:buster-20210111
FROM debian:bookworm
RUN apt update && apt install -y git build-essential autoconf libtool libssl-dev pkg-config cmake
# RUN git clone --branch 6.0.16 https://github.com/redis/redis/ /root/Redis
RUN git clone --branch 7.2.4 https://github.com/redis/redis/ /root/Redis
WORKDIR /root/Redis
RUN make -j4
# RUN git clone --recursive --branch v1.6.9 https://github.com/RedisTimeSeries/RedisTimeSeries.git /root/RedisTimeSeries
RUN git clone --recursive --branch v1.10.11 https://github.com/RedisTimeSeries/RedisTimeSeries.git /root/RedisTimeSeries
WORKDIR /root/RedisTimeSeries
RUN ./deps/readies/bin/getpy3
RUN make -j4 build
EOF

#----------------
# compile for x64
#docker image rm debian:buster-20210111 # Work around Docker not supporting several platform-specific versions of the same image.
docker image rm debian:bookworm # Work around Docker not supporting several platform-specific versions of the same image.
docker build --platform linux/amd64 -t build-redis-x64 .
docker run --rm --entrypoint cat build-redis-x64 /root/Redis/src/redis-server > redis-server-x64
docker run --rm --entrypoint cat build-redis-x64 /root/RedisTimeSeries/bin/linux-x64-release/redistimeseries.so > redistimeseries-x64.so
chmod +x redis-server-x64 redistimeseries-x64.so

#------------------------
# compile for arm (32bit)
#docker image rm debian:buster-20210111 # Work around Docker not supporting several platform-specific versions of the same image.
docker image rm debian:bookworm
docker build --platform linux/arm/v7 -t build-redis-arm .
docker run --rm --entrypoint cat build-redis-arm /root/Redis/src/redis-server > redis-server-arm
docker run --rm --entrypoint cat build-redis-arm /root/RedisTimeSeries/bin/linux-arm32v7-release/redistimeseries.so > redistimeseries-arm.so
chmod +x redis-server-arm redistimeseries-arm.so

#------------------------
# compile for aarch64 (arm 64bit)
#docker image rm debian:buster-20210111 # Work around Docker not supporting several platform-specific versions of the same image.
docker image rm debian:bookworm
docker build --platform linux/arm64 -t build-redis-arm64 .
docker run --rm --entrypoint cat build-redis-arm64 /root/Redis/src/redis-server > redis-server-aarch64
docker run --rm --entrypoint cat build-redis-arm64 /root/RedisTimeSeries/bin/linux-arm64v8-release/redistimeseries.so > redistimeseries-arm64.so
chmod +x redis-server-arm redistimeseries-arm64.so